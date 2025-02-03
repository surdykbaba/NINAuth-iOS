//
//  LoginView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 27/01/2025.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack {
            Button {} label: {
                Text("Login")
                    .customFont(.title, fontSize: 18)
                    .foregroundStyle(Color("buttonColor"))
            }
            .frame(maxWidth: .infinity, alignment: .trailing)

            Spacer()

            Image("NigerianCoatOfArms")

            Spacer()

            VStack(spacing: 10) {
                Text("Verify identity and authorize data access")
                    .customFont(.title, fontSize: 18)
                Text("Ensure your privacy, manage and control access to your NIN data")
                    .customFont(.body, fontSize: 16)
                    .multilineTextAlignment(.center)
            }

            Spacer()

            VStack(spacing: 20) {
                Button {} label: {
                    HStack {
                        Text("Scan QR code")
                        Image(systemName: "qrcode")
                    }
                    .customFont(.title, fontSize: 18)
                    .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(Color("buttonColor"))
                .cornerRadius(4)
                Button {} label: {
                    Text("I have a request code")
                        .customFont(.title, fontSize: 18)
                        .foregroundStyle(Color("buttonColor"))
                }
            }
        }
        .padding()
    }
}

#Preview {
    LoginView()
}
