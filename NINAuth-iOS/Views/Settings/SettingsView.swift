//
//  SettingsView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 29/01/2025.
//

import SwiftUI
import RealmSwift

struct SettingsView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var biometricsIsOn = false
    @ObservedResults(User.self) var user
    @State private var showSignOut = false
    @EnvironmentObject private var appState: AppState
    @State private var showSheet: Bool = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                VStack {
                    Image(uiImage: user.first?.image?.imageFromBase64 ?? UIImage())
                        .resizable()
                        .frame(width: 96, height: 96)
                        .clipShape(Circle())
                        .padding(.bottom, 16)
                    
                    Text("\(user.first?.first_name ?? "")" + " \(user.first?.last_name ?? "")")
                        .customFont(.title, fontSize: 24)
//                    HStack {
//                        Text("Last Login")
//                            .foregroundStyle(Color(.darkGray))
//                            .customFont(.headline, fontSize: 16)
//                        Circle()
//                            .fill(Color(.darkGray))
//                            .frame(width: 6, height: 6)
//                        Text("23 July, 2024")
//                            .foregroundStyle(Color(.darkGray))
//                            .customFont(.headline, fontSize: 16)
//                    }
                    .padding(.bottom, 60)
                    
                    legalAndComplaince
                    
                    security
                        .padding(.top, 44)
                    
                    others
                        .padding(.top, 44)
                }
                .foregroundColor(Color(.text))
                .halfSheet(showSheet: $showSheet) {
                    
                } onEnd: {
                    Log.info("Dismissed Sheet")
                }
            }
            .padding()
            .padding(.top, 20)
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
        VStack(alignment: .leading, spacing: 20){
            Text("legal_and_compliance")
                .customFont(.headline, fontSize: 17)
                .foregroundColor(.black)
            
            Divider()
            
            Group {
                Link(destination: URL(string: "https://ninauth.com/privacy-policy")!) {
                    SettingsRow(image: "lock", name: "privacy_policy".localized)
                }
                
                Link(destination: URL(string: "https://ninauth.com/terms-of-service")!) {
                    SettingsRow( image: "file_text", name: "terms_of_service".localized)
                }
            }
        }
        .padding(.horizontal, 20)

    }
    
    var security: some View {
        VStack(alignment: .leading, spacing: 20){
            Text("security")
                .customFont(.headline, fontSize: 17)
                .foregroundColor(.black)
            
            Divider()
            
            Group {
                NavigationLink(destination: VerificationStatusView()) {
                    SettingsRow(image: "wifi_off", name: "offline_data_sharing".localized)
                }

                NavigationLink(destination: VerificationStatusView()) {
                    SettingsRow(image: "lock", name: "update_pin".localized)
                }
                
                biometrics

                NavigationLink(destination: DevicesView()) {
                    SettingsRow(image: "device_mobile", name: "devices".localized)
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    var others: some View {
        VStack(alignment: .leading, spacing: 20){
            Text("others")
                .customFont(.headline, fontSize: 17)
                .foregroundColor(.black)
            
            Divider()
            
            Group {
                NavigationLink(destination: NotificationsView()) {
                    SettingsRow(image: "notification", name: "notifications".localized)
                }
                
                Button {
                    showSignOut = true
                } label: {
                    SettingsRow(image: "logout", name: "sign_out".localized)
                }
                .alert("You want to sign out?", isPresented: $showSignOut) {
                    Button("OK", role: .destructive) {
                        Task {
                            await viewModel.logoutUser(logOutRequest: LogOutRequest(deviceId: appState.getDeviceID()))
                        }
                    }
                    Button("Cancel", role: .cancel) { }
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
}

#Preview {
    SettingsView()
        .environmentObject(AppState())
}
