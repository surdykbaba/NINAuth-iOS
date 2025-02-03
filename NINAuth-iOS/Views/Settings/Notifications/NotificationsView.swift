//
//  NotificationsView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 29/01/2025.
//

import SwiftUI

struct NotificationsView: View {
    var notifications: [Notifications] = [
        Notifications(title: "You have a request from Guaranty Trust Bank", date: "July 26, 2024", details: "Cras sagittis enim proin a integer nonommodo accumsan consequat mauris mole dui dignissim viverra fringilla."),
        Notifications(title: "You have a request from Guaranty Trust Bank", date: "July 26, 2024", details: "Cras sagittis enim proin a integer nonommodo accumsan consequat mauris mole dui dignissim viverra fringilla."),
        Notifications(title: "You have a request from Guaranty Trust Bank", date: "July 26, 2024", details: "Cras sagittis enim proin a integer nonommodo accumsan consequat mauris mole dui dignissim viverra fringilla."),
        Notifications(title: "You have a request from Guaranty Trust Bank", date: "July 26, 2024", details: "Cras sagittis enim proin a integer nonommodo accumsan consequat mauris mole dui dignissim viverra fringilla."),
        Notifications(title: "You have a request from Guaranty Trust Bank", date: "July 26, 2024", details: "Cras sagittis enim proin a integer nonommodo accumsan consequat mauris mole dui dignissim viverra fringilla."),
        Notifications(title: "You have a request from Guaranty Trust Bank", date: "July 26, 2024", details: "Cras sagittis enim proin a integer nonommodo accumsan consequat mauris mole dui dignissim viverra fringilla.")
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Inbox")
                    .padding(.bottom, 50)
                    .customFont(.headline, fontSize: 24)
                VStack(alignment: .leading, spacing: 15) {
                    Text("Notifications")
                        .customFont(.headline, fontSize: 17)
                        .foregroundColor(Color.gray)
                    Divider()
                    ForEach(notifications, id:\.self) { notification in
                        SingleNotificationView(singleNotification: notification)
                            .padding(.bottom, 20)
                    }
                }
            }
            .padding()
        }

    }
}

#Preview {
    NotificationsView()
}

struct Notifications: Hashable {
    var title: String
    var date: String
    var details: String
}
