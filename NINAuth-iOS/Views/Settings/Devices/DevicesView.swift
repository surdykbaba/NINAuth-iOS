//
//  DevicesView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 30/01/2025.
//

import SwiftUI

struct DevicesView: View {
    var deviceInfo = [
        DeviceInfo(coordinates: "58.11.253.25", date: "26 July, 2024", isCurrentDevice: true),
        DeviceInfo(coordinates: "58.11.253.25", date: "26 July, 2024", isCurrentDevice: false),
        DeviceInfo(coordinates: "58.11.253.25", date: "26 July, 2024", isCurrentDevice: false)
    ]
    
    var body: some View {
        Color.secondaryGrayBackground
            .ignoresSafeArea()
            .overlay(
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Devices")
                            .padding(.bottom, 10)
                            .padding(.top, 40)
                            .customFont(.headline, fontSize: 24)
                        ForEach(deviceInfo, id: \.self) { info in
                            SingleDeviceView(coordinates: info.coordinates, date: info.date, isCurrentDevice: info.isCurrentDevice)
                        }
                    }
                    .padding()
                })
    }
}

#Preview {
    DevicesView()
}

struct DeviceInfo: Hashable {
    var coordinates: String
    var date: String
    var isCurrentDevice: Bool
}
