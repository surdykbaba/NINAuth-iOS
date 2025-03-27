import SwiftUI

struct SingleDeviceView: View {
    @State var device: Device
    @ObservedObject var viewModel: DeviceViewModel
    @EnvironmentObject private var appState: AppState
    @State private var showSignOut = false

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            if appState.getDeviceID() == device.device_id {
                Text("current_device")
                    .foregroundColor(Color.greenText)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 7)
                    .background(Color.currentDeviceBackground)
                    .mask(RoundedRectangle(cornerRadius: 4, style: .continuous))
            }

            HStack {
                Image("phone")
                    .frame(width: 32, height: 32)
                Text(device.metadata?.os ?? "")
                    .customFont(.headline, fontSize: 18)
                
                Spacer()  // Pushes Unlink button to the right
                
                if appState.getDeviceID() != device.device_id {
                    Button {
                        showSignOut.toggle()
                    } label: {
                        Text("Unlink")
                            .foregroundColor(.red)
                            .customFont(.title, fontSize: 17)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 20)
                    .background(.secondaryGrayBackground)
                    .cornerRadius(8)
                }
            }

            Divider()
            
            HStack {
                Image("coordinates")
                Text(device.system_device_id ?? "")
            }
            .foregroundColor(Color.grayTextBackground)
            .customFont(.headline, fontSize: 17)

            HStack {
                Image("clock")
                Text(device.getDisplayedDate())
            }
            .foregroundColor(Color.grayTextBackground)
            .customFont(.headline, fontSize: 17)

        }
        .padding(20)
        .background(.white)
        .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .alert("Unlink?", isPresented: $showSignOut) {
            Button("OK", role: .destructive) {
                Task {
                    await viewModel.deleteDevice(deviceRequest: DeviceRequest(deviceId: device.device_id))
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to unlink this device?")
        }
    }
}

#Preview {
    SingleDeviceView(device: Device(), viewModel: DeviceViewModel())
        .environmentObject(AppState())
}
