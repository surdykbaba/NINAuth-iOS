//
//  ConsentApprovedView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 06/02/2025.
//

import SwiftUI

struct ConsentApprovedView: View {
    var consents: [Consent]
    @State private var isPressed = false
    var consentsData = [
        Consent(id: "1", userId: "1", enterprise_id: "1", enterprise: Enterprise(id: "1", name: "Guaranty Trust Bank", logo: "gtb_icon", website: "", client_id: ""), data_requested: [], medium: "", reason: "Account opening", status: "approved", created_at: "26, July, 2024", updated_at: ""),
        Consent(id: "2", userId: "1", enterprise_id: "1", enterprise: Enterprise(id: "1", name: "Wema Bank", logo: "gtb_icon", website: "", client_id: ""), data_requested: [], medium: "", reason: "Account opening", status: "rejected", created_at: "26, July, 2024", updated_at: ""),
        Consent(id: "3", userId: "1", enterprise_id: "1", enterprise: Enterprise(id: "1", name: "Providus Bank", logo: "gtb_icon", website: "", client_id: ""), data_requested: [], medium: "", reason: "Account opening", status: "approved", created_at: "26, July, 2024", updated_at: ""),
        Consent(id: "4", userId: "1", enterprise_id: "1", enterprise: Enterprise(id: "1", name: "Guaranty Trust Bank", logo: "gtb_icon", website: "", client_id: ""), data_requested: [], medium: "", reason: "Account opening", status: "rejected", created_at: "26, July, 2024", updated_at: "")
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                    ForEach(consentsData, id: \.id) { consent in
                        NavigationLink(destination: OrganizationCardView(consent: consent), isActive: $isPressed){
                            ConsentCardView(organizationName: consent.enterprise?.name ?? "", title: consent.reason ?? "", date: consent.created_at ?? "", organizationIcon: consent.enterprise?.logo ?? "", status: consent.status ==  "approved")
                        }
                        .onTapGesture {
                            isPressed.toggle()
                        }
//                                .background(NavigationLink(destination: OrganizationCardView(consent: consent), isActive: $isPressed){}.isDetailLink(false))
                    }

                ConsentCardView(organizationName: "Guaranty Trust Bank", title: "Account opening", date: "26 July, 2024", organizationIcon: "gtb_icon", status: true)
                ConsentCardView(organizationName: "Guaranty Trust Bank", title: "Account opening", date: "26 July, 2024", organizationIcon: "gtb_icon", status: true)
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(.black)
            .padding()
            .cornerRadius(10)
            .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(.white))
            .padding()
        }
    }
}

#Preview {
    ConsentApprovedView(consents: [])
}
