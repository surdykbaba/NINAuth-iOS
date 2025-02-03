//
//  SingleDeviceView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 30/01/2025.
//

import SwiftUI

struct SingleDeviceView: View {
    var coordinates: String
    var date: String
    var isCurrentDevice: Bool

    var body: some View {
            VStack(alignment: .leading) {
                if isCurrentDevice {
                    Text("Current device")
                        .foregroundColor(Color.greenText)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 7)
                        .background(Color.currentDeviceBackground)
                        .mask(
                            RoundedRectangle(cornerRadius: 4, style: .continuous))
                        .padding(.bottom, 25)
                }

                HStack {
                    Image("phone")
                        .frame(width: 32, height: 32)
                    Text("Android Phone")
                        .customFont(.headline, fontSize: 18)
                }

                Divider()

                Group {
                    HStack {
                        Image("coordinates")
                        Text(coordinates)
                    }

                    HStack {
                        Image("clock")
                        Text(date)
                    }
                }
                .padding(.top, 10)
                .foregroundColor(Color.grayTextBackground)
                .customFont(.headline, fontSize: 17)

                if !isCurrentDevice {
                    HStack {
                        Spacer()
                        Button {} label: {
                            Text("Sign out")
                                .foregroundColor(.black)
                                .customFont(.title, fontSize: 17)
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 35)
                        .background(.secondaryGrayBackground)
                        .cornerRadius(8)
                    }
                }
            }
            .padding(20)
            .background(.white)
            .mask(
                RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

#Preview {
    SingleDeviceView(coordinates: "58.11.253.25", date: "26 July, 2024", isCurrentDevice: false)
}
