//
//  ConsentDetailsView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 09/02/2025.
//

import SwiftUI

struct ConsentDetailsView: View {
    var consentType: String
    var consentDetails: String
    var date: String
    var consentPermission: String
    var consentID: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("consent_details".localized)
                .customFont(.headline, fontSize: 17)
                .foregroundColor(.gray.opacity(0.4))
                .padding(.bottom, 10)

            ConsentTrackerView(title: consentType)
            ConsentTrackerView(title: consentDetails)
            ConsentTrackerView(title: date)
            ConsentTrackerView(title: consentPermission)

            HStack(alignment: .top) {
                Circle()
                    .frame(width: 13, height: 13)
                    .foregroundColor(Color.button)
                HStack {
                    Text("id_generated:".localized)
                    Text(String(consentID))
                        .foregroundColor(.orange)
                }
                .customFont(.body, fontSize: 17)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .padding(.vertical, 10)
        .background(Color.white)
        .mask(
            RoundedRectangle(cornerRadius: 15, style: .continuous))
    }
}

#Preview {
    ConsentDetailsView(consentType: "Account opening", consentDetails: "Full name, Mobile number, Date of birth, Gender, Registered address, photograph", date: "23 July, 2024 10:11 am", consentPermission: "Consent given by you", consentID: 0178239465)
}
