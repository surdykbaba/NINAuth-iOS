//
//  LinkedIDsCardView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 09/02/2025.
//

import SwiftUI

struct LinkedIDsCardView: View {
    var icon: String
    var title: String
    var subtitle: String

    var body: some View {
        VStack {
            HStack {
                Image(icon)
                    .resizable()
                    .frame(width: 47, height: 47)

                VStack(alignment: .leading) {
                    Text(title)
                        .customFont(.headline, fontSize: 17)
                    Text(subtitle)
                        .customFont(.caption, fontSize: 15)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .resizable()
                    .frame(width: 10, height: 15)
                    .customFont(.headline, fontSize: 15)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(10)
            .padding(.horizontal, 10)
            .background(Color.white)
            .mask(
                RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
    }
}

#Preview {
    LinkedIDsCardView(icon: "taxID_color", title: "Tax Identification Number", subtitle: "1 Tax ID linked")
}
