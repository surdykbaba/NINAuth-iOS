//
//  HomeView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 05/02/2025.
//

import SwiftUI

struct DigitalIDView: View {
    @State private var changeView = true
    @State private var showShareIDPopover = false
    
    var body: some View {
        Color.secondaryGrayBackground
            .ignoresSafeArea()
            .overlay(
                ScrollView {
                    VStack(alignment: .leading) {
                        VStack(alignment: .center, spacing: 10) {
                            if changeView {
                                Image("id_card")
                                    .resizable()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 240)
                            } else {
                                Image("qr_code")
                                    .resizable()
                                    .frame(width: 250, height: 250)
                                    .frame(maxWidth: .infinity)
                            }
                            
                            Button {
                                changeView.toggle()
                            } label: {
                                showQR(title: changeView ? "Show QR code" : "Show my ID", subtitle: changeView ? "Click to view QR code" : "Click to show your ID")
                            }
                        }
                        .padding(.bottom, 30)
                        
                        Text("Manage your identity")
                            .customFont(.subheadline, fontSize: 17)
                            .padding(.bottom, 15)
                        
                        VStack(spacing: 12) {
                            IdentityView(icon: "barcode", title: "Share my ID", subtitle: "Scan the QR code to share identity data", completion: {
                                showShareIDPopover = true
                            })
                            .popover(isPresented: $showShareIDPopover) {
                                ShareIDView()
                            }
                            
                            IdentityView(icon: "padlock", title: "Get Security PIN", subtitle: "Get PIN to access NIMC digital services", completion: {
                                //                                    GetSecurityPINView()
                            })
                            
                            IdentityView(icon: "link", title: "Linked IDs", subtitle: "View other functional IDs linked to your NIN", completion: {
                                
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
