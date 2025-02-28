//
//  SingleDeviceView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 30/01/2025.
//

import SwiftUI

struct SingleDeviceView: View {
    @State var device: Device
    @ObservedObject var viewModel: DeviceViewModel
    @EnvironmentObject private var appState: AppState
    @State private var showSignOut = false

    var body: some View {
            VStack(alignment: .leading) {
                if appState.getDeviceID() == device.device_id {
                    Text("current_device")
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
                    Text(device.metadata?.os ?? "")
                        .customFont(.headline, fontSize: 18)
                }

                Divider()

                Group {
//                    HStack {
//                        Image("coordinates")
//                        Text(device.metadata?.os ?? "")
//                    }

                    HStack {
                        Image("clock")
                        Text(device.getDisplayedDate())
                    }
                }
                .padding(.top, 10)
                .foregroundColor(Color.grayTextBackground)
                .customFont(.headline, fontSize: 17)

                if appState.getDeviceID() != device.device_id {
                    HStack {
                        Spacer()
                        Button {
                            showSignOut.toggle()
                        } label: {
                            Text("sign_out")
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
            .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .alert("Sign out?", isPresented: $showSignOut) {
                Button("OK", role: .destructive) {
                    Task {
                        await viewModel.deleteDevice(deviceRequest: DeviceRequest(deviceId: device.device_id))
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("You are about to sign out of device")
            }
    }
}

#Preview {
    SingleDeviceView(device: Device(), viewModel: DeviceViewModel())
        .environmentObject(AppState())
}
