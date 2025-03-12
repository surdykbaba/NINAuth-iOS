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
                
                Text("2045 4664 7474 7474".localized)
                    .customFont(.title, fontSize: 24)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .offset(x: -25)
                    .padding(.top, 180)
            
            
            
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
