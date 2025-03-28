import SwiftUI
import RealmSwift

struct DigitalIDView: View {
    @EnvironmentObject var appState: AppState
    @State private var isFlipped = false
    @State private var showShareIDPopover = false
    @State private var showSecurityPINView = false
    @ObservedResults(User.self) var user
    @StateObject var viewModel = LinkedIDViewModel()
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            Color.secondaryGrayBackground
                .ignoresSafeArea()
                .overlay(
                    ScrollView {
                        VStack(alignment: .leading) {
                            VStack(alignment: .center, spacing: 10) {
                                ZStack {
                                    DigitalbackCard()
                                        .opacity(isFlipped ? 1 : 0)
                                        .rotation3DEffect(
                                            .degrees(isFlipped ? 0 : -180),
                                            axis: (x: 0, y: 1, z: 0),
                                            perspective: 0.8
                                        )
                                    
                                    DigitalIDCardView()
                                        .opacity(isFlipped ? 0 : 1)
                                        .rotation3DEffect(
                                            .degrees(isFlipped ? 180 : 0),
                                            axis: (x: 0, y: 1, z: 0),
                                            perspective: 0.8
                                        )
                                }
                                .frame(width: 370, height: 242)
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
                                IdentityView(icon: "barcode", title: "share_my_id".localized, subtitle: "scan_the_qr_code_to_share_identity_data".localized, completion: {
                                    showShareIDPopover = true
                                })
                                .popover(isPresented: $showShareIDPopover) {
                                    ShareIDView(display: $showShareIDPopover)
                                }

                                IdentityView(icon: "padlock", title: "get_security_pin".localized, subtitle: "get_pin_to_access_nimc_digital_services".localized, completion: {
                                    showSecurityPINView = true
                                })
                            }
                        }
                        .padding()
                    }
                )
            
            if case .loading = viewModel.state {
                ProgressView()
                    .scaleEffect(2)
            }
        }
        moveToGetSecurityPINView()
    }

    func moveToGetSecurityPINView() -> some View {
        NavigationLink(destination: GetSecurityPINView(), isActive: $showSecurityPINView) {}
    }

    func showQR(title: String, subtitle: String) -> some View {
        VStack(spacing: 5) {
            Text(title)
                .customFont(.headline, fontSize: 17)
                .foregroundColor(Color.greenText)
            Text(subtitle)
                .customFont(.caption2, fontSize: 14)
                .foregroundColor(Color.black)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 40)
        .cornerRadius(10)
        .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(.white))
    }
}

#Preview {
    DigitalIDView()
        .environmentObject(AppState())
}
