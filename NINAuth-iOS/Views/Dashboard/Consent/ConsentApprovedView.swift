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
    @State var consent: Consent = Consent()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                ForEach(consents, id: \.id) { consent in
                    ConsentCardView(organizationName: consent.enterprise?.name ?? "", title: consent.reason ?? "", date: consent.created_at ?? "", organizationIcon: consent.enterprise?.logo ?? "", status: consent.status ==  "approved")
                        .onTapGesture {
                            self.consent = consent
                            isPressed.toggle()
                        }
//                                .background(NavigationLink(destination: OrganizationCardView(consent: consent), isActive: $isPressed){}.isDetailLink(false))
                    }
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(.black)
            .padding()
            .cornerRadius(10)
            .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(.white))
            .padding()
        }
        moveToScreen(consent: consent)
    }

    func moveToScreen(consent: Consent) -> some View {
        NavigationLink(destination: OrganizationCardView(consent: consent), isActive: $isPressed){}
    }
}

#Preview {
    ConsentApprovedView(consents: [])
}
