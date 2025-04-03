//
//  ForgetPINView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 07/02/2025.
//

import SwiftUI
import RealmSwift

struct SetPINView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = PinViewModel()
    @State private var newPIN: String = ""
    @FocusState private var isFocused: Bool
    @State private var isValid: Bool = true
    private let numberOfFields = 6
    @ObservedResults(Token.self) var token

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("set_a_login_pin")
                    .customFont(.subheadline, fontSize: 24)
                    .padding(.bottom, 5)

                Text("set_a_6-digit_pin_for_your_ninauth_account.".localized)
                    .customFont(.body, fontSize: 18)
                    .padding(.bottom, 30)

                OTPView(numberOfFields: numberOfFields, otp: $newPIN, valid: $isValid)
                    .padding(.bottom, 20)
                    .onChange(of: newPIN) { newOtp in
                        if newOtp.count == numberOfFields && !newOtp.isEmpty {
                            isValid = true
                        }
                    } .focused($isFocused)
                    .frame(maxHeight: 100)

                Button {
                    if(appState.fromForgotPin) {
                        Task {
                            await viewModel.setNewPin(setNewPin: SetNewPin(newPin: newPIN))
                        }
                    }else {
                        Task {
                            await viewModel.setPin(setPinRequest: SetPinRequest(deviceId: appState.getDeviceID(), pin: newPIN, requestCode: token.first?.requestCode))
                        }
                        appState.initialRequestCode = token.first?.requestCode ?? ""
                    }
                } label: {
                    Text("continue".localized)
                        .customFont(.title, fontSize: 18)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(isValid ? Color.button : Color.button.opacity(0.2))
                .cornerRadius(4)
                .disabled(!isValid)

                NavigationLink(destination: TabControllerView(), isActive: $viewModel.pinIsSet) {}.isDetailLink(false)

                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            .navigationTitle(Text(""))
            .navigationBarTitleDisplayMode(.inline)

            if case .loading = viewModel.state {
                //TODO: Add your custom loding view here
                ProgressView()
                    .scaleEffect(2)
            }

            Spacer()
        }
    }
}

#Preview {
    SetPINView()
        .environmentObject(AppState())
}
