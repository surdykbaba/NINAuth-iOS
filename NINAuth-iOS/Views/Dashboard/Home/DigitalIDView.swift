//
//  HomeView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 05/02/2025.
//

import SwiftUI
import RealmSwift

struct DigitalIDView: View {
    @EnvironmentObject var appState: AppState
    @State private var changeView = true
    @State private var showShareIDPopover = false
    @State private var showSecurityPinView = false
    @State private var showLinkedIDsView = false
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
                                if changeView {
                                    DigitalIDCardView()
                                } else {
                                    Image(uiImage: appState.generateQRCode())
                                        .resizable()
                                        .interpolation(.none)
                                        .frame(width: 250, height: 242)
                                        .frame(maxWidth: .infinity)
                                }

                                Button {
                                    withAnimation {
                                        changeView.toggle()
                                    }
                                } label: {
                                    showQR(title: changeView ? "show_qr_code".localized : "Show my ID", subtitle: changeView ? "click_to_view_qr_code".localized : "click_to_show_your_id".localized)
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

                                IdentityView(icon: "link", title: "linked_ids".localized, subtitle: "view_other_functional_ids_linked_to_your_nin".localized, completion: {
                                    showLinkedIDsView = true
                                    Task {
                                        await viewModel.getLinkedIDs()
                                    }
                                })
                            }
                        }
                        .padding()
                    }
                )
            
            if case .loading = viewModel.state {
                //TODO: Add your custom loding view here
                ProgressView()
                    .scaleEffect(2)
            }

            Spacer()
        }
        moveToLinkedIDsView()
        moveToGetSecurityPINView()
    }

    func moveToLinkedIDsView() -> some View {
        NavigationLink(destination: LinkedIDsView(), isActive: $showLinkedIDsView){}
    }

    func moveToGetSecurityPINView() -> some View {
        NavigationLink(destination: GetSecurityPINView(), isActive: $showSecurityPINView){}
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
