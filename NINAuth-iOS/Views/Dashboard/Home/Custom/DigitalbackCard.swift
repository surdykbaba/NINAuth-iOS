//  UserQRCodeView.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 15/04/2025.
//

import SwiftUI
import RealmSwift
import CoreImage.CIFilterBuiltins
import CommonCrypto

struct DigitalbackCard: View {
    @ObservedResults(User.self) var user
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()

    var qrImage: UIImage {
        guard let currentUser = user.first else {
            return UIImage(systemName: "xmark.circle")!
        }

        // Combine sensitive fields into one string
        let credentialData = [
            currentUser.first_name ?? "",
            currentUser.middle_name ?? "",
            currentUser.gender ?? "",
            currentUser.getDOB(),
            currentUser.nin ?? "",
            currentUser.origin_state ?? "",
        ].joined(separator: "-")

        let hashedCredentials = sha1(credentialData)
        let timestamp = Int(Date().timeIntervalSince1970 * 1000)

        let payload: [String: Any] = [
            "h": hashedCredentials,
            "timestamp": timestamp
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: payload),
              let qrFilter = CIFilter(name: "CIQRCodeGenerator") else {
            return UIImage(systemName: "xmark.circle")!
        }

        qrFilter.setValue(jsonData, forKey: "inputMessage")
        qrFilter.setValue("H", forKey: "inputCorrectionLevel")

        guard let outputImage = qrFilter.outputImage else {
            return UIImage(systemName: "xmark.circle")!
        }

        let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: 7, y: 7))

        if let cgimg = context.createCGImage(scaledImage, from: scaledImage.extent) {
            return UIImage(cgImage: cgimg)
        }

        return UIImage(systemName: "xmark.circle")!
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Image("NinID_Back_new")
                .resizable()
                .frame(height: 242)
                .clipped()

            Image(uiImage: qrImage)
                .interpolation(.none)
                .resizable()
                .frame(width: 120, height: 120)
                .cornerRadius(4)
                .offset(x: -10, y: -10)
        }
        .frame(maxWidth: 370, maxHeight: 242)
    }

    // SHA-1 hashing function
    func sha1(_ input: String) -> String {
        let data = Data(input.utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &digest)
        }
        return digest.map { String(format: "%02x", $0) }.joined()
    }
}

#Preview {
    DigitalbackCard()
}
