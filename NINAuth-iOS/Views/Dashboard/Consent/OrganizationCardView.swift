//
//  OrganizationCardView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 08/02/2025.
//

import SwiftUI

struct OrganizationCardView: View {
    var body: some View {
        ZStack {
            Color.secondaryGrayBackground
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Guaranty Trust Bank")
                        .customFont(.headline, fontSize: 24)
                    Text("Shared via QR code")
                        .customFont(.headline, fontSize: 17)
                    Text("1 minute ago")
                        .customFont(.caption, fontSize: 16)
                }
                .padding(.bottom, 15)

                HStack {
                    Button {} label: {
                        Text("Got it")
                            .customFont(.title, fontSize: 18)
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color("buttonColor"))
                    .cornerRadius(4)

                    HStack {
                        Text("RC:012456")
                        Image(systemName: "square.on.square")
                    }
                    .padding(10)
                    .background(Color.transparentGreenBackground)
                    .mask(
                        RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke()
                        .fill(.gray)
                    )
                }
                .padding(.bottom, 30)

                VStack(spacing: 15) {
                    Image("gtb_icon")
                        .resizable()
                        .frame(width: 72, height: 72)
                    Text("Your data was shared with GT Bank")
                        .customFont(.headline, fontSize: 17)
                    HStack {
                        Image(systemName: "square.on.square")
                            .tint(Color.button)
                        Link("https://www.gtbank.com", destination: URL("https://www.gtbank.com")!)
                            .accentColor(Color.button)
                    }

                }
                .frame(maxWidth: .infinity)
                .padding(30)
                .background(Color.white)
                .mask(
                    RoundedRectangle(cornerRadius: 15, style: .continuous))

                VStack {
                    Text("Consent details")
                        .customFont(.headline, fontSize: 17)
                        .foregroundColor(.gray.opacity(0.2))

                }
            }
            .padding()
        }
    }
}

#Preview {
    OrganizationCardView()
}
