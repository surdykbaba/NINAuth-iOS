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
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    if case .failed(_) = viewModel.state {
                        displayStatusInfo(imageName: "error", backgroundColor: Color("errorBackground"), title: "Unable to verify your identity", titleMessage: "Want to try again? Ensure you are in a well lit room and your face isn’t covered.")
                    } else {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Verify your identity")
                                .customFont(.headline, fontSize: 24)
                            Text("You will be asked to take a selfie to confirm that you are the owner of the identity number.")
                                .customFont(.body, fontSize: 17)
                        }
                        .padding(.bottom, 40)

                        Image("verifyIdentity")
                            .padding(.bottom, 30)

                        HStack(spacing: 12) {
                            Image(systemName: "info.circle.fill")
                                .frame(width: 24, height: 24)
                                .foregroundStyle(Color("infoBackground"))
                            Text("You will be redirected to a page to complete this process.")
                                .customFont(.subheadline, fontSize: 16)
                        }
                        .padding()
                        .background(Color("infoBackground").opacity(0.1))
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
                    Text("Retry")
                    .customFont(.title, fontSize: 18)
                    .foregroundStyle(.white)
                }else {
                    Text("Continue")
                    .customFont(.title, fontSize: 18)
                    .foregroundStyle(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(Color("buttonColor"))
            .cornerRadius(4)
            .padding()
            .sheet(isPresented: $presentEnroll, content: {
                SmileID.smartSelfieAuthenticationScreenEnhanced(userId: appState.getRandomUniqueNumber(), delegate: self)
            })
        }
    }
    
    func didSucceed(selfieImage: URL, livenessImages: [URL], apiResponse: SmartSelfieResponse?) {
        var registerUserSelfieRequest = RegisterUserSelfieRequest()
        registerUserSelfieRequest.deviceId = appState.getDeviceID()
        
        for img in livenessImages {
            var selfieImage = SelfieImage()
            selfieImage.image_type = "image_type_2"
            selfieImage.image = try? String(contentsOf: img, encoding: .utf8)
            registerUserSelfieRequest.images?.append(selfieImage)
        }
        
        Task {
            await viewModel.registerUserSelfie(registerUserSelfieRequest: registerUserSelfieRequest)
        }
    }
    
    func didError(error: any Error) {
        //TODO: Display error dialog to user
    }
    
    @ViewBuilder
    private func displayStatusInfo(imageName: String, backgroundColor: Color, title: String, titleMessage: String) -> some View {
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
    VerifyIdentityView()
        .environmentObject(AppState())
}
