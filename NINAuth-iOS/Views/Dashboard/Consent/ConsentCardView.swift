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
                            .customFont(.caption, fontSize: 16)
                        Text(consent.getDisplayDate())
                            .customFont(.body, fontSize: 16)
                    }
                }

                Spacer()

                AsyncImage(url: URL(string: consent.enterprise?.logo ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 50, height: 50)
            }
        }
    }
}

#Preview {
    ConsentCardView(consent: Consent())
}
