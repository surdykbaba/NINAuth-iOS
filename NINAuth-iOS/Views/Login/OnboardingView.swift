//
//  LoginView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 27/01/2025.
//

import SwiftUI
import CodeScanner

struct OnboardingView: View {
    @State private var showSheet = false
    @State private var requestCode = ""
    private let numberOfFields = 6
    @FocusState var isFocused: Bool
    @State private var isValid = true
    @State private var isPresentingScanner = false
    @State private var scannedCode: String?
    @State private var showLoginScreen = false
    @State private var showingAlert = false

    var body: some View {
        VStack {
            Button {
                showLoginScreen = true
            } label: {
                Text("login")
                    .customFont(.title, fontSize: 18)
                    .foregroundStyle(Color("buttonColor"))
            }
            .frame(maxWidth: .infinity, alignment: .trailing)

            Spacer()

            Image("nigerian_coat_of_arms")

            Spacer()

            VStack(spacing: 10) {
                Text("verify_identity_and_authorize_data_access")
                    .customFont(.title, fontSize: 18)
                Text("ensure_your_privacy_manage_and_control")
                    .customFont(.body, fontSize: 16)
                    .multilineTextAlignment(.center)
            }

            Spacer()

            VStack(spacing: 20) {
                Button {
                    isPresentingScanner.toggle()
                } label: {
                    HStack {
                        Text("scan_qr_code")
                        Image(systemName: "qrcode")
                    }
                    .customFont(.title, fontSize: 18)
                    .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(Color.button)
                .cornerRadius(4)
                Button {
                    showSheet.toggle()
                } label: {
                    Text("i_have_a_request_code")
                        .customFont(.title, fontSize: 18)
                        .foregroundStyle(Color.button)
                }
                .halfSheet(showSheet: $showSheet) {
                    requestCodeView
                } onEnd: {
                    Log.info("Dismissed Sheet")
                }.alert("Invalid pin", isPresented: $showingAlert) {
                    Button("Ok"){
                        showSheet = false
                    }
                } message: {
                    Text("Please scan QR code")
                }
            }
            
            Group {
                if let code = scannedCode {
                    NavigationLink(destination: CheckIdentityView(code: code), isActive: .constant(true)) {}.isDetailLink(false)
                }
                NavigationLink(destination: LoginView(), isActive: $showLoginScreen){}.isDetailLink(false)
            }
            .frame(width: 0, height: 0)
        }
        .padding()
        .sheet(isPresented: $isPresentingScanner) {
            CodeScannerView(codeTypes: [.qr]) { response in
                if case let .success(result) = response {
                    scannedCode = result.string
                    Log.info(scannedCode ?? "nothing")
                    isPresentingScanner = false
                }
            }
        }
    }

    var requestCodeView: some View {
        ZStack {
            Color.white
            VStack(alignment: .leading) {
                HStack {
                    EmptyView()
                    Spacer()
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 15, height: 15, alignment: .trailing)
                        .padding(.top, 30)
                        .onTapGesture {
                            showSheet.toggle()
                        }
                }
                VStack(alignment: .leading, spacing: 10) {
                    Text("Enter request code")
                        .customFont(.headline, fontSize: 24)
                    Text("Enter the 6-digit code provided by the organization.")
                        .customFont(.body, fontSize: 17)
                        .padding(.bottom, 40)

                    OTPView(numberOfFields: numberOfFields, otp: $requestCode, valid: $isValid)
                        .onChange(of: requestCode) { newOtp in
                            if newOtp.count == numberOfFields && !newOtp.isEmpty{
                                print(newOtp)
                                isValid = true
                            }
                        }
                        .focused($isFocused)

                    Button {
                        showingAlert = true
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
}

#Preview {
    OnboardingView()
}
