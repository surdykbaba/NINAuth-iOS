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
    var completion : () -> Void

    var body: some View {
            Button {
                self.completion()
            }
            label: {
                HStack(spacing: 20) {
                    Image(icon)
                        .resizable()
                        .frame(width: 40, height: 40)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(title)
                            .bold()
                            .customFont(.headline, fontSize: 17)
                        
                        Text(subtitle)
                            .customFont(.body, fontSize: 16)
                    }
                    .multilineTextAlignment(.leading)

                    Spacer()
                    
                    Image(systemName: "chevron.right")
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.black)
                .padding()
                .cornerRadius(10)
                .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.white))
            }
        }
}

#Preview {
    IdentityView(icon: "barcode", title: "Share my ID", subtitle: "Scan the QR code to share identity data") {}
}
