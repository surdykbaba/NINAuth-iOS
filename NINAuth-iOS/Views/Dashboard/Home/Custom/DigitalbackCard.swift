//
//  UserQRCodeView.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 15/04/2025.

import SwiftUI
import RealmSwift
import CoreImage.CIFilterBuiltins

struct DigitalbackCard: View {
    @ObservedResults(User.self) var user
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()

    var qrImage: UIImage {
        guard let currentUser = user.first else {
            return UIImage(systemName: "xmark.circle")!
        }

        let credentialSubject: [String: String] = [
            "firstName": currentUser.first_name ?? "",
            "middleName": currentUser.middle_name ?? "",
            "gender": currentUser.gender ?? "",
            "dateOfBirth": currentUser.getDOB()
        ]

        let issuedAtDate = Date()
        let issuedAtUnix = Int(issuedAtDate.timeIntervalSince1970)

        let payload: [String: Any] = [
            "type": ["VerifiableCredential"],
            "credentialSubject": credentialSubject,
            "issuer": "NINAuth",
            //"issuanceDate": issuedAtDate.iso8601String(),
            "issuanceDate": String(issuedAtUnix)
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
}

extension Date {
    func iso8601String() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: self)
    }
}

#Preview {
    DigitalbackCard()
}
