//
//  InformationCardView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 09/02/2025.
//

import SwiftUI

struct InformationCardView: View {
    var number: Int
    var title: String

    var body: some View {
        HStack(spacing: 20) {
            Text("\(number + 1)")
                .customFont(.title, fontSize: 10)
                .padding(.vertical, 4)
                .padding(.horizontal, 6)
                .overlay (
                    RoundedRectangle(cornerRadius: 1)
                        .stroke(lineWidth: 2)
                )
            Text(title)
                .customFont(.body, fontSize: 17)
        }
    }
}


#Preview {
    InformationCardView(number: 1, title: "Full Name")
}
