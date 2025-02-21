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
                                Text("scan_qr_code_to_give_consent")
                                    .customFont(.headline, fontSize: 17)
                            }
                            .padding(.bottom, 30)
                            
                            Divider()
                                .frame(maxWidth: .infinity)
                                .padding(.bottom, 20)
                            
                            HStack(spacing: 30) {
                                VStack(alignment: .leading, spacing: 20) {
                                    Text("point_your_camera_at_the_organization’s_qr_code_to_choose_which_nin_details_you_would_like_to_share.")
                                    Button {} label: {
                                        Text("scan_qr_code")
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
                                    Text("enter_request_code")
                                        .customFont(.headline, fontSize: 17)
                                    Text("if_you_are_unable_to_scan_a_QR_code_you_can_type_in_the_6-digit_code_provided_by_the_organization.")
                                    Button {} label: {
                                        Text("enter_code")
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
