//
//  VerifyIdentityView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 27/01/2025.
//

import SwiftUI
import SmileID
import BlusaltLivenessOnly

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
    @State private var startBlu = false
    @State private var livenessResult: Data? = nil
    @State private var imageFile: Data? = nil
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        if case .failed(_) = viewModel.state {
                            displayStatusInfo(imageName: "error", backgroundColor: Color.errorBackground, title: "unable_to_verify_your_identity".localized, titleMessage: "want_to_try_again?_ensure_you_are_in_a_well_lit_room_and_your_face_isn’t_covered.".localized)
                        } else {
                            if(viewModel.verifyStatus == "failed") {
                                displayStatusInfo(imageName: "error", backgroundColor: Color.errorBackground, title: "unable_to_verify_your_identity".localized, titleMessage: "want_to_try_again?_ensure_you_are_in_a_well_lit_room_and_your_face_isn’t_covered.".localized)
                            }else {
                                VStack(alignment: .leading, spacing: 15) {
                                    Text("verify_your_identity".localized)
                                        .customFont(.headline, fontSize: 24)
                                    Text("you_will_be_asked_to_take_a_selfie_to_confirm_that_you_are_the_owner_of_the_identity_number.".localized)
                                        .customFont(.body, fontSize: 17)
                                }
                                .padding(.bottom, 40)

                                Image(.verifyIdentity)
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

                        }

                        Spacer()

                        if (viewModel.verifyStatus == "passed") {
                            NavigationLink(destination: VerificationStatusView(verificationStatus: .done), isActive: .constant(true)) {}.isDetailLink(false)
                        }

                        if (viewModel.verifyStatus == "processing" || viewModel.verifyStatus == "failed") {
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
                        if(viewModel.verifyStatus == "failed") {
                            Text("retry".localized)
                            .customFont(.title, fontSize: 18)
                            .foregroundStyle(.white)
                        }else {
                            Text("continue".localized)
                            .customFont(.title, fontSize: 18)
                            .foregroundStyle(.white)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(Color.button)
                .cornerRadius(4)
                .padding()
                .sheet(isPresented: $presentEnroll, content: {
                    NavigationView {
//                        SmileID.smartSelfieAuthenticationScreenEnhanced(
//                            userId: appState.getUserRandomUniqueNumber(),
//                            allowNewEnroll: false,
//                            showAttribution: false,
//                            showInstructions: true,
//                            extraPartnerParams: [:],
//                            delegate: self
//                        )
                        OrchestratedEnhancedSelfieCaptureScreen(userId: appState.getUserRandomUniqueNumber(), isEnroll: false, allowNewEnroll: false, showAttribution: false, showInstructions: true, skipApiSubmission: true, extraPartnerParams: [:], onResult: self)
                    }
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
    
    private func startBluSalt() {
        if let windowScene = UIApplication.shared.connectedScenes.first
            as? UIWindowScene,
            let viewController = windowScene.windows.first?.rootViewController
          {
            LivenessOnlyManager.shared
              .startFaceDetectionOnlySDK(
                viewController, clientId: "clientId", appName: "appName", apiKey: "apiKey",
                isDev: false, livenessDetectionOnlyType: .MOTIONAL,
                onComplete: { jsonRawValue, livenessSuccess in
                    Log.info(
                    "startLivenessDetectionOnlySDK Demo app is called and is successful")

                    Log.info(
                    "\(String(describing: livenessSuccess.isProcedureValidationPassed))")

                    if let base64 = livenessSuccess.faceDetectionData?.livenessImage {
                        livenessResult = Data(base64Encoded: base64)
                        var registerUserSelfieRequest = RegisterUserSelfieRequest()
                        registerUserSelfieRequest.deviceId = appState.getDeviceID()
                        registerUserSelfieRequest.images = []

                        var selfieImage = SelfieImage()
                        selfieImage.image_type = "image_type_2"
                        selfieImage.image = base64
                        registerUserSelfieRequest.images?.append(selfieImage)

                        Task {
                          await viewModel.registerUserSelfie(registerUserSelfieRequest: registerUserSelfieRequest)
                        }
                    }
                },
                onFailure: {
                  statusCode, errorText in
                    Log.error(
                    "startFacialComparisonSDK Demo app is called and is failed: \(statusCode) \(errorText)"
                  )
                })
          }
    }
}

#Preview {
    VerifyIdentityView()
        .environmentObject(AppState())
}
