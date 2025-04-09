//
//  LoginView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 27/01/2025.
//

import SwiftUI
import CodeScanner

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = AuthViewModel()
    @State private var showSheet = false
    @State private var isValid = true
    @State private var isPresentingScanner = false
    @State private var scannedCode: String?
    @State private var showingAlert = false
    @State private var goNext = false
    @State private var identificationNumber = ""
    @FocusState private var nameIsFocused: Bool
    @State private var errTitle = ""
    @State private var showDialog = false

    var body: some View {
        ZStack {
            VStack {
                NavigationLink {
                    LoginView()
                } label: {
                    Text("login")
                        .customFont(.title, fontSize: 18)
                        .foregroundStyle(Color("buttonColor"))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                Spacer()
                
                Image("nigerian_coat_of_arms")
                
                Spacer()
                
                VStack(spacing: 10) {
                    Text("verify_identity_and_authorize_data_access")
                        .customFont(.title, fontSize: 18)
                        .multilineTextAlignment(.center)
                    Text("ensure_your_privacy_manage_and_control")
                        .customFont(.body, fontSize: 16)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                VStack(spacing: 20) {
                    Button {
                        isPresentingScanner.toggle()
                        appState.fromForgotPin = false
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
                        Text("sign_up_with_nin")
                            .customFont(.title, fontSize: 18)
                            .foregroundStyle(Color.button)
                    }
                    .alert("Invalid pin", isPresented: $showingAlert) {
                        Button("Ok"){
                            showSheet = false
                        }
                    } message: {
                        Text("Please scan QR code")
                    }
                }
                
                Group {
                    NavigationLink(destination: CheckIdentityView(code: scannedCode ?? ""), isActive: $goNext) {}.isDetailLink(false)
                }
                .frame(width: 0, height: 0)
            }
            .padding()
            .onChange(of: scannedCode) { _ in
                if let code = scannedCode {
                    appState.initialRequestCode = code
                    goNext.toggle()
                }
            }
            .onAppear {
                scannedCode = nil
                viewModel.initiateLocationRequest()
            }
            .onChange(of: viewModel.userLocation) { _ in
                appState.latitude = viewModel.userLocation?.coordinate.latitude ?? 0.00
                appState.longitude = viewModel.userLocation?.coordinate.longitude ?? 0.00
            }
            .sheet(isPresented: $isPresentingScanner) {
                QRCodeScanner(result: $scannedCode)
                //            CodeScannerView(codeTypes: [.qr]) { response in
                //                if case let .success(result) = response {
                //                    scannedCode = result.string
                //                    Log.info(scannedCode ?? "nothing")
                //                    isPresentingScanner = false
                //                }
                //            }
            }
            
            NavigationLink(destination: VerifyIdentityView(), isActive: $viewModel.continueReg) {}.isDetailLink(false)
                .frame(width: 0, height: 0)
            
            BottomSheetView(isPresented: $showSheet) {
                requestCodeView
            }
            
            if case .loading = viewModel.state {
                ProgressView()
                    .scaleEffect(2)
            }
            
            if case .failed(let errorBag) = viewModel.state {
                Color.clear.onAppear() {
                    errTitle = errorBag.description
                    showDialog.toggle()
                }
                .frame(width: 0, height: 0)
            }
        }
    }

    var requestCodeView: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 15, height: 15, alignment: .trailing)
                    .padding(.top, 0)
                    .onTapGesture {
                        showSheet.toggle()
                    }
            }
            .padding(.vertical)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("enter_your_national_identification_number")
                    .customFont(.headline, fontSize: 24)
                Text("your_info_is_secure")
                    .customFont(.body, fontSize: 16)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom)

                VStack(alignment: .leading) {
                    Text("national_identification_number")
                        .customFont(.subheadline, fontSize: 16)
                    TextField("12345678910", text: $identificationNumber)
                        .keyboardType(.numberPad)
                        .customTextField()
                        .focused($nameIsFocused)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke()
                            .fill(isValid ? .gray : .red)
                        )
                        .onAppear(perform: {
                            isValid = true
                        })
                        .onChange(of: identificationNumber) { _ in
                            if(identificationNumber.count > 11) {
                                identificationNumber = String(identificationNumber.prefix(11))
                            }
                            
                            if(identificationNumber.count == 11) {
                                nameIsFocused = false
                            }
                        }
                    if !isValid {
                        Text("nin_must_be_11_digits_long".localized)
                            .customFont(.subheadline, fontSize: 16)
                            .foregroundColor(.red)
                    }
                }
                .padding(.bottom, 60)
                .padding(.top, 20)

                Button {
                    if(identificationNumber.count != 11) {
                        isValid = false
                    }else {
                        isValid = true
                        Task {
                            await viewModel.registerWithNIN(registerWithNIN: RegisterWithNIN(deviceId: appState.getDeviceID(), ninId: identificationNumber, deviceMetadata: DeviceMetadata(lat: appState.latitude, lng:appState.longitude)))
                        }
                    }
                } label: {
                    Text("Continue")
                        .customFont(.title, fontSize: 18)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .cornerRadius(4)
                .background(Color.button)
                .padding(.bottom, 30)
            }
        }
        .padding()
        .background(Color(.white))
        .alert("Error", isPresented: $showDialog) {
            Button("OK", role: .cancel) {}
        }message: {
            Text(errTitle)
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppState())
}
