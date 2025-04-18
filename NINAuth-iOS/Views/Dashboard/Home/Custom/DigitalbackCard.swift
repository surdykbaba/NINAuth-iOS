//  UserQRCodeView.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 15/04/2025.
//
import SwiftUI
import RealmSwift

struct DigitalbackCard: View {
    @EnvironmentObject var appState: AppState
    @ObservedResults(User.self) var user
    @State private var qrImage: UIImage = UIImage()
    @State private var remainingSeconds: Int = 1800 // 30 minutes = 1800 seconds
    @State private var timer: Timer?

    var body: some View {
        ZStack(alignment: .top) {
            Image("Back_Card")
                .resizable()
                .frame(height: 242)
                .clipped()

            // Full name on top-left
            VStack(alignment: .leading, spacing: 6) {
                Text("Full name")
                    .foregroundColor(.green)
                    .customFont(.title, fontSize: 7)

                HStack(spacing: 12) {
                    Text(user.first?.last_name ?? "")
                    Text(user.first?.first_name ?? "")
                    Text(String(user.first?.middle_name?.prefix(1) ?? ""))

//                    Text(user.first?.getDOB() ?? "")
                }
                .foregroundColor(.white)
                .customFont(.title, fontSize: 10)
                
                Text("DATE OF BIRTH")
                    .foregroundColor(.green)
                    .customFont(.title, fontSize: 7)
                
                HStack(spacing: 12) {
                 Text(user.first?.getDOB() ?? "")
                }
                .foregroundColor(.white)
                .customFont(.title, fontSize: 10)

            }
            .padding(.leading, 16)
            .padding(.top, 16)
            .frame(maxWidth: .infinity, alignment: .leading) // anchor left

            // QR code on top-right
            // QR code on top-right
            VStack(alignment: .trailing, spacing: 4) {
                ZStack {
                    // Background/frame image
                    Image("Frame") // Make sure this is in Assets
                        .resizable()
                        .frame(width: 100, height: 100)
                        .cornerRadius(4)

                    // QR code on top
                    Image(uiImage: qrImage)
                        .interpolation(.none)
                        .resizable()
                        .frame(width: 90, height: 90)
                        .cornerRadius(4)
                }

                (
                    Text("QR code changes every ")
                        .foregroundColor(.white) +
                    Text(formattedTime)
                        .foregroundColor(.green)
                )
                .customFont(.title, fontSize: 6)
                .padding(4)
                .background(Color(hex: "#4DCD94").opacity(0.2))
                .cornerRadius(4)
                .padding(.trailing, 4)
                .padding(.top, 12)
                .offset(x: 3)
            }
            .padding(.top, 10)
            .padding(.trailing, 10)
            .frame(maxWidth: .infinity, alignment: .trailing)

        }
        .frame(maxWidth: 370, maxHeight: 242)

        .onAppear {
            qrImage = appState.generateHashedQRCode(user: user.first)
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    private var formattedTime: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func startTimer() {
        timer?.invalidate()
        remainingSeconds = 1800 // reset to 30 minutes

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingSeconds > 0 {
                remainingSeconds -= 1
            } else {
                qrImage = appState.generateHashedQRCode(user: user.first)
                remainingSeconds = 1800 // reset after regeneration
            }
        }
    }
}

#Preview {
    DigitalbackCard()
        .environmentObject(AppState())
}
