//////
//////  VerifyIdentityView 2.swift
//////  NINAuth-iOS
//////
//////  Created by Arogundade Qoyum on 22/05/2025.
//////
////
////
////import SwiftUI
////import SmileID
////import BlusaltLivenessOnly
////import UIKit
////
////struct VerifyIdentityView: View, SmartSelfieResultDelegate {
////    @State var nin: String? = ""
////    @State var userID: String = ""
////    @EnvironmentObject var appState: AppState
////    @StateObject private var viewModel = AuthViewModel()
////    @State private var presentEnroll = false
////    @State private var switchView: Bool = false
////    @State private var showFailed: Bool = false
////    @State private var showSuccess: Bool = false
////
////    private var defaultDirectory: URL {
////        get throws {
////            let documentDirectory = try FileManager.default.url(
////                for: .documentDirectory,
////                in: .userDomainMask,
////                appropriateFor: nil,
////                create: true
////            )
////            return documentDirectory.appendingPathComponent("SmileID")
////        }
////    }
////
////    @State private var startBlu = false
////    @State private var livenessResult: Data? = nil
////    @State private var imageFile: Data? = nil
////
////    var body: some View {
////        ZStack {
////            VStack {
////                ScrollView(.vertical, showsIndicators: false) {
////                    VStack {
////                        if case .failed(_) = viewModel.state {
////                            displayStatusInfo(imageName: "error", backgroundColor: Color.errorBackground, title: "unable_to_verify_your_identity".localized, titleMessage: "want_to_try_again?_ensure_you_are_in_a_well_lit_room_and_your_face_isn’t_covered.".localized)
////                        } else {
////                            if(showFailed == true) {
////                                displayStatusInfo(imageName: "error", backgroundColor: Color.errorBackground, title: "unable_to_verify_your_identity".localized, titleMessage: "want_to_try_again?_ensure_you_are_in_a_well_lit_room_and_your_face_isn’t_covered.".localized)
////                            } else {
////                                VStack(alignment: .leading, spacing: 15) {
////                                    Text("verify_your_identity".localized)
////                                        .customFont(.headline, fontSize: 24)
////                                    Text("you_will_be_asked_to_take_a_selfie_to_confirm_that_you_are_the_owner_of_the_identity_number.".localized)
////                                        .customFont(.body, fontSize: 17)
////                                }
////                                .padding(.bottom, 40)
////
////                                Image(.verifyIdentity)
////                                    .padding(.bottom, 30)
////
////                                HStack(spacing: 12) {
////                                    Image(systemName: "info.circle.fill")
////                                        .frame(width: 24, height: 24)
////                                        .foregroundStyle(Color.verifyInfoBackground)
////                                    Text("you_will_be_redirected_to_a_page_to_complete_this_process.".localized)
////                                        .customFont(.subheadline, fontSize: 16)
////                                }
////                                .padding()
////                                .background(Color.verifyInfoBackground.opacity(0.1))
////                                .mask(
////                                    RoundedRectangle(cornerRadius: 4, style: .continuous))
////                                .overlay(
////                                    RoundedRectangle(cornerRadius: 4, style: .continuous)
////                                    .stroke()
////                                    .fill(.black.opacity(0.1))
////                                )
////                            }
////                        }
////
////                        Spacer()
////
////                        NavigationLink(destination: VerificationStatusView(verificationStatus: .done), isActive: $showSuccess) {}.isDetailLink(false)
////
////                        NavigationLink(destination: VerificationStatusView(verificationStatus: .failed), isActive: $showFailed) {}.isDetailLink(false)
////                    }
////                }
////            }
////            .padding()
////            .navigationTitle(Text(""))
////            .navigationBarTitleDisplayMode(.inline)
////            .safeAreaInset(edge: .bottom) {
////                Button {
////                    presentEnroll.toggle()
////                } label: {
////                    if case .failed(_) = viewModel.state {
////                        Text("retry".localized)
////                            .customFont(.title, fontSize: 18)
////                            .foregroundStyle(.white)
////                    } else {
////                        if(showFailed == true) {
////                            Text("retry".localized)
////                                .customFont(.title, fontSize: 18)
////                                .foregroundStyle(.white)
////                        } else {
////                            Text("continue".localized)
////                                .customFont(.title, fontSize: 18)
////                                .foregroundStyle(.white)
////                        }
////                    }
////                }
////                .frame(maxWidth: .infinity)
////                .padding(.vertical, 18)
////                .background(Color.button)
////                .cornerRadius(4)
////                .padding()
////                .sheet(isPresented: $presentEnroll, content: {
////                    NavigationView {
////                        let extraParams: [String: String] = [
////                            "job_type": "3",
////                            "user_id": userID,
////                            "job_id": UUID().uuidString,
//////                            "id_image_base64": viewModel.ninImageBase64 ?? ""
////                        ]
////
////                        let selfieScreen = SmileID.smartSelfieAuthenticationScreenEnhanced(
////                            userId: userID,
//////                            jobType: .smartSelfieAuth,
////                            allowNewEnroll: false,
////                            showAttribution: false,
////                            showInstructions: true,
////                            extraPartnerParams: extraParams,
////                            delegate: self
////                        )
////
////                        selfieScreen
////                    }
////                })
////            }
////
////            if case .loading = viewModel.state {
////                ProgressView()
////                    .scaleEffect(2)
////            }
////
////            Spacer()
////        }
////    }
////
////    func didSucceed(selfieImage: URL, livenessImages: [URL], apiResponse: SmartSelfieResponse?) {
////        presentEnroll.toggle()
////        var registerUserSelfieRequest = RegisterUserSelfieRequest()
////        registerUserSelfieRequest.user_id = userID
////        registerUserSelfieRequest.job_id = apiResponse?.jobId ?? ""
////        registerUserSelfieRequest.images = []
////
////        for img in livenessImages {
////            var selfieImage = SelfieImage()
////            selfieImage.image_type = "image_type_2"
////            if let location = try? defaultDirectory.appendingPathComponent(img.lastPathComponent) {
////                let stringImg = try? Data(contentsOf: location, options: .alwaysMapped)
////                selfieImage.image = stringImg?.base64EncodedString() ?? ""
////                registerUserSelfieRequest.images?.append(selfieImage)
////            }
////        }
////
////        Task {
////            await viewModel.registerUserSelfie(registerUserSelfieRequest: registerUserSelfieRequest)
////        }
////
////        if(apiResponse?.status == .approved) {
////            showSuccess = true
////        } else {
////            showFailed = true
////        }
////    }
////
////    func didError(error: any Error) {
////        presentEnroll.toggle()
////    }
////
////    @ViewBuilder
////    private func displayStatusInfo(imageName: String, backgroundColor: Color, title: String, titleMessage: String) -> some View {
////        VStack(alignment: .center) {
////            VerificationImageStatusView(image: imageName, backgroundColor: backgroundColor)
////                .padding(.bottom, 30)
////            VStack(spacing: 15) {
////                Text(title)
////                    .customFont(.headline, fontSize: 24)
////                Text(titleMessage)
////                    .customFont(.body, fontSize: 18)
////            }
////        }
////    }
////}
////
////// MARK: - Helper to convert UIImage to base64
////
////func base64FromUIImage(_ image: UIImage) -> String? {
////    guard let imageData = image.jpegData(compressionQuality: 0.9) else { return nil }
////    return imageData.base64EncodedString()
////}
////
////func base64FromFile(at url: URL) -> String? {
////    do {
////        let data = try Data(contentsOf: url)
////        return data.base64EncodedString()
////    } catch {
////        print(" Error reading image data: \(error)")
////        return nil
////    }
////}
////
////#Preview {
////    VerifyIdentityView()
////        .environmentObject(AppState())
////}
//
////
////  VerifyIdentityView 2.swift
////  NINAuth-iOS
////
////  Created by Arogundade Qoyum on 22/05/2025.
////
//
//
//import SwiftUI
//import SmileID
//import BlusaltLivenessOnly
//import UIKit
//
//struct VerifyIdentityView: View, SmartSelfieResultDelegate {
//    @State var nin: String? = ""
//    @State var userID: String = ""
//    @EnvironmentObject var appState: AppState
//    @StateObject private var viewModel = AuthViewModel()
//    @State private var presentEnroll = false
//    @State private var switchView: Bool = false
//    @State private var showFailed: Bool = false
//    @State private var showSuccess: Bool = false
//
//    private var defaultDirectory: URL {
//        get throws {
//            let documentDirectory = try FileManager.default.url(
//                for: .documentDirectory,
//                in: .userDomainMask,
//                appropriateFor: nil,
//                create: true
//            )
//            return documentDirectory.appendingPathComponent("SmileID")
//        }
//    }
//
//    @State private var startBlu = false
//    @State private var livenessResult: Data? = nil
//    @State private var imageFile: Data? = nil
//
//    var body: some View {
//        ZStack {
//            VStack {
//                ScrollView(.vertical, showsIndicators: false) {
//                    VStack {
//                        if case .failed = viewModel.state {
//                            displayStatusInfo(imageName: "error", backgroundColor: Color.errorBackground, title: "unable_to_verify_your_identity".localized, titleMessage: "want_to_try_again?_ensure_you_are_in_a_well_lit_room_and_your_face_isn't_covered.".localized)
//                        } else {
//                            if(showFailed == true) {
//                                displayStatusInfo(imageName: "error", backgroundColor: Color.errorBackground, title: "unable_to_verify_your_identity".localized, titleMessage: "want_to_try_again?_ensure_you_are_in_a_well_lit_room_and_your_face_isn't_covered.".localized)
//                            } else {
//                                VStack(alignment: .leading, spacing: 15) {
//                                    Text("verify_your_identity".localized)
//                                        .customFont(.headline, fontSize: 24)
//                                    Text("you_will_be_asked_to_take_a_selfie_to_confirm_that_you_are_the_owner_of_the_identity_number.".localized)
//                                        .customFont(.body, fontSize: 17)
//                                }
//                                .padding(.bottom, 40)
//
//                                Image(.verifyIdentity)
//                                    .padding(.bottom, 30)
//
//                                HStack(spacing: 12) {
//                                    Image(systemName: "info.circle.fill")
//                                        .frame(width: 24, height: 24)
//                                        .foregroundStyle(Color.verifyInfoBackground)
//                                    Text("you_will_be_redirected_to_a_page_to_complete_this_process.".localized)
//                                        .customFont(.subheadline, fontSize: 16)
//                                }
//                                .padding()
//                                .background(Color.verifyInfoBackground.opacity(0.1))
//                                .mask(
//                                    RoundedRectangle(cornerRadius: 4, style: .continuous))
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 4, style: .continuous)
//                                    .stroke()
//                                    .fill(.black.opacity(0.1))
//                                )
//                            }
//                        }
//
//                        Spacer()
//
//                        NavigationLink(destination: VerificationStatusView(verificationStatus: .done), isActive: $showSuccess) {}.isDetailLink(false)
//
//                        NavigationLink(destination: VerificationStatusView(verificationStatus: .failed), isActive: $showFailed) {}.isDetailLink(false)
//                    }
//                }
//            }
//            .padding()
//            .navigationTitle(Text(""))
//            .navigationBarTitleDisplayMode(.inline)
//            .safeAreaInset(edge: .bottom) {
//                Button {
//                    presentEnroll.toggle()
//                } label: {
//                    if case .failed = viewModel.state {
//                        Text("retry".localized)
//                            .customFont(.title, fontSize: 18)
//                            .foregroundStyle(.white)
//                    } else {
//                        if(showFailed == true) {
//                            Text("retry".localized)
//                                .customFont(.title, fontSize: 18)
//                                .foregroundStyle(.white)
//                        } else {
//                            Text("continue".localized)
//                                .customFont(.title, fontSize: 18)
//                                .foregroundStyle(.white)
//                        }
//                    }
//                }
//                .frame(maxWidth: .infinity)
//                .padding(.vertical, 18)
//                .background(Color.button)
//                .cornerRadius(4)
//                .padding()
//                .sheet(isPresented: $presentEnroll, content: {
//                    NavigationView {
//                        let extraParams: [String: String] = [
//                            "job_type": "3",
//                            "user_id": userID,
//                            "job_id": UUID().uuidString,
////                            "id_image_base64": viewModel.ninImageBase64 ?? ""
//                        ]
//
//                        let selfieScreen = SmileID.smartSelfieAuthenticationScreenEnhanced(
//                            userId: userID,
////                            jobType: .smartSelfieAuth,
//                            allowNewEnroll: false,
//                            showAttribution: false,
//                            showInstructions: true,
//                            extraPartnerParams: extraParams,
//                            delegate: self
//                        )
//
//                        selfieScreen
//                    }
//                })
//            }
//
//            if case .loading = viewModel.state {
//                ProgressView()
//                    .scaleEffect(2)
//            }
//
//            Spacer()
//        }
//    }
//
//    func didSucceed(selfieImage: URL, livenessImages: [URL], apiResponse: SmartSelfieResponse?) {
//        presentEnroll.toggle()
//
//        var registerUserSelfieRequest = RegisterUserSelfieRequest()
//        registerUserSelfieRequest.user_id = userID
//        registerUserSelfieRequest.job_id = apiResponse?.jobId ?? ""
//        registerUserSelfieRequest.images = []
//
//        
//        var mainSelfie = SelfieImage()
//        mainSelfie.image_type = "image_type_1"
//        if let selfieData = try? Data(contentsOf: selfieImage) {
//            mainSelfie.image = selfieData.base64EncodedString()
//            registerUserSelfieRequest.images?.append(mainSelfie)
//        }
//
//        
//        for img in livenessImages {
//            var selfieImage = SelfieImage()
//            selfieImage.image_type = "image_type_2"
//            if let location = try? defaultDirectory.appendingPathComponent(img.lastPathComponent) {
//                let stringImg = try? Data(contentsOf: location, options: .alwaysMapped)
//                selfieImage.image = stringImg?.base64EncodedString() ?? ""
//                registerUserSelfieRequest.images?.append(selfieImage)
//            }
//        }
//
//       
//        Task {
//            do {
//                await viewModel.registerUserSelfie(registerUserSelfieRequest: registerUserSelfieRequest)
//                await MainActor.run {
//                    switch viewModel.state {
//                    case .success: showSuccess = true
//                    case .failed: showFailed = true
//                    case .loading: break
//                    default: showFailed = true
//                    }
//                }
//            } catch {
//                await MainActor.run { showFailed = true }
//            }
//        }
//    }
//
//
//    func didError(error: any Error) {
//        presentEnroll.toggle()
//        // Set failure state when SmileID itself fails
//        showFailed = true
//    }
//
//    @ViewBuilder
//    private func displayStatusInfo(imageName: String, backgroundColor: Color, title: String, titleMessage: String) -> some View {
//        VStack(alignment: .center) {
//            VerificationImageStatusView(image: imageName, backgroundColor: backgroundColor)
//                .padding(.bottom, 30)
//            VStack(spacing: 15) {
//                Text(title)
//                    .customFont(.headline, fontSize: 24)
//                Text(titleMessage)
//                    .customFont(.body, fontSize: 18)
//            }
//        }
//    }
//}
//
//// MARK: - Helper to convert UIImage to base64
//
//func base64FromUIImage(_ image: UIImage) -> String? {
//    guard let imageData = image.jpegData(compressionQuality: 0.9) else { return nil }
//    return imageData.base64EncodedString()
//}
//
//func base64FromFile(at url: URL) -> String? {
//    do {
//        let data = try Data(contentsOf: url)
//        return data.base64EncodedString()
//    } catch {
//        print(" Error reading image data: \(error)")
//        return nil
//    }
//}
//
//#Preview {
//    VerifyIdentityView()
//        .environmentObject(AppState())
//}
