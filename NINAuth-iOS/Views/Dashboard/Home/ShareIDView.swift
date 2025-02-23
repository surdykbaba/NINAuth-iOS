//
//  ShareIDView.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 06/02/2025.
//

import CoreImage.CIFilterBuiltins
import SwiftUI

struct ShareIDView: View {
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()

    var body: some View {
        ScrollView {
            VStack {
                Text("share_my_id".localized)
                    .customFont(.subheadline, fontSize: 24)

                Image(uiImage: generateQRCode(from: "https://ninauth.com/privacy-policy"))
                    .interpolation(.none)
                    .resizable()
                    .frame(width: 240, height: 240)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 20)

                VStack(alignment: .leading, spacing: 20) {
                    Text("your_qr_code_is_your_digital_id_When_you_share_it_with_an organization_you_can_select_what_information_can_be_shared_with_them.".localized)
                        .padding(.bottom, 10)

                    HStack(alignment: .top) {
                        VStack {
                            Circle()
                                .frame(width: 10, height: 10)
                            RoundedRectangle(cornerRadius: 1)
                                .frame(width: 3, height: 50)
                                .foregroundColor(.gray.opacity(0.4))
                        }
                        Text("allow_organizations_or_entities_to_scan_the_displayed_qr_code_to_share_your_nin_data.".localized)
                            .frame(maxWidth: .infinity, alignment: .top)
                    }
                    .frame(maxWidth: .infinity)

                    HStack(alignment: .top) {
                        VStack {
                            Circle()
                                .frame(width: 10, height: 10)
                            RoundedRectangle(cornerRadius: 1)
                                .frame(width: 3, height: 35)
                                .foregroundColor(.gray.opacity(0.4))
                        }
                        Text("share_the_pin_below_the_qr_code_for_authentication".localized)
                    }

                    HStack(alignment: .top) {
                        Circle()
                            .frame(width: 10, height: 10)
                        Text("QR code changes every 2 minutes")
                    }
                }
                .customFont(.caption, fontSize: 16)
                .frame(maxWidth: .infinity)
                .foregroundColor(.black)
                .padding(20)
                .padding(.vertical, 10)
                .cornerRadius(10)
                .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.transparentGreenBackground))

                Button {} label: {
                    Text("got_it".localized)
                        .customFont(.title, fontSize: 18)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(Color.button)
                .cornerRadius(4)
            }
            .padding()
        }

    }

    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)

        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

#Preview {
    ShareIDView()
}
