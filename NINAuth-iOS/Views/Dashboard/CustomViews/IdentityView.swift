//
//  IdentityView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 06/02/2025.
//

import SwiftUI

struct IdentityView: View {
    var icon: String
    var title: String
    var subtitle: String

    var body: some View {
        HStack(spacing: 20) {
            Image(icon)
                .resizable()
                .frame(width: 40, height: 40)

            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .customFont(.headline, fontSize: 17)
                Text(subtitle)
                    .customFont(.caption, fontSize: 16)
            }

            Spacer()

            Image(systemName: "chevron.right")
        }
        .frame(maxWidth: .infinity)
        .padding()
        .cornerRadius(10)
        .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(.white))
    }
}

#Preview {
    IdentityView(icon: "barcode", title: "Share my ID", subtitle: "Scan the QR code to share identity data")
}
