import SwiftUI

struct LeaveAppAlertSheetView: View {
    var customMessage: String = ""
    var onConfirm: () -> Void
    var onCancel: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            // Cancel icon in top-right
            HStack {
                Spacer()
                Button(action: onCancel) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .padding(10)
                        .contentShape(Rectangle())
                }
            }

            if(customMessage.isEmpty) {
                // Add the new image here since custom message is always going to be the tap card message
            }else {
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.orange)
                    .padding(.top, -10)
            }

            if(customMessage.isEmpty) {
                Text("You're about to leave the app and open this link in your device's web browser. Would you like to continue?")
                    .customFont(.body, fontSize: 17)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)
            }else {
                Text(customMessage)
                    .customFont(.body, fontSize: 17)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)
            }

            HStack(spacing: 12) {
                if(customMessage.isEmpty) {
                    Button(action: onCancel) {
                        Text("Cancel")
                            .foregroundColor(.green)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(8)
                    }

                }
                Button(action: onConfirm) {
                    Text("Continue")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.button)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    LeaveAppAlertSheetView(
        onConfirm: { print("Confirmed") },
        onCancel: { print("Cancelled") }
    )
}
