//
//  VerificationImageStatusView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 27/01/2025.
//

import SwiftUI

struct VerificationImageStatusView: View {
    var image: String
    var backgroundColor: Color

    var body: some View {
        Image(image)
            .resizable()
            .frame(width: 80, height: 80)
            .padding(40)
            .background(backgroundColor)
            .clipShape(Circle())
    }
}

#Preview {
    VerificationImageStatusView(image: "checkmark", backgroundColor: Color("checkmarkBackground"))
}
