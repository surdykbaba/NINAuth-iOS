//
//  SettingsView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 29/01/2025.
//

import SwiftUI
import RealmSwift
import LocalAuthentication

struct SettingsView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var biometricsIsOn = true
    @ObservedResults(User.self) var user
    @State private var showSignOut = false
    @EnvironmentObject private var appState: AppState
    @State private var showAlert: Bool = false
    @State private var showPin = false
    @State private var msg = ""
    @State private var pin = ""
    private let numberOfFields = 6
    @FocusState var isFocused: Bool
    @State private var isValid = true
    @State private var goToUpdatePin = false
    private let mem = MemoryUtil.init()
    
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
                        .padding(.bottom, 30)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("ID Integrity index: 550")
                            .customFont(.body, fontSize: 16)
                        
                        NinAuthSlider(value: 3)
                        .padding(.bottom)
                        
                        Text("What does my ID integrity index mean?")
                            .padding(.top, 20)
                            .customFont(.body, fontSize: 14)
                    }
                    .padding()
                    .mask(
                        RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke()
                        .fill(.gray.opacity(0.2))
                    )
                    .padding(.bottom, 30)

                    legalAndComplaince
                    
                    security
                        .padding(.top, 44)
                    
                    others
                        .padding(.top, 44)
                        .padding(.bottom)
                    
                    NavigationLink(destination: UpdatePinView(oldPIN: pin), isActive: $goToUpdatePin) {}.isDetailLink(false)
                    
                    if case .failed(let errorBag) = viewModel.state {
                        Color.clear.onAppear {
                            msg = errorBag.description
                            showAlert.toggle()
                        }.frame(width: 0, height: 0)
                    }
                }
                .foregroundColor(Color(.text))
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
                    .padding(.trailing)
                }
            }
            .onAppear {
                biometricsIsOn = mem.getBoolValue(key: mem.authentication_key)
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
                Text("biometrics".localized)
                    .customFont(.headline, fontSize: 19)
            })
            .onChange(of: biometricsIsOn) { _ in
                if(biometricsIsOn) {
                    enableBiometrics()
                }
                mem.setValue(key: mem.authentication_key, value: biometricsIsOn)
            }
        }
        .alert(msg, isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        }
    }
    
    var legalAndComplaince: some View {
        VStack(alignment: .leading, spacing: 20){
            Text("legal_and_compliance".localized)
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
            Text("security".localized)
                .customFont(.headline, fontSize: 17)
                .foregroundColor(.black)
            
            Divider()
            
            Group {
                NavigationLink(destination: DataSharingView()) {
                    SettingsRow(image: "wifi_off", name: "offline_data_sharing".localized)
                }

                Button {
                    showPin.toggle()
                } label: {
                    SettingsRow(image: "lock", name: "update_pin".localized)
                }
                .halfSheet(showSheet: $showPin) {
                    requestCodeView
                } onEnd: {
                    Log.info("Dismissed Sheet")
                }
                
                biometrics

                NavigationLink(destination: DevicesView()) {
                    SettingsRow(image: "device_mobile", name: "devices".localized)
                }
                
                NavigationLink(destination: LinkedIDsView()) {
                    SettingsRow(image: "device_mobile", name: "LinkedID")
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
                    SettingsRow(image: "Sign out", name: "Sign out")
                }
                .alert("Sign out?", isPresented: $showSignOut) {
                    Button("OK", role: .destructive) {
                        Task {
                            await viewModel.logoutUser(logOutRequest: LogOutRequest(deviceId: appState.getDeviceID()))
                        }
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("You are about to sign out of this device")
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    var requestCodeView: some View {
        ZStack {
            Color.white
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 15, height: 15, alignment: .trailing)
                        .padding(.top, 30)
                        .onTapGesture {
                            showPin.toggle()
                        }
                }
                .padding(.bottom)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Enter your old PIN to continue")
                        .customFont(.headline, fontSize: 24)
                        .padding(.bottom, 40)

                    OTPView(numberOfFields: numberOfFields, otp: $pin, valid: $isValid)
                        .onChange(of: pin) { newOtp in
                            if newOtp.count == numberOfFields && !newOtp.isEmpty{
                                isValid = true
                            }
                        }
                        .focused($isFocused)

                    Button {
                        if(isValid) {
                            goToUpdatePin.toggle()
                            showPin.toggle()
                        }
                    } label: {
                        Text("Continue")
                            .customFont(.title, fontSize: 18)
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(isValid ? Color.button : Color.button.opacity(0.2))
                    .cornerRadius(4)
                    .disabled(!isValid)

                }
            }
            .padding()
            .padding(.bottom, 30)
        }
        .ignoresSafeArea()
    }
    
    func enableBiometrics() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to activate another means of unlocking your application."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        biometricsIsOn = true
                        mem.setValue(key: mem.authentication_key, value: true)
                    } else {
                        msg = authenticationError?.localizedDescription ?? "Failed to authenticate."
                        showAlert.toggle()
                        mem.setValue(key: mem.authentication_key, value: false)
                    }
                }
            }
        } else {
            msg = "No Biometrics available on this device."
            showAlert.toggle()
            mem.setValue(key: mem.authentication_key, value: false)
        }
    }
    
}

#Preview {
    SettingsView()
}
