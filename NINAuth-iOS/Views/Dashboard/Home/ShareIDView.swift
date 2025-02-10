//
//  ShareIDView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 06/02/2025.
//

import SwiftUI

struct ShareIDView: View {
    var body: some View {
        ScrollView {
            VStack {
                Spacer()

                Text("Share my ID")
                    .customFont(.subheadline, fontSize: 24)
                Image("qr_code")
                    .resizable()
                    .frame(width: 240, height: 240)
                    .frame(maxWidth: .infinity)

                VStack(alignment: .leading, spacing: 20) {
                    Text("Your QR code is your digital ID. When you share it with an organization, you can select what information can be shared with them.")
                        .padding(.bottom, 10)

                    HStack(alignment: .top) {
                        VStack {
                            Circle()
                                .frame(width: 10, height: 10)
                            RoundedRectangle(cornerRadius: 1)
                                .frame(width: 3, height: 50)
                                .foregroundColor(.gray.opacity(0.4))
                        }
                        Text("Allow organizations or entities to scan the displayed QR code to share your NIN data.")
                            .frame(maxWidth: .infinity, alignment: .top)
                    }
                    .frame(maxWidth: .infinity)

                    HStack(alignment: .top) {
                        VStack {
                            Circle()
                                .frame(width: 10, height: 10)
                            RoundedRectangle(cornerRadius: 1)
                                .frame(width: 3, height: 35)
                                .foregroundColor(.gray.opacity(0.4))
                        }
                        Text("Share the PIN below the QR code for authentication")
                    }

                    HStack(alignment: .top) {
                        Circle()
                            .frame(width: 10, height: 10)
                        Text("QR code changes every 2 minutes")
                    }
                }
                .customFont(.caption, fontSize: 16)
                .frame(maxWidth: .infinity)
                .foregroundColor(.black)
                .padding(20)
                .padding(.vertical, 10)
                .cornerRadius(10)
                .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.transparentGreenBackground))

                Spacer()

                Button {} label: {
                    Text("Got it")
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
}

#Preview {
    ShareIDView()
}
