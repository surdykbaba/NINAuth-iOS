//
//  ConsentReviewView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 09/02/2025.
//

import SwiftUI

struct ConsentReviewView: View {
    var body: some View {
        ZStack {
            Color.secondaryGrayBackground
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Consent")
                        .customFont(.headline, fontSize: 24)
                    Text("Send your data to this organization")
                        .customFont(.caption, fontSize: 17)
                }
                .padding(.bottom, 20)

                ConsentReviewOrganisationCard(icon: "nhis_icon", organisationName: "National Health Insurance Scheme", reason: "For Health Insurance Registration")
                    .padding(.bottom, 20)

                Text("Before you proceed, please review the information you are sharing")
                    .customFont(.caption, fontSize: 17)
                    .padding(.bottom, 10)

                VStack(alignment: .leading, spacing: 30) {
                    InformationCardView(number: 1, title: "Full Name")
                    InformationCardView(number: 2, title: "Mobile Number")
                    InformationCardView(number: 3, title: "Date of Birth")
                    InformationCardView(number: 4, title: "Gender")
                    InformationCardView(number: 5, title: "Photograph")
                    InformationCardView(number: 6, title: "Registered Address")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
                .background(Color.white)
                .mask(
                    RoundedRectangle(cornerRadius: 10, style: .continuous))

                Spacer()

                HStack(spacing: 5) {
                    Button {} label: {
                        Text("Reject")
                            .customFont(.title, fontSize: 18)
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.red)
                    .cornerRadius(4)
                    
                    Button {} label: {
                        Text("Accept")
                            .customFont(.title, fontSize: 18)
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.button)
                    .cornerRadius(4)
                }
            }
            .padding()
        }

    }
}

#Preview {
    ConsentReviewView()
}
