//
//  ScanQRCodeView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 05/02/2025.
//

import SwiftUI
import CodeScanner

struct ScanQRCodeView: View {
    @EnvironmentObject var appState: AppState
    @State private var isPresentingScanner = false
    @State private var scannedCode: String?
    @StateObject var viewModel = ConsentViewModel()

    var body: some View {
        Color.secondaryGrayBackground
            .ignoresSafeArea()
            .overlay(
                ScrollView {
                    VStack(spacing: 10) {
                        VStack(alignment: .leading) {
                            HStack(spacing: 15) {
                                Image("barcode_green")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                Text("scan_qr_code_to_give_consent".localized)
                                    .customFont(.headline, fontSize: 17)
                            }
                            .padding(.bottom, 30)
                            
                            Divider()
                                .frame(maxWidth: .infinity)
                                .padding(.bottom, 20)
                            
                            HStack(spacing: 30) {
                                VStack(alignment: .leading, spacing: 20) {
                                    Text("point_your_camera_at_the_organization’s_qr_code_to_choose_which_nin_details_you_would_like_to_share.".localized)
                                    Button {
                                        isPresentingScanner.toggle()
                                    } label: {
                                        Text("scan_qr_code".localized)
                                            .customFont(.title, fontSize: 18)
                                            .foregroundStyle(Color.button)
                                    }
                                    .frame(width: 170, height: 50)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                                            .stroke(Color.button, lineWidth: 1)
                                    )
                                }
                                Image("barcode")
                                    .resizable()
                                    .frame(width: 97, height: 117)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 30)
                        .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.white))
                        
                        VStack(alignment: .leading) {
                            HStack(spacing: 30) {
                                VStack(alignment: .leading, spacing: 20) {
                                    Text("enter_request_code".localized)
                                        .customFont(.headline, fontSize: 17)
                                    Text("if_you_are_unable_to_scan_a_QR_code_you_can_type_in_the_6-digit_code_provided_by_the_organization.".localized)
                                    Button {} label: {
                                        Text("enter_code".localized)
                                            .customFont(.title, fontSize: 18)
                                            .foregroundStyle(Color.button)
                                    }
                                    .frame(width: 170, height: 50)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                                            .stroke(Color.button, lineWidth: 1)
                                    )
                                }
                                Image("phone_yellow")
                                    .resizable()
                                    .frame(width: 97, height: 117)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 30)
                        .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.white))
                        
                        Spacer()
                    }
                    .padding()
                    .sheet(isPresented: $isPresentingScanner) {
                        CodeScannerView(codeTypes: [.qr]) { response in
                            if case let .success(result) = response {
                                scannedCode = result.string
                                Log.info(scannedCode ?? "nothing")
                                if let code = scannedCode {
                                    verifyCode(code)
                                }
                                isPresentingScanner = false
                            }
                        }
                    }
                    NavigationLink(destination: ConsentReviewView(consentRequest: viewModel.consentRequest), isActive: $viewModel.isVerified) {}.isDetailLink(false)
                }
            )

        if case .loading = viewModel.state {
            //TODO: Add your custom loding view here
            ProgressView()
                .scaleEffect(2)
        }

        Spacer()
    }

    func verifyCode(_ code: String) {
        var consentCode = ConsentCode()
        consentCode.deviceId = appState.getDeviceID()
        consentCode.requestCode = code
        Task {
            let consentResponse = await viewModel.verifyConsent(consentCode: consentCode)
            viewModel.consentRequest = consentResponse ?? ConsentRequest()
            print(consentResponse ?? ConsentRequest())
        }
    }
}

#Preview {
    ScanQRCodeView()
}
