//
//  OrganizationCardView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 08/02/2025.
//

import SwiftUI

struct OrganizationCardView: View {
    @State private var showSheet = false
    var consent: Consent = Consent()

    var body: some View {
        ZStack {
            Color.secondaryGrayBackground
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(consent.enterprise?.name ?? "")
                            .customFont(.headline, fontSize: 24)
                        Text("Shared via QR code")
                            .customFont(.headline, fontSize: 17)
                        Text("1 minute ago")
                            .customFont(.caption, fontSize: 16)
                    }
                    .padding(.bottom, 15)

                    HStack {
                        Button {} label: {
                            Text("Revoke access")
                                .customFont(.title, fontSize: 18)
                                .foregroundStyle(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color("buttonColor"))
                        .cornerRadius(4)
                        .halfSheet(showSheet: $showSheet) {

                        } onEnd: {
                            print("Dismissed Sheet")
                        }

                        HStack {
                            Text(consent.enterprise?.id ?? "")
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
                                .foregroundColor(Color.button)
                            Link("https://www.gtbank.com", destination: URL("https://www.gtbank.com")!)
                                .tint(Color.button)
                        }

                    }
                    .frame(maxWidth: .infinity)
                    .padding(30)
                    .background(Color.white)
                    .mask(
                        RoundedRectangle(cornerRadius: 15, style: .continuous))

                    ConsentDetailsView(consentType: "Account opening", consentDetails: "Full name, Mobile number, Date of birth, Gender, Registered address, photograph", date: "23 July, 2024 10:11 am", consentPermission: "Consent given by you", consentID: 0178239465)
                        .padding(.top, 10)
                }
                .padding()
            }
        }
    }
}

#Preview {
    OrganizationCardView(consent: Consent())
}
