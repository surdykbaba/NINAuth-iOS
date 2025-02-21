//
//  LoginPinView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 05/02/2025.
//

import SwiftUI
import RealmSwift

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel = AuthViewModel()
    @State private var loginPin: String = ""
    @FocusState private var isFocused: Bool
    @State private var isValid: Bool = true
    @State private var identificationNumber = ""
    @State private var password: String = ""
    @State private var isFormValid: Bool = false
    @ObservedResults(User.self) var user

    var body: some View {
        VStack {
            Image("nigerian_coat_of_arms")
                .padding(.bottom, 10)
                .padding(.top, 30)

            Text("enter_pin_to_login")
                .customFont(.subheadline, fontSize: 20)
                .padding(.bottom, 40)
            
            SecureField("nin_number", text: $identificationNumber)
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
            
            SecureField("pin_camel", text: $password)
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
                                // TODO: Show user a dialog and refer to reset pin
                            }
                        }else {
                            loginUser()
                        }
                    }
                }
                .padding(.top, 16)

            Button {} label: {
                HStack {
                    Text("sign_in_with_biometrics")
                    Image(systemName: "touchid")
                }
                .customFont(.title, fontSize: 18)
                .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(Color.button)
            .cornerRadius(4)
            .disabled(isValid)
            .padding(.top, 24)
            
            Spacer()
            NavigationLink(destination: TabControllerView(), isActive: $viewModel.isLoggedIn) {}.isDetailLink(false)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding()
        .navigationTitle(Text(""))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    //TODO: Go to forgot Pin View, I can't find it
                    NotificationsView()
                } label: {
                    Text("forgot_pin?")
                        .customFont(.title, fontSize: 18)
                        .foregroundStyle(Color.button)
                }
            }
        }

    }
    
    func loginUser() {
        var loginRequest = LoginUserRequest()
        loginRequest.deviceId = appState.getDeviceID()
        loginRequest.pin = password
        loginRequest.device = DeviceMetadata()
        Task {
            _ = await viewModel.loginUser(loginUserRequest: loginRequest)
        }
    }
    
    func loginWithNIN() {
        var loginRequest = LoginWithNIN()
        loginRequest.deviceId = appState.getDeviceID()
        loginRequest.pin = password
        loginRequest.ninId = identificationNumber
        loginRequest.device = DeviceMetadata()
        Task {
            _ = await viewModel.loginWithNIN(loginWithNIN: loginRequest)
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
