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
                ZStack {
                    // Background/frame image
                    Image("Frame") // Make sure this is in Assets
                        .resizable()
                        .frame(width: 120, height: 110)
                        .cornerRadius(4)
                    
                    // QR code on top
                    Image(uiImage: qrImage)
                        .interpolation(.none)
                        .resizable()
                        .frame(width: 102, height: 98)
                        .cornerRadius(4)
                }
                
                (
                    Text("QR code changes every ")
                        .foregroundColor(.white) +
                    Text(formattedTime)
                        .foregroundColor(.green)
                        
                )
                .customFont(.title, fontSize: 8)
                .padding(4)
                .background(Color(hex: "#4DCD94").opacity(0.2))
                .cornerRadius(4)
                .padding(.trailing, 4)
                .padding(.top, 1)
                .offset(x: 5)
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
                        .kerning(3.9) // 39% letter spacing
                        .lineSpacing(0)
                    
                    Text(appState.generateTD1Line2())
                        .font(.system(size: 10, weight: .medium, design: .monospaced))
                        .foregroundColor(.black)
                        .kerning(3.9) // 39% letter spacing
                        .lineSpacing(0)
                    
                    Text(appState.generateTD1Line3())
                        .font(.system(size: 10, weight: .medium, design: .monospaced))
                        .foregroundColor(.black)
                        .kerning(3.9) // 39% letter spacing
                        .lineSpacing(0)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 4)
                .frame(width: 340) // Fixed width to match card width
                //.background(Color.white)
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
