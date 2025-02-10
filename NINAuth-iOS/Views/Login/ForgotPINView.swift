//
//  ForgetPINView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 07/02/2025.
//

import SwiftUI

struct ForgotPINView: View {
    @State var newPIN: String = ""
    @FocusState var isFocused: Bool
    @State var isValid: Bool = true
    private let numberOfFields = 6

    var body: some View {
        VStack(alignment: .leading) {
            Text("Set a login PIN")
                .customFont(.subheadline, fontSize: 24)
                .padding(.bottom, 5)

            Text("Set a 6-digit PIN for your NINAuth account.")
                .customFont(.body, fontSize: 18)
                .padding(.bottom, 30)

            OTPView(numberOfFields: numberOfFields, otp: $newPIN, valid: $isValid)
                .padding(.bottom, 20)
                .onChange(of: newPIN) { newOtp in
                    if newOtp.count == numberOfFields && !newOtp.isEmpty {
                        isValid = true
                    }
                } .focused($isFocused)

            Text("Entered OTP: \(newPIN)")

            Button {} label: {
                Text("Continue")
                    .customFont(.title, fontSize: 18)
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(Color("buttonColor"))
            .cornerRadius(4)
            .disabled(!isValid)

            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding()
    }
}

#Preview {
    ForgotPINView()
}
