//
//  VerifyIdentityView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 27/01/2025.
//

import SwiftUI
import SmileID

struct VerifyIdentityView: View, SmartSelfieResultDelegate {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = AuthViewModel()
    @State private var presentEnroll = false
    @State private var switchView: Bool = false
    private var defaultDirectory: URL {
        get throws {
            let documentDirectory = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            return documentDirectory.appendingPathComponent("SmileID")
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        if case .failed(_) = viewModel.state {
                            displayStatusInfo(imageName: "error", backgroundColor: Color.errorBackground, title: "unable_to_verify_your_identity".localized, titleMessage: "want_to_try_again?_ensure_you_are_in_a_well_lit_room_and_your_face_isn’t_covered.".localized)
                        } else {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("verify_your_identity".localized)
                                    .customFont(.headline, fontSize: 24)
                                Text("you_will_be_asked_to_take_a_selfie_to_confirm_that_you_are_the_owner_of_the_identity_number.".localized)
                                    .customFont(.body, fontSize: 17)
                            }
                            .padding(.bottom, 40)

                            Image("verify_identity")
                                .padding(.bottom, 30)

                            HStack(spacing: 12) {
                                Image(systemName: "info.circle.fill")
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(Color.verifyInfoBackground)
                                Text("you_will_be_redirected_to_a_page_to_complete_this_process.".localized)
                                    .customFont(.subheadline, fontSize: 16)
                            }
                            .padding()
                            .background(Color.verifyInfoBackground.opacity(0.1))
                            .mask(
                                RoundedRectangle(cornerRadius: 4, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .stroke()
                                .fill(.black.opacity(0.1))
                            )

                        }

                        Spacer()

                        if (viewModel.verifyStatus == "passed") {
                            NavigationLink(destination: VerificationStatusView(verificationStatus: .done), isActive: .constant(true)) {}.isDetailLink(false)
                        }

                        if (viewModel.verifyStatus == "process") {
                            NavigationLink(destination: VerificationStatusView(verificationStatus: .inProgress), isActive: .constant(true)) {}.isDetailLink(false)
                        }
                    }
                }
            }
            .padding()
            .navigationTitle(Text(""))
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .bottom) {
                Button {
                    presentEnroll.toggle()
                } label: {
                    if case .failed(_) = viewModel.state {
                        Text("retry".localized)
                        .customFont(.title, fontSize: 18)
                        .foregroundStyle(.white)
                    }else {
                        Text("continue".localized)
                        .customFont(.title, fontSize: 18)
                        .foregroundStyle(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(Color.button)
                .cornerRadius(4)
                .padding()
                .sheet(isPresented: $presentEnroll, content: {
                    NavigationView {
                        OrchestratedEnhancedSelfieCaptureScreen(userId: appState.getUserRandomUniqueNumber(), isEnroll: false, allowNewEnroll: false, showAttribution: true, showInstructions: true, skipApiSubmission: true, extraPartnerParams: [:], onResult: self)
                    }
//                    SmileID.smartSelfieEnrollmentScreen(delegate: self)
                })
            }

            if case .loading = viewModel.state {
                //TODO: Add your custom loding view here
                ProgressView()
                    .scaleEffect(2)
            }

            Spacer()
        }
    }
    
    func didSucceed(selfieImage: URL, livenessImages: [URL], apiResponse: SmartSelfieResponse?)
    {
        presentEnroll.toggle()
        var registerUserSelfieRequest = RegisterUserSelfieRequest()
        registerUserSelfieRequest.deviceId = appState.getDeviceID()
        registerUserSelfieRequest.images = []
        
        for img in livenessImages {
            var selfieImage = SelfieImage()
            selfieImage.image_type = "image_type_2"
            if let location = try? defaultDirectory.appendingPathComponent(img.absoluteString){
                let stringImg = try? Data(contentsOf: location, options: .alwaysMapped)
                selfieImage.image = stringImg?.base64EncodedString() ?? ""
                registerUserSelfieRequest.images?.append(selfieImage)
            }
        }
        
        Task {
            await viewModel.registerUserSelfie(registerUserSelfieRequest: registerUserSelfieRequest)
        }
    }
    
    func didError(error: any Error) {
        //TODO: Display error dialog to user
        presentEnroll.toggle()
    }
    
    @ViewBuilder
    private func displayStatusInfo(imageName: String, backgroundColor: Color, title: String, titleMessage: String) -> some View {
        VStack(alignment: .center) {
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
}

#Preview {
    VerifyIdentityView()
        .environmentObject(AppState())
}
