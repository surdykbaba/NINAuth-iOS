//
//  LinkedIDsView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 09/02/2025.
//

import SwiftUI

struct LinkedIDsView: View {
    var body: some View {
        ZStack {
            Color.secondaryGrayBackground
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("linked_id")
                            .customFont(.headline, fontSize: 24)
                        Text("view_other_functional_ids_linked_t_your_NIN")
                            .customFont(.caption, fontSize: 17)
                            .padding(.bottom, 20)

                        ForEach(MockData.linkedIDs, id: \.id) { data in
                            LinkedIDsCardView(icon: data.icon, title: data.title, subtitle: data.subtitle)
                                .padding(.top, 10)
                        }
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    LinkedIDsView()
}

// Temporary struct
struct LinkedIDData: Identifiable, Equatable {
    var id = UUID()
    var icon: String
    var title: String
    var subtitle: String
}

// Temporary mock data
struct MockData {
    static var linkedIDs: [LinkedIDData] = [LinkedIDData(icon: "phone_color", title: "Phone Number", subtitle: "2 phone numbers linked"),
        LinkedIDData(icon: "taxID_color", title: "Tax Identification Number", subtitle: "1 Tax ID linked"),
        LinkedIDData(icon: "international_passport", title: "International Passport", subtitle: "No action taken"),
        LinkedIDData(icon: "financial_institution", title: "Financial Institutions", subtitle: "No action taken"),
        LinkedIDData(icon: "educational_institution", title: "Educational Institutions", subtitle: "No action taken"),
        LinkedIDData(icon: "drivers_license", title: "Driver's License", subtitle: "No action taken"),
        LinkedIDData(icon: "voters_id", title: "Voter's ID", subtitle: "No action taken")]

}
