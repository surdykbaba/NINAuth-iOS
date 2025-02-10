//
//  ConsentReviewOrganisationCard.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 09/02/2025.
//

import SwiftUI

struct ConsentReviewOrganisationCard: View {
    var icon: String
    var organisationName: String
    var reason: String

    var body: some View {
        HStack {
            Image(icon)
                .resizable()
                .frame(width: 48, height: 48)

            VStack(alignment: .leading, spacing: 8) {
                Text(organisationName)
                    .customFont(.headline, fontSize: 17)
                Text(reason)
                    .customFont(.subheadline, fontSize: 14)
            }

            Spacer()

            Image("organisation")
                .resizable()
                .frame(width: 21, height: 21)
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        .background(Color.white)
        .mask(
            RoundedRectangle(cornerRadius: 15, style: .continuous))
    }
}


#Preview {
    ConsentReviewOrganisationCard(icon: "nhis_icon", organisationName: "National Health Insurance Scheme", reason: "For Health Insurance Registration")
}
