//
//  LoginPinView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 05/02/2025.
//

import SwiftUI

struct LoginPINView: View {
    @State var loginPin: String = ""
    var currentLoginPin = "123456"
    @FocusState var isFocused: Bool
    @State var isValid: Bool = true
    private let numberOfFields = 6

    var body: some View {
        VStack {
            Button {} label: {
                Text("Forgot PIN?")
                    .customFont(.title, fontSize: 18)
                    .foregroundStyle(Color("buttonColor"))
            }
            .padding(.bottom, 60)
            .frame(maxWidth: .infinity, alignment: .trailing)

            Image("NigerianCoatOfArms")
                .padding(.bottom, 10)

            Text("Enter PIN to login")
                .customFont(.subheadline, fontSize: 20)
                .padding(.bottom, 40)

            OTPView(numberOfFields: numberOfFields, otp: $loginPin, valid: $isValid)
                .padding(.bottom, 20)
                .onChange(of: loginPin) { newOtp in
                    if newOtp.count == numberOfFields && newOtp == currentLoginPin {
                        isValid = true
                    } else if newOtp != currentLoginPin && newOtp.count == numberOfFields {
                        isValid = false
                    }
                } .focused($isFocused)

            Text("Entered OTP: \(loginPin)")

            Button {} label: {
                HStack {
                    Text("Sign in with biometrics")
                    Image(systemName: "touchid")
                }
                .customFont(.title, fontSize: 18)
                .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(Color("buttonColor"))
            .cornerRadius(4)
            .disabled(!isValid)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding()

        Spacer()
    }
}

#Preview {
    LoginPINView()
}

enum EnterPinState {
    case login
    case forgotPin
}
