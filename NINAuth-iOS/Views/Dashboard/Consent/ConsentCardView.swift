//
//  ConsentCardView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 06/02/2025.
//

import SwiftUI

struct ConsentCardView: View {
    @State var consent: Consent

    var body: some View {
        NavigationLink {
            ConsentDetailsView(consent: consent)
        } label: {
            HStack {
                HStack(spacing: 30) {
                    RoundedRectangle(cornerRadius: 2)
                        .foregroundColor(consent.status == "approved" ? Color.greenText : Color(.red))
                        .frame(width: 4, height: 80)

                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 10) {
                            Text(consent.enterprise?.name ?? "")
                                .customFont(.headline, fontSize: 17)
                            Image(systemName: "chevron.right")
                        }
                        Text(consent.reason ?? "")
                            .customFont(.body, fontSize: 16)
                        Text(consent.getDisplayDate())
                            .customFont(.subheadline, fontSize: 16)
                    }
                }

                Spacer()

                Image(uiImage: consent.enterprise?.logo?.imageFromBase64 ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
            }
            .frame(maxHeight: 84)
        }
    }
}

#Preview {
    ConsentCardView(consent: Consent())
}
