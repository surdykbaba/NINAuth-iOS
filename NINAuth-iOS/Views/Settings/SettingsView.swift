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
        ScrollView() {
            NavigationView {
                VStack {
                    VStack(spacing: 10) {
                        Image("profileImage")
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
                    }
                    
                    List {
                        legalAndComplaince
                        
                        security
                        
                        others
                        
                    }
                    .listRowSeparator(.hidden)
                    .listStyle(.inset)
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
                                .foregroundStyle(Color("buttonColor"))
                        }
                    }
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
                .background(Color("grayBackground"))
                .clipShape(Circle())
            
            Toggle(isOn: $biometricsIsOn,
                   label : {
                Text("Biometrics")
                    .customFont(.headline, fontSize: 19)
            })
        }
    }
    
    var legalAndComplaince: some View {
        Section(header:
                    VStack(alignment: .leading, spacing: 20) {
            Text("Legal and compliance")
                .customFont(.headline, fontSize: 17)
                .foregroundColor(.black)
            Divider()
        }) {
            Group {
                NavigationLink(destination: OnboardingView()) {
                    SettingsRow(image: "lock", name: "Privacy policy")
                }
                NavigationLink(destination: PrivacyPolicyView()) {
                    SettingsRow( image: "file.text", name: "Terms of service")
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
            Text("Security")
                .customFont(.headline, fontSize: 17)
                .foregroundColor(.black)
            Divider()
        }) {
            Group {
                NavigationLink(destination: OnboardingView()) {
                    SettingsRow(image: "wifi.off", name: "Offline data sharing")
                }
                .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: -8))
                
                NavigationLink(destination: OnboardingView()) {
                    SettingsRow(image: "lock", name: "Update PIN")
                }
                .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: -8))
                
                biometrics
                
                NavigationLink(destination: OnboardingView()) {
                    SettingsRow(image: "device.mobile", name: "Devices")
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
            Text("Others")
                .customFont(.headline, fontSize: 17)
                .foregroundColor(.black)
            Divider()
        }) {
            Group {
                NavigationLink(destination: OnboardingView()) {
                    SettingsRow(image: "notification", name: "Notifications")
                }
                NavigationLink(destination: OnboardingView()) {
                    SettingsRow(image: "logout", name: "Sign out")
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
