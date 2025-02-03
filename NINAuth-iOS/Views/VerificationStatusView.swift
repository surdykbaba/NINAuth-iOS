//
//  VerificationStatusView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 27/01/2025.
//

import SwiftUI

struct VerificationStatusView: View {
    var verificationStatus: VerificationStatus = .failed

    var body: some View {
        VStack {
            switch verificationStatus {
            case .done:
                displayStatusInfo(imageName: "checkmarkLogo", backgroundColor: Color("checkmarkBackground"), title: "Verification done!", titleMessage: "Your identity  has been successfully verified")
            case .failed:
                displayStatusInfo(imageName: "error", backgroundColor: Color("errorBackground"), title: "Unable to verify your identity", titleMessage: "Want to try again? Ensure you are in a well lit room and your face isn’t covered.")
            case .inProgress:
                displayStatusInfo(imageName: "loading", backgroundColor: Color("checkmarkBackground"), title: "Identity verification in process", titleMessage: "The verification process is taking a little longer time to get done... Please wait.")
            }

            Spacer()

            switch verificationStatus {
            case .done:
                Button {} label: {
                        Text("Continue")
                    .customFont(.title, fontSize: 18)
                    .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(Color("buttonColor"))
                .cornerRadius(4)
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
            case .inProgress:
                EmptyView()
            }


        }
        .padding(.top, 50)
        .padding()
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
}

enum VerificationStatus {
    case done
    case failed
    case inProgress
}
