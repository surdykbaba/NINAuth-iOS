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
    @State private var remainingSeconds: Int = 5000
    @State private var timer: Timer?

    var body: some View {
        ZStack(alignment: .top) {
            Image("NINcard")
                .resizable()
                .frame(height: 242)
                .clipped()
            
            // Full name on top-left
            VStack(alignment: .leading, spacing: 6) {
                Text("FULL NAME")
                    .foregroundColor(.green)
                    .customFont(.title, fontSize: 7)
                
                HStack(spacing: 12) {
                    Text(user.first?.last_name ?? "")
                    Text(user.first?.first_name ?? "")
                    Text(String(user.first?.middle_name?.prefix(1) ?? ""))
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
            VStack(alignment: .trailing, spacing: 4) {
                // QR Code stays on the right
                ZStack {
                    Image("Frame")
                        .resizable()
                        .frame(width: 130, height: 130)
                        .cornerRadius(4)

                    Image(uiImage: qrImage)
                        .interpolation(.none)
                        .resizable()
                        .frame(width: 112, height: 108)
                        .cornerRadius(4)
                }

                // Text moves to the left
                HStack {
                    (
                        Text("QR code changes every ")
                            .foregroundColor(.white) +
                        Text(formattedTime)
                            .foregroundColor(.green)
                    )
                    .customFont(.title, fontSize: 9)
                    .padding(4)
                    .background(Color(hex: "#4DCD94").opacity(0.2))
                    .cornerRadius(5)
                    .padding(.top, -15)
                    .padding(.leading, 17)

                    Spacer() // Pushes the text to the left
                }
            }
            .padding(.top, 10)
            .padding(.trailing, 10)
            .frame(maxWidth: .infinity, alignment: .trailing)

            
            // Machine Readable Zone at the bottom - TD1 format
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                
                // TD1 format MRZ (3 lines of 30 characters)
                VStack(spacing: 2) {
                    Text(appState.generateTD1Line1())
                        .font(.system(size: 10, weight: .medium, design: .monospaced))
                        .foregroundColor(.black)
                        .kerning(3.9)
                        .lineSpacing(0)
                    
                    Text(appState.generateTD1Line2())
                        .font(.system(size: 10, weight: .medium, design: .monospaced))
                        .foregroundColor(.black)
                        .kerning(3.9)
                        .lineSpacing(0)
                    
                    Text(appState.generateTD1Line3())
                        .font(.system(size: 10, weight: .medium, design: .monospaced))
                        .foregroundColor(.black)
                        .kerning(3.9)
                        .lineSpacing(0)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 4)
                .frame(width: 340)
                
                .cornerRadius(4)
                .offset(y: -10)
            }
            
            .padding(.horizontal, 12)
            .padding(.bottom, 8)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
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
        remainingSeconds = 300 //  5 minutes

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingSeconds > 0 {
                remainingSeconds -= 1
            } else {
                qrImage = appState.generateHashedQRCode(user: user.first)
                remainingSeconds = 300 // reset after regeneration
            }
        }
    }

}

#Preview {
    DigitalbackCard()
        .environmentObject(AppState())
}
