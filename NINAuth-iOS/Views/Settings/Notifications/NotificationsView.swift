//
//  NotificationsView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 29/01/2025.
//

import SwiftUI

struct NotificationsView: View {
    var body: some View {
        VStack {
            Text("No notifications available")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        //.navigationTitle(Text("Notifications"))
        .navigationBarTitleDisplayMode(.large)
        .background(Color(.bg))

    }
}

#Preview {
    NotificationsView()
}
