//
//  UserQRCodeView.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 15/04/2025.


import SwiftUI
import RealmSwift
import UIKit

struct DigitalIDView: View {
    @EnvironmentObject var appState: AppState
    @State private var isFlipped = false
    @State private var showSecurityPINView = false
    @State private var showBannerAlert = false
    @State private var bannerTappedIndex = 0
    @ObservedResults(User.self) var user
    @StateObject var viewModel = LinkedIDViewModel()
    @StateObject private var consentVM = ConsentViewModel()
    @State private var isPresentingScanner = false
    @State private var scannedCode: String?
    @State private var currentIndex = 0

    let bannerTimer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()

    let bannerData = [
        (title: "Safeguard your digital identity", subtitle: "Click here to learn how to keep your identity safe.", icon: "Shield"),
        (title: "Verify your ID securely", subtitle: "Ensure your credentials are verified safely.", icon: "bulb")
    ]

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading) {
                    VStack(alignment: .center, spacing: 0) {
                        TabView(selection: $currentIndex) {
                            ForEach(0..<bannerData.count, id: \.self) { index in
                                HStack(spacing: 12) {
                                    Image(bannerData[index].icon)
                                        .resizable()
                                        .frame(width: 30, height: 30)

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(bannerData[index].title)
                                            .customFont(.title, fontSize: 17)
                                            .foregroundColor(.primary)
                                            .fixedSize(horizontal: false, vertical: true)

                                        Text(bannerData[index].subtitle)
                                            .customFont(.body, fontSize: 15)
                                            .foregroundColor(.secondary)
                                            .lineLimit(1)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }

                                    Spacer()
                                }
                                .padding()
                                .frame(width: 358, height: 81)
                                .background(Color.white)
                                .cornerRadius(14)
                                .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
                                .padding(.horizontal)
                                .onTapGesture {
                                    bannerTappedIndex = index
                                    showBannerAlert = true
                                }
                                .tag(index)
                            }
                        }
                        .frame(height: 81)
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .onReceive(bannerTimer) { _ in
                            withAnimation {
                                currentIndex = (currentIndex + 1) % bannerData.count
                            }
                        }
                    }
                    
                    ZStack {
                        DigitalbackCard()
                            .opacity(isFlipped ? 1 : 0)
                            .rotation3DEffect(.degrees(isFlipped ? 0 : -180), axis: (x: 0, y: 1, z: 0))

                        DigitalIDCardView()
                            .opacity(isFlipped ? 0 : 1)
                            .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                    }
                    .frame(height: 242)
                    .animation(.spring(response: 1.4, dampingFraction: 0.7, blendDuration: 0.5), value: isFlipped)
                    .onTapGesture {
                        isFlipped.toggle()
                    }

                    Text("manage_your_identity")
                        .customFont(.title, fontSize: 17)
                        .padding(.bottom, 15)
                        .padding(.top, 40)
                        

                    VStack(spacing: 12) {
                        IdentityView(icon: "barcode", title: "Scan a QR code", subtitle: "scan_the_qr_code_to_share_identity_data".localized) {
                            isPresentingScanner.toggle()
                        }

                        IdentityView(icon: "padlock", title: "get_security_pin".localized, subtitle: "get_pin_to_access_nimc_digital_services".localized) {
                            showSecurityPINView = true
                        }
                    }
                }
                .padding()
                
            }
            .background(Color(UIColor.secondarySystemBackground))
            .sheet(isPresented: $isPresentingScanner) {
                NavigationView {
                    QRCodeScanner(result: $scannedCode)
                }
            }
            .onChange(of: scannedCode) { _ in
                if let code = scannedCode {
                    verifyCode(code)
                    scannedCode = nil
                }
                isPresentingScanner = false
            }
            .onAppear {
                scannedCode = nil
            }

            if case .loading = viewModel.state {
                ProgressView().scaleEffect(2)
            }
        }
        .sheet(isPresented: $showBannerAlert) {
            if #available(iOS 16.0, *) {
                LeaveAppAlertSheetView(
                    onConfirm: {
                        showBannerAlert = false
                        openBannerURL()
                    },
                    onCancel: {
                        showBannerAlert = false
                    }
                )
                .presentationDetents([.height(250)])
                .presentationDragIndicator(.visible)
            } else {
                LeaveAppAlertSheetView(
                    onConfirm: {
                        showBannerAlert = false
                        openBannerURL()
                    },
                    onCancel: {
                        showBannerAlert = false
                    }
                )
            }
        }

        NavigationLink(destination: GetSecurityPINView(), isActive: $showSecurityPINView) { EmptyView() }
        NavigationLink(destination: ConsentReviewView(consentRequest: consentVM.consentRequest, code: scannedCode ?? ""), isActive: $consentVM.isVerified) { EmptyView() }
    }

    func openBannerURL() {
        if let url = URL(string: "https://ninauth.com/privacy-policy") {
            UIApplication.shared.open(url)
        }
    }

    func verifyCode(_ code: String) {
        var consentCode = ConsentCode()
        consentCode.deviceId = appState.getDeviceID()
        consentCode.requestCode = code
        Task {
            await consentVM.verifyConsent(consentCode: consentCode)
        }
    }
}
#Preview {
    DigitalIDView()
}

