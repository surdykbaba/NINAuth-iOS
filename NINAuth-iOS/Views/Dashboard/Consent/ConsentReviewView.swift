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
                    Text("send_your_data_to_this_organization")
                        .customFont(.caption, fontSize: 17)
                }
                .padding(.bottom, 20)

                ConsentReviewOrganisationCard(icon: "nhis_icon", organisationName: "National Health Insurance Scheme", reason: "For Health Insurance Registration")
                    .padding(.bottom, 20)

                Text("before_you_proceed_please_review_the_information_you_are_sharing")
                    .customFont(.caption, fontSize: 17)
                    .padding(.bottom, 10)

                VStack(alignment: .leading, spacing: 30) {
                    InformationCardView(number: 1, title: "full_name")
                    InformationCardView(number: 2, title: "mobile_number")
                    InformationCardView(number: 3, title: "date_of_birth")
                    InformationCardView(number: 4, title: "Gender")
                    InformationCardView(number: 5, title: "Photograph")
                    InformationCardView(number: 6, title: "registered_address")
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
