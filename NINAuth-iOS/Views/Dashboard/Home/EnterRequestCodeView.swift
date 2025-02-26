//
//  EnterRequestCodeView.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 26/02/2025.
//

import SwiftUI

struct EnterRequestCodeView: View {
    private let numberOfFields = 6
    @State private var requestCode = ""
    @State private var isValid = true
    @FocusState var isFocused: Bool
    @State private var showingAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Enter request code")
                .customFont(.headline, fontSize: 24)
            Text("Enter the 6-digit code provided by the organization.")
                .customFont(.body, fontSize: 16)
                .padding(.bottom, 40)

            OTPView(numberOfFields: numberOfFields, otp: $requestCode, valid: $isValid)
                .onChange(of: requestCode) { newOtp in
                    if newOtp.count == numberOfFields && !newOtp.isEmpty{
                        isValid = true
                    }
                }
                .focused($isFocused)
                .background(Color(.white))
                .frame(height: 56)
                .foregroundColor(Color(.black))

            Button {
                showingAlert = true
            } label: {
                Text("Continue")
                    .customFont(.title, fontSize: 18)
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(isValid ? Color.button : Color.button.opacity(0.2))
            .cornerRadius(4)
            .disabled(!isValid)
            .alert("Invalid pin", isPresented: $showingAlert) {
                Button("Ok"){ }
            }
            .padding(.top, 48)
            
            Spacer()
        }
        .padding()
        .background(Color(.bg))
    }
}

#Preview {
    EnterRequestCodeView()
}
