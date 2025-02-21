//
//  SettingsView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 29/01/2025.
//

import SwiftUI

struct SettingsView: View {
    @State private var biometricsIsOn = false
    
    var body: some View {
                VStack {
                    VStack(spacing: 10) {
                        Image("profile_image")
                            .resizable()
                            .frame(width: 96, height: 96)
                            .clipped()
                        Text("Bisola Adegoke Eniola")
                            .customFont(.title, fontSize: 24)
                        HStack {
                            Text("Last Login")
                                .foregroundStyle(Color(.darkGray))
                                .customFont(.headline, fontSize: 16)
                            Circle()
                                .fill(Color(.darkGray))
                                .frame(width: 6, height: 6)
                            Text("23 July, 2024")
                                .foregroundStyle(Color(.darkGray))
                                .customFont(.headline, fontSize: 16)
                        }

                        List {
                            legalAndComplaince

                            security

                            others
                        }
                        .listRowSeparator(.hidden)
                        .listStyle(.inset)
                    }
                }
                .padding()
                .padding(.top, 20)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        NavigationLink {} label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .padding(10)
                                .customFont(.headline, fontSize: 15)
                                .background(Color("grayBackground"))
                                .foregroundColor(.black)
                                .clipShape(Circle())
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            NotificationsView()
                        } label: {
                            Image(systemName: "bell.badge")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.red, .black)
                                .customFont(.caption, fontSize: 18)
                                .foregroundStyle(Color.button)
                        }
                    }
                }
    }
    
    var biometrics: some View {
        HStack(spacing: 20) {
            Image("fingerprint")
                .resizable()
                .frame(width: 25, height: 25)
                .padding(15)
                .background(Color.grayBackground)
                .clipShape(Circle())
            
            Toggle(isOn: $biometricsIsOn,
                   label : {
                Text("biometrics")
                    .customFont(.headline, fontSize: 19)
            })
        }
    }
    
    var legalAndComplaince: some View {
        Section(header:
                    VStack(alignment: .leading, spacing: 20) {
            Text("legal_and_compliance")
                .customFont(.headline, fontSize: 17)
                .foregroundColor(.black)
            Divider()
        }) {
            Group {
                NavigationLink(destination: VerificationStatusView()) {
                    SettingsRow(image: "lock", name: "privacy_policy")
                }
                NavigationLink(destination: PrivacyPolicyView()) {
                    SettingsRow( image: "file_text", name: "terms_of_service")
                }
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: -8))
        }
        .listSectionSeparator(.hidden)
    }
    
    var security: some View {
        Section(header:
                    VStack(alignment: .leading, spacing: 20) {
            Text("security")
                .customFont(.headline, fontSize: 17)
                .foregroundColor(.black)
            Divider()
        }) {
            Group {
                NavigationLink(destination: VerificationStatusView()) {
                    SettingsRow(image: "wifi_off", name: "offline_data_sharing")
                }
                .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: -8))

                NavigationLink(destination: VerificationStatusView()) {
                    SettingsRow(image: "lock", name: "update_pin")
                }
                .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: -8))
                
                biometrics

                NavigationLink(destination: VerificationStatusView()) {
                    SettingsRow(image: "device_mobile", name: "devices")
                }
                .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: -8))
                
            }
            .listRowSeparator(.hidden)
        }
        .listSectionSeparator(.hidden)
    }
    
    var others: some View {
        Section(header:
                    VStack(alignment: .leading, spacing: 20) {
            Text("others")
                .customFont(.headline, fontSize: 17)
                .foregroundColor(.black)
            Divider()
        }) {
            Group {
                NavigationLink(destination: CheckIdentityView(code: "")) {
                    SettingsRow(image: "notification", name: "notifications")
                }
                NavigationLink(destination: CheckIdentityView(code: "")) {
                    SettingsRow(image: "logout", name: "sign_out")
                }
            }
            .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: -8))
            .listRowSeparator(.hidden)
        }
        .listSectionSeparator(.hidden)
    }
    
}

#Preview {
    SettingsView()
}
