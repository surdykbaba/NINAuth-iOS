//
//  ConsentApprovedView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 06/02/2025.
//

import SwiftUI

struct ConsentApprovedView: View {
    @State private var text = ""
    @State var status : Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                ConsentCardView(organizationName: "Guaranty Trust Bank", title: "Account opening", date: "26 July, 2024", organizationIcon: "gtb_icon", status: $status)
                ConsentCardView(organizationName: "National Health Insurance Scheme", title: "Health insurance registration", date: "2 July, 2024", organizationIcon: "nhis_icon", status: $status)
                ConsentCardView(organizationName: "Nigerian Immigration Service", title: "Passport request", date: "66 June, 2024", organizationIcon: "nis_icon", status: $status)
                ConsentCardView(organizationName: "Guaranty Trust Bank", title: "Account opening", date: "26 July, 2024", organizationIcon: "gtb_icon", status: $status)
                ConsentCardView(organizationName: "National Health Insurance Scheme", title: "Health insurance registration", date: "2 July, 2024", organizationIcon: "nhis_icon", status: $status)
                ConsentCardView(organizationName: "Nigerian Immigration Service", title: "Passport request", date: "66 June, 2024", organizationIcon: "nis_icon", status: $status)
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
    ConsentApprovedView(status: true)
}
