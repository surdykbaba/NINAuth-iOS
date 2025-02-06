//
//  NINAuthCodeView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 05/02/2025.
//

import SwiftUI

struct NINAuthCodeView: View {
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Security PIN")
                    .padding(.bottom, 10)
                    .padding(.top, 40)
                    .customFont(.headline, fontSize: 28)

                Text("Enter the code below with your User ID to  access the NINAuth QR code")
                    .customFont(.body, fontSize: 18)
                    .padding(.bottom, 50)
            }

            VStack(alignment: .center, spacing: 10) {
                Text("697694")
                    .customFont(.subheadline, fontSize: 40)
                Text("Authentication PIN")
                    .customFont(.caption2, fontSize: 14)

                HStack {
                    Image(systemName: "clock.fill")
                        .foregroundColor(.green)
                    Text("00:17")
                }
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background(RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(Color.button.opacity(0.1)))
            }
            .padding(.horizontal, 60)
            .padding(.vertical, 30)
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(.gray, lineWidth: 1)
            )
            .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.grayBackground)
                .shadow(color: Color.secondary, radius: 8, x: 0, y: 10))

            Spacer()

            Button {} label: {
                Text("Copy PIN")
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
    NINAuthCodeView()
}
