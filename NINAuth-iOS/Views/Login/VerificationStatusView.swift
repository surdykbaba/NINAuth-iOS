//
//  VerificationStatusView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 27/01/2025.
//

import SwiftUI

struct VerificationStatusView: View {
    @State var verificationStatus: VerificationStatus = .inProgress
    @EnvironmentObject var appState: AppState
    @State private var goToPin = false

    var body: some View {
        VStack {
            switch verificationStatus {
            case .done:
                displayStatusInfo(imageName: "checkmark_icon", backgroundColor: Color("checkmarkBackground"), title: "Verification done!", titleMessage: "Your identity  has been successfully verified")
            case .failed:
                displayStatusInfo(imageName: "error", backgroundColor: Color("errorBackground"), title: "Unable to verify your identity", titleMessage: "Want to try again? Ensure you are in a well lit room and your face isn’t covered.")
            case .inProgress:
                displayStatusInfo(imageName: "loading", backgroundColor: Color("checkmarkBackground"), title: "Identity verification in process", titleMessage: "The verification process is taking a little longer time to get done... Please wait.")
            }

            Spacer()
            
            if (appState.verifyStatus == "passed") {
                Color.clear.onAppear {
                    verificationStatus = .done
                }
            }
            
            NavigationLink(destination: SetPINView(), isActive: $goToPin) {}.isDetailLink(false)

        }
        .padding(.top, 50)
        .padding()
        .safeAreaInset(edge: .bottom) {
            switch verificationStatus {
            case .done:
                Button {
                    goToPin.toggle()
                } label: {
                        Text("Continue")
                    .customFont(.title, fontSize: 18)
                    .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(Color("buttonColor"))
                .cornerRadius(4)
                .padding()
            case .failed:
                Button {} label: {
                        Text("Retry")
                    .customFont(.title, fontSize: 18)
                    .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(Color("buttonColor"))
                .cornerRadius(4)
                .padding()
            case .inProgress:
                EmptyView()
            }
        }
        .onAppear {
            if (verificationStatus == .inProgress) {
                appState.getFaceAuthStatus(deviceID: appState.getDeviceID())
            }
        }
        .onDisappear {
            appState.timer?.invalidate()
        }
    }

    @ViewBuilder
    func displayStatusInfo(imageName: String, backgroundColor: Color, title: String, titleMessage: String) -> some View {
        VerificationImageStatusView(image: imageName, backgroundColor: backgroundColor)
            .padding(.bottom, 30)
        VStack(spacing: 15) {
            Text(title)
                .customFont(.headline, fontSize: 24)
            Text(titleMessage)
                .customFont(.body, fontSize: 18)
        }
    }
}

#Preview {
    VerificationStatusView()
        .environmentObject(AppState())
}

enum VerificationStatus {
    case done
    case failed
    case inProgress
}
