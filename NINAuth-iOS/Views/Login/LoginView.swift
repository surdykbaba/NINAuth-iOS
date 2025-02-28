//
//  LoginPinView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 05/02/2025.
//

import SwiftUI
import RealmSwift
import LocalAuthentication

fileprivate enum ActiveAlert {
    case first, second
}

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = AuthViewModel()
    @State private var loginPin: String = ""
    @FocusState private var isFocused: Bool
    @State private var isValid: Bool = true
    @State private var identificationNumber = ""
    @State private var password: String = ""
    @State private var isFormValid: Bool = false
    @State private var showSendToForgotPin = false
    @State private var goForgotPin: Bool = false
    @State private var biometricsIsOn: Bool = false
    @State private var showDialog: Bool = false
    @State private var msg = ""
    private let mem = MemoryUtil.init()
    @State private var activeAlert: ActiveAlert = .first
    @ObservedResults(User.self) var user

    var body: some View {
        ZStack {
            VStack {
                Image("nigerian_coat_of_arms")
                    .padding(.bottom, 10)
                    .padding(.top, 30)

                Text("enter_pin_to_login".localized)
                    .customFont(.subheadline, fontSize: 20)
                    .padding(.bottom, 40)

                SecureField("nin_number".localized, text: $identificationNumber)
                    .keyboardType(.numberPad)
                    .customTextField()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke()
                        .fill(isFormValid ? .gray : .red)
                    )
                    .onAppear(perform: {
                        isFormValid = true
                        identificationNumber = user.first?.nin ?? ""
                    })
                    .onChange(of: identificationNumber) { _ in
                        if(identificationNumber.count > 11) {
                            identificationNumber = String(identificationNumber.prefix(11))
                        }
                    }

                SecureField("pin_camel".localized, text: $password)
                    .keyboardType(.numberPad)
                    .customTextField()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke()
                            .fill(isFormValid ? .gray : .red)
                    )
                    .onAppear(perform: {
                        isFormValid = true
                    })
                    .onChange(of: password) { _ in
                        if(password.count > 6) {
                            password = String(password.prefix(6))
                        }

                        if(password.count == 6) {
                            if(identificationNumber == "12345678901" && password == "000000") {
                                loginWithNIN()
                            }else if let user = user.first {
                                if(identificationNumber == user.nin) {
                                    loginUser()
                                }else {
                                    showSendToForgotPin.toggle()
                                }
                            }else {
                                loginUser()
                            }
                        }
                    }
                    .padding(.top, 16)

                Button {
                    if(biometricsIsOn){
                        enableBiometrics()
                    }
                } label: {
                    HStack {
                        Text("sign_in_with_biometrics".localized)
                        Image(systemName: "touchid")
                    }
                    .customFont(.title, fontSize: 18)
                    .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(biometricsIsOn ? Color.button : Color.button.opacity(0.1))
                .cornerRadius(4)
                .padding(.top, 24)
                .disabled(!biometricsIsOn)
                .alert(msg, isPresented: $showDialog) {
                    Button("OK", role: .cancel) { }
                }

                Spacer()
                NavigationLink(destination: TabControllerView(), isActive: $viewModel.isLoggedIn) {}.isDetailLink(false)
                NavigationLink(destination: ForgotPinView(), isActive: $goForgotPin) {}.isDetailLink(false)
                
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            .navigationTitle(Text(""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        ForgotPinView()
                    } label: {
                        Text("forgot_pin?".localized)
                            .customFont(.title, fontSize: 18)
                            .foregroundStyle(Color.button)
                    }
                }
            }
            .alert("Your NIN is different, begin authentication to sign in", isPresented: $showSendToForgotPin) {
                Button("OK", role: .cancel) {
                    goForgotPin.toggle()
                }
                Button("Cancel", role: .cancel) { }
            }

            if case .loading = viewModel.state {
                ProgressView()
                    .scaleEffect(2)
            }

            Spacer()
        }
        .onAppear {
            biometricsIsOn = mem.getBoolValue(key: mem.authentication_key)
            if(user.first == nil) {
                biometricsIsOn = false
            }
        }
    }

    func enableBiometrics() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to activate another means of unlocking your application."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        viewModel.isLoggedIn = true
                    } else {
                        msg = authenticationError?.localizedDescription ?? "Failed to authenticate."
                        showDialog.toggle()
                    }
                }
            }
        } else {
            msg = "No Biometrics available on this device."
            showDialog.toggle()
        }
    }

    func loginUser() {
        var loginRequest = LoginUserRequest()
        loginRequest.deviceId = appState.getDeviceID()
        loginRequest.pin = password
        loginRequest.device = DeviceMetadata()
        Task {
            await viewModel.loginUser(loginUserRequest: loginRequest)
        }
    }
    
    func loginWithNIN() {
        var loginRequest = LoginWithNIN()
        loginRequest.deviceId = appState.getDeviceID()
        loginRequest.pin = password
        loginRequest.ninId = identificationNumber
        loginRequest.device = DeviceMetadata()
        Task {
            await viewModel.loginWithNIN(loginWithNIN: loginRequest)
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AppState())
}

enum EnterPinState {
    case login
    case forgotPin
}
