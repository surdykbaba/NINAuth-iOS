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
        VStack(alignment: .leading) {
            Text("set_a_login_pin")
                .customFont(.subheadline, fontSize: 24)
                .padding(.bottom, 5)

            Text("set_a_6-digit_pin_for_your_ninauth_account.")
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
                Task {
                    await viewModel.setPin(setPinRequest: SetPinRequest(deviceId: appState.getDeviceID(), pin: newPIN, requestCode: token.first?.requestCode))
                }
            } label: {
                Text("Continue")
                    .customFont(.title, fontSize: 18)
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(Color.button)
            .cornerRadius(4)
            .disabled(!isValid)
            
            NavigationLink(destination: LoginView(), isActive: $viewModel.pinIsSet) {}.isDetailLink(false)

            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding()
        .navigationTitle(Text(""))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SetPINView()
}
