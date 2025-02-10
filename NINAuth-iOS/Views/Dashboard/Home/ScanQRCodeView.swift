//
//  ScanQRCodeView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 05/02/2025.
//

import SwiftUI

struct ScanQRCodeView: View {
    var body: some View {
        Color.secondaryGrayBackground
            .ignoresSafeArea()
            .overlay(
                ScrollView {
                    VStack(spacing: 10) {
                        VStack(alignment: .leading) {
                            HStack(spacing: 15) {
                                Image("barcode_green")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                Text("Scan QR code to give consent")
                                    .customFont(.headline, fontSize: 17)
                            }
                            .padding(.bottom, 30)
                            
                            Divider()
                                .frame(maxWidth: .infinity)
                                .padding(.bottom, 20)
                            
                            HStack(spacing: 30) {
                                VStack(alignment: .leading, spacing: 20) {
                                    Text("Point your camera at the organization’s QR code to choose which NIN details you would like to share.")
                                    Button {} label: {
                                        Text("Scan QR code")
                                            .customFont(.title, fontSize: 18)
                                            .foregroundStyle(Color.button)
                                    }
                                    .frame(width: 170, height: 50)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                                            .stroke(Color.button, lineWidth: 1)
                                    )
                                }
                                Image("barcode")
                                    .resizable()
                                    .frame(width: 97, height: 117)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 30)
                        .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.white))
                        
                        VStack(alignment: .leading) {
                            HStack(spacing: 30) {
                                VStack(alignment: .leading, spacing: 20) {
                                    Text("Enter request code")
                                        .customFont(.headline, fontSize: 17)
                                    Text("If you are unable to scan a QR code, you can type in the 6-digit code provided by the organization.")
                                    Button {} label: {
                                        Text("Enter code")
                                            .customFont(.title, fontSize: 18)
                                            .foregroundStyle(Color.button)
                                    }
                                    .frame(width: 170, height: 50)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                                            .stroke(Color.button, lineWidth: 1)
                                    )
                                }
                                Image("phone_yellow")
                                    .resizable()
                                    .frame(width: 97, height: 117)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 30)
                        .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.white))
                        
                        Spacer()
                    }
                    .padding()
                }
            )
    }
}

#Preview {
    ScanQRCodeView()
}
