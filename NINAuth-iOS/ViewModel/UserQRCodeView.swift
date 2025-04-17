//
//  UserQRCodeView.swift
//  NINAuth-iOS
//
//  Created by Arogundade Qoyum on 15/04/2025.


import SwiftUI
import CoreImage.CIFilterBuiltins
import RealmSwift

struct QRCodeUserDataView: View {
    @ObservedResults(User.self) var user
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()

    var body: some View {
        VStack {
            if let currentUser = user.first {
                let userData: [String: String] = [
                    "surname": currentUser.last_name ?? "",
                    "first_name": currentUser.first_name ?? "",
                    "middle_name": currentUser.middle_name ?? "",
                    "gender": currentUser.gender ?? "",
                    "nin": currentUser.nin ?? "",
                    "dob": currentUser.getDOB(),
                    "origin_state": currentUser.origin_state ?? "N/A",
                    "origin_lga": currentUser.origin_local_government ?? "N/A"
                ]

                if let jsonData = try? JSONEncoder().encode(userData),
                   let jsonString = String(data: jsonData, encoding: .utf8),
                   let qrImage = generateQRCode(from: jsonString) {
                    Image(uiImage: qrImage)
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .padding()
                } else {
                    Text("Failed to generate QR code.")
                        .foregroundColor(.red)
                }
            } else {
                Text("No user data available")
                    .foregroundColor(.gray)
            }
        }
    }

    func generateQRCode(from string: String) -> UIImage? {
        filter.message = Data(string.utf8)
        if let outputImage = filter.outputImage,
           let cgimg = context.createCGImage(outputImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10)), from: outputImage.extent) {
            return UIImage(cgImage: cgimg)
        }
        return nil
    }
}

#Preview {
    QRCodeUserDataView()
}
