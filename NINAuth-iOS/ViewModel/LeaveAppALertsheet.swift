import SwiftUI

struct LeaveAppAlertSheetView: View {
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

            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.orange)
                .padding(.top, -10)

            Text("You're about to leave the app and open this link in your device's web browser. Would you like to continue?")
                .font(.system(size: 15))
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal)

            HStack(spacing: 12) {
                Button(action: onCancel) {
                    Text("Cancel")
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
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
