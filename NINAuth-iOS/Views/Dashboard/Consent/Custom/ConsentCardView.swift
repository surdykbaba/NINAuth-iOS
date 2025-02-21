//
//  ConsentCardView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 06/02/2025.
//

import SwiftUI

struct ConsentCardView: View {
    var organizationName: String
    var title: String
    var date: String
    var organizationIcon: String

    var status: Bool

    var body: some View {
        HStack(alignment: .top) {
            HStack(spacing: 30) {
                RoundedRectangle(cornerRadius: 2)
                    .foregroundColor(status ? Color.greenText : Color.red)
                    .frame(width: 4, height: 80)

                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 10) {
                        Text(organizationName)
                            .customFont(.headline, fontSize: 17)
                        Image(systemName: "chevron.right")
                    }
                    Text(title)
                        .customFont(.caption, fontSize: 16)
                    Text(date)
                        .customFont(.body, fontSize: 16)
                }
            }

            Spacer()

            Image(organizationIcon)
                .resizable()
                .frame(width: 50, height: 50)
                .cornerRadius(25)
        }
    }
}

#Preview {
    ConsentCardView(organizationName: "Guaranty Trust Bank", title: "Account opening", date: "26 July, 2024", organizationIcon: "gtb_icon", status: true)
}
