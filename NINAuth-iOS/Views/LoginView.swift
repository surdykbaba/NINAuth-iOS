//
//  LoginView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 27/01/2025.
//

import SwiftUI

struct LoginView: View {
    @State private var showSheet = false
    var currentCode = "123456"
    @State var requestCode: String = ""
    private let numberOfFields = 6
    @FocusState var isFocused: Bool
    @State var isValid: Bool = true

    var body: some View {
        VStack {
            Button {} label: {
                Text("Login")
                    .customFont(.title, fontSize: 18)
                    .foregroundStyle(Color("buttonColor"))
            }
            .frame(maxWidth: .infinity, alignment: .trailing)

            Spacer()

            Image("NigerianCoatOfArms")

            Spacer()

            VStack(spacing: 10) {
                Text("Verify identity and authorize data access")
                    .customFont(.title, fontSize: 18)
                Text("Ensure your privacy, manage and control access to your NIN data")
                    .customFont(.body, fontSize: 16)
                    .multilineTextAlignment(.center)
            }

            Spacer()

            VStack(spacing: 20) {
                Button {} label: {
                    HStack {
                        Text("Scan QR code")
                        Image(systemName: "qrcode")
                    }
                    .customFont(.title, fontSize: 18)
                    .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(Color("buttonColor"))
                .cornerRadius(4)
                Button {
                    showSheet.toggle()
                } label: {
                    Text("I have a request code")
                        .customFont(.title, fontSize: 18)
                        .foregroundStyle(Color("buttonColor"))
                }
                .halfSheet(showSheet: $showSheet) {
                    //Write code here
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

                                OTPView(numberOfFields: 6, otp: $requestCode, valid: $isValid)
                                    .onChange(of: requestCode) { newOtp in
                                        if newOtp.count == numberOfFields && newOtp == currentCode {
                                            isValid = true
                                        } else if newOtp != currentCode && newOtp.count == numberOfFields {
                                            isValid = false
                                        }
                                    }
                                    .focused($isFocused)

                                Button {} label: {
                                    Text("Continue")
                                        .customFont(.title, fontSize: 18)
                                        .foregroundStyle(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(Color("buttonColor"))
                                .cornerRadius(4)
                                .disabled(!isValid)
                            }
                        }
                        .padding()
                        .padding(.bottom, 30)
                    }
                    .ignoresSafeArea()
                } onEnd: {
                    print("Dismissed Sheet")
                }
            }
        }
        .padding()
    }
}

#Preview {
    LoginView()
}
