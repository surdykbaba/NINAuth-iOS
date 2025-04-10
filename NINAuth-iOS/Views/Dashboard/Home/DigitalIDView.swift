import SwiftUI
import RealmSwift
import UIKit // For UIApplication

struct DigitalIDView: View {
    @EnvironmentObject var appState: AppState
    @State private var isFlipped = false
    @State private var showShareIDPopover = false
    @State private var showSecurityPINView = false
    @State private var showBannerAlert = false
    @State private var bannerTappedIndex: Int = 0
    @ObservedResults(User.self) var user
    @StateObject var viewModel = LinkedIDViewModel()
    @StateObject private var consentVM = ConsentViewModel()
    @State private var isPresentingScanner = false
    @State private var scannedCode: String?
    @State private var currentIndex = 0
    @Environment(\.colorScheme) var colorScheme

    let bannerTimer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()

    // Updated banner data with custom asset names for icons
    let bannerData = [
        (
            title: "Safeguard your digital identity",
            subtitle: "Click here to learn how to keep your identity safe.",
            icon: "bulb"
        ),
        (
            title: "Verify your ID securely",
            subtitle: "Ensure your credentials are verified safely.",
            icon: "Shield"
        ),
    ]

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading) {
                    VStack(alignment: .center, spacing: 10) {
                        TabView(selection: $currentIndex) {
                            ForEach(0..<bannerData.count, id: \.self) { index in
                                HStack(spacing: 12) {
                                   
                                    Image(bannerData[index].icon)
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.green)

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(bannerData[index].title)
                                            .font(.system(size: 15, weight: .semibold))
                                            .foregroundColor(Color(.label))

                                        Text(bannerData[index].subtitle)
                                            .font(.system(size: 13))
                                            .foregroundColor(Color(.secondaryLabel))
                                            .lineLimit(1)
                                            .layoutPriority(1)
                                    }

                                    Spacer()
                                }
                                .padding()
                                .frame(width: 360, height: 81)
                                .background(Color.white)
                                .cornerRadius(14)
                                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                                .padding(.horizontal)
                                .onTapGesture {
                                    bannerTappedIndex = index
                                    showBannerAlert = true
                                }
                                .tag(index)
                            }
                        }
                        .frame(height: 100)
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                        .onReceive(bannerTimer) { _ in
                            withAnimation {
                                currentIndex = (currentIndex + 1) % bannerData.count
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
                    }
                    .padding(.bottom, 30)

                    Text("manage_your_identity")
                        .customFont(.subheadline, fontSize: 17)
                        .padding(.bottom, 15)

                    VStack(spacing: 12) {
                        IdentityView(icon: "barcode", title: "Scan QR code", subtitle: "scan_the_qr_code_to_share_identity_data".localized, completion: {
                            isPresentingScanner.toggle()
                        })

                        IdentityView(icon: "padlock", title: "get_security_pin".localized, subtitle: "get_pin_to_access_nimc_digital_services".localized, completion: {
                            showSecurityPINView = true
                        })
                    }
                }
                .padding()
            }
            .sheet(isPresented: $isPresentingScanner) {
                QRCodeScanner(result: $scannedCode)
            }
            .onChange(of: scannedCode) { _ in
                if let code = scannedCode {
                    verifyCode(code)
                }
                isPresentingScanner = false
            }
            .onAppear {
                scannedCode = nil
            }
            .background(Color.secondaryGrayBackground)

            if case .loading = viewModel.state {
                ProgressView().scaleEffect(2)
            }
        }
        .alert(isPresented: $showBannerAlert) {
            Alert(
                title: Text("Leave this page?"),
                message: Text("You're about to view more information."),
                primaryButton: .default(Text("Continue")) {
                    // Navigate to the privacy policy link when "Continue" is tapped
                    if let url = URL(string: "https://ninauth.com/privacy-policy") {
                        UIApplication.shared.open(url)
                    }
                },
                secondaryButton: .cancel()
            )
        }

        NavigationLink(destination: GetSecurityPINView(), isActive: $showSecurityPINView) {}
        NavigationLink(destination: ConsentReviewView(consentRequest: consentVM.consentRequest, code: scannedCode ?? ""), isActive: $consentVM.isVerified) {}
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
    DigitalIDView().environmentObject(AppState())
}
