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
                displayStatusInfo(imageName: "checkmark_icon", backgroundColor: Color("checkmarkBackground"), title: "verification_done!", titleMessage: "your_identity_has_been_successfully_verified")
            case .failed:
                displayStatusInfo(imageName: "error", backgroundColor: Color("errorBackground"), title: "unable_to_verify_your_identity", titleMessage: "want_to_try_again?_ensure_you_are_in_a_well_lit_room_and_your_face_isn’t_covered.")
            case .inProgress:
                displayStatusInfo(imageName: "loading", backgroundColor: Color("checkmarkBackground"), title: "identity_verification_in_process", titleMessage: "the_verification_process_is_taking_a_little_longer_time_to_get_done..._please_wait.")
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
                .background(Color.button)
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
                .background(Color.button)
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
