//
//  HomeView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 05/02/2025.
//

import SwiftUI

struct DigitalIDView: View {
    @EnvironmentObject var appState: AppState
    @State private var changeView = true
    @State private var showShareIDPopover = false
    
    var body: some View {
        Color.secondaryGrayBackground
            .ignoresSafeArea()
            .overlay(
                ScrollView {
                    VStack(alignment: .leading) {
                        VStack(alignment: .center, spacing: 10) {
                            if let user = appState.user, changeView {
                                DigitalIDCardView(image: user.image ?? "", surname: user.last_name ?? "", otherNames: user.first_name ?? "", dob: user.date_of_birth ?? "", nationality: "NGA", sex: user.gender ?? "")
                            } else {
                                Image("qr_code")
                                    .resizable()
                                    .frame(width: 250, height: 250)
                                    .frame(maxWidth: .infinity)
                            }
                            
                            Button {
                                changeView.toggle()
                            } label: {
                                showQR(title: changeView ? "show_qr_code" : "Show my ID", subtitle: changeView ? "click_to_view_qr_code" : "click_to_show_your_id")
                            }
                        }
                        .padding(.bottom, 30)
                        
                        Text("manage_your_identity")
                            .customFont(.subheadline, fontSize: 17)
                            .padding(.bottom, 15)
                        
                        VStack(spacing: 12) {
                            IdentityView(icon: "barcode", title: "share_my_id", subtitle: "scan_the_qr_code_to_share_identity_data", completion: {
                                showShareIDPopover = true
                            })
                            .popover(isPresented: $showShareIDPopover) {
                                ShareIDView()
                            }
                            
                            IdentityView(icon: "padlock", title: "get_security_pin", subtitle: "get_pin_to_access_nimc_digital_services", completion: {
                                //                                    GetSecurityPINView()
                            })
                            
                            IdentityView(icon: "link", title: "linked_ids", subtitle: "view_other_functional_ids_linked_to_your_nin", completion: {

                            })
                        }
                    }
                    .padding()
                }
            )
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
}
