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
            "id": "did:nin:\(currentUser.nin)",
            "firstName": currentUser.first_name ?? "",
            "middleName": currentUser.middle_name ?? "",
            "lastName": currentUser.last_name ?? "",
            "gender": currentUser.gender ?? "",
            "stateOfOrigin": currentUser.origin_state ?? "",
            "lga": currentUser.origin_local_government ?? "",
            "dateOfBirth": currentUser.getDOB()
        ]

        let payload: [String: Any] = [
            "@context": ["https://www.w3.org/2018/credentials/v1"],
            "type": ["VerifiableCredential"],
            "credentialSubject": credentialSubject,
            "issuer": "https://nin.gov.ng",
            "issuanceDate": Date().iso8601String()
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
                .frame(width: 100, height: 100)
                .cornerRadius(4)
                .offset(x: -10)
                .offset(y: -10)
        }
        .frame(maxWidth: 370, maxHeight: 242)
    }
}

extension Date {
    func iso8601String() -> String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: self)
    }
}

#Preview {
    DigitalbackCard()
}
