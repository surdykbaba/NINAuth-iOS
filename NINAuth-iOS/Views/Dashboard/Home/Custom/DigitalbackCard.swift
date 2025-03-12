//  DigitalbackCard.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 12/03/2025.
//

import SwiftUI
import RealmSwift

struct DigitalbackCard: View {
    @ObservedResults(User.self) var user

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Spacer()
        }
        .frame(height: 242)
        .frame(maxWidth: .infinity, maxHeight: 242, alignment: .leading)
        .background(
            Image("NinBack")
                .resizable()
        )
    }
}

#Preview {
    DigitalbackCard()
}
