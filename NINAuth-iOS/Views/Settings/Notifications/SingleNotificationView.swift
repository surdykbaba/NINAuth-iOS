//
//  SingleNotificationView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 29/01/2025.
//

import SwiftUI

struct SingleNotificationView: View {
    var singleNotification: Notifications

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline, spacing: 25) {
                Text(singleNotification.title)
                    .customFont(.title, fontSize: 19)
                Spacer()
                Text(singleNotification.date)
            }
            Text(singleNotification.details)
                .customFont(.subheadline, fontSize: 17)
        }
    }
}

#Preview {
    SingleNotificationView(singleNotification: Notifications(title: "You have a request from Guaranty Trust Bank", date: "July 26, 2024", details: "Cras sagittis enim proin a integer nonommodo accumsan consequat mauris mole dui dignissim viverra fringilla."))
}
