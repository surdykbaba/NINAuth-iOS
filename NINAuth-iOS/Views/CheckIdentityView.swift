//
//  CheckIdentityView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 27/01/2025.
//

import SwiftUI

struct CheckIdentityView: View {
    @State private var identificationNumber = ""
    @State private var isFormValid: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Enter your National Identification Number")
                .customFont(.headline, fontSize: 24)
            Text("Your information is secure with us and will be used solely for verification purposes.")
                .customFont(.body, fontSize: 17)
                .padding(.bottom, 30)

            VStack(alignment: .leading, spacing: 10) {
                Text("National Identification Number")
                    .customFont(.subheadline, fontSize: 16)
                TextField("12345678910", text: $identificationNumber)
                    .keyboardType(.numberPad)
                    .customTextField()
                    .onChange(of: identificationNumber) { _ in
                        validateNIN()
                    }
            }
            .padding(.bottom, 20)

            Button {
                print(identificationNumber)
            } label: {
                    Text("Continue Verification")
                .customFont(.title, fontSize: 18)
                .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(isFormValid ? Color("buttonColor") : .gray)
            .cornerRadius(4)
            .disabled(!isFormValid)

            Spacer()
        }
        .padding(.top, 20)
        .padding()
    }

    private func validateNIN() {
        isFormValid = !identificationNumber.isEmpty && identificationNumber.count == 11 && identificationNumber.allSatisfy { ("0"..."9").contains($0) }
    }
}

#Preview {
    CheckIdentityView()
}

