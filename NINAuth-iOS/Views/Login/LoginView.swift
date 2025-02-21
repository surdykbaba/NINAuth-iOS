//
//  LoginPinView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 05/02/2025.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel = AuthViewModel()
    @State private var loginPin: String = ""
    @FocusState private var isFocused: Bool
    @State private var isValid: Bool = true
    private let numberOfFields = 6

    var body: some View {
        VStack {
            Image("nigerian_coat_of_arms")
                .padding(.bottom, 10)
                .padding(.top, 30)

            Text("enter_pin_to_login")
                .customFont(.subheadline, fontSize: 20)
                .padding(.bottom, 40)

            OTPView(numberOfFields: numberOfFields, otp: $loginPin, valid: $isValid)
                .padding(.bottom, 20)
                .onChange(of: loginPin) { newOtp in
                    if newOtp.count == numberOfFields && !newOtp.isEmpty {
                        var loginRequest = LoginUserRequest()
                        loginRequest.deviceId = appState.getDeviceID()
                        loginRequest.pin = newOtp
                        loginRequest.device = DeviceMetadata()
                        Task {
                          let user = await viewModel.loginUser(loginUserRequest: loginRequest)
                            appState.user = user
                            print(user ?? User())
                        }
                    }
                } .focused($isFocused)
                .frame(maxHeight: 100)

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
            .disabled(!isValid)
            
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
}

#Preview {
    LoginView()
        .environmentObject(AppState())
}

enum EnterPinState {
    case login
    case forgotPin
}
