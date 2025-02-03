//
//  VerifyIdentityView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 27/01/2025.
//

import SwiftUI

struct VerifyIdentityView: View {
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 15) {
                Text("Verify your identity")
                    .customFont(.headline, fontSize: 24)
                Text("You will be asked to take a selfie to confirm that you are the owner of the identity number.")
                    .customFont(.body, fontSize: 17)
            }
            .padding(.bottom, 40)

            Image("verifyIdentity")
                .padding(.bottom, 30)

            HStack(spacing: 12) {
                Image(systemName: "info.circle.fill")
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color("infoBackground"))
                Text("You will be redirected to a page to complete this process.")
                    .customFont(.subheadline, fontSize: 16)
            }
            .padding()
            .background(Color("infoBackground").opacity(0.1))
            .mask(
                RoundedRectangle(cornerRadius: 4, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                .stroke()
                .fill(.black.opacity(0.1))
            )

            Spacer()

            Button {} label: {
                    Text("Continue")
                .customFont(.title, fontSize: 18)
                .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(Color("buttonColor"))
            .cornerRadius(4)
        }
        .padding()
    }
}

#Preview {
    VerifyIdentityView()
}
