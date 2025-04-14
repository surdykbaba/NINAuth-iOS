//
//  ResetDeviceView.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 14/04/2025.
//

import SwiftUI

struct ResetDeviceView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Reset Device")
                .font(.largeTitle)
                .bold()

            Text("This will remove all locally stored data and unlink your device. Are you sure?")
                .multilineTextAlignment(.center)
                .padding()

            Button(role: .destructive) {
                // Insert reset logic here
            } label: {
                Text("Confirm Reset")
                    .bold()
            }
            .padding()
        }
        .padding()
    }
}
