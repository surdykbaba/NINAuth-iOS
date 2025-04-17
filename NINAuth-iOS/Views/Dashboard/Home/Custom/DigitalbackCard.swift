//  UserQRCodeView.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 15/04/2025.
//

import SwiftUI
import RealmSwift

struct DigitalbackCard: View {
    @EnvironmentObject var appState: AppState
    @ObservedResults(User.self) var user
    @State private var qrImage: UIImage = UIImage()

    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Image("Nin_id_back")
                .resizable()
                .frame(height: 242)
                .clipped()

            Image(uiImage: qrImage)
                .interpolation(.none)
                .resizable()
                .frame(width: 120, height: 120)
                .cornerRadius(4)
                .offset(x: -10, y: -10)
        }
        .frame(maxWidth: 370, maxHeight: 242)
        .onAppear {
            qrImage = appState.generateHashedQRCode(user: user.first)
        }
    }
}

#Preview {
    DigitalbackCard()
        .environmentObject(AppState())
}
