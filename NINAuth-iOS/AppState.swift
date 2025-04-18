//
//  AppState.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 15/02/2025.
//
import Foundation
import UIKit
import SwiftUI
import CommonCrypto
import CoreImage.CIFilterBuiltins

class AppState: ObservableObject {
    
    @Published private(set) var state: LoadingState = .idle
    @Published var verifyStatus = ""
    @Published var fromForgotPin = false
    @Published var initialRequestCode = ""
    @Published var latitude: Double = 0
    @Published var longitude: Double = 0
    @Published var main = UUID()
    @Published var userClickedLogout = false
    @Published var userReferesh = false
    private let authService: AuthService
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()
    var timer: Timer? = nil

    init() {
        authService = AuthService()
        timer?.invalidate()
    }
    
    func getDeviceID() -> String {
        var deviceID: String = ""
        if let id = KeyChainHelper.loadData(key: KeyChainHelper.deviceID) {
            deviceID = id
        }else {
            if let uuid = UIDevice.current.identifierForVendor?.uuidString {
                deviceID = uuid
            }else {
                deviceID = createUniqueID()
            }
            
            let res = KeyChainHelper.storeData(key: KeyChainHelper.deviceID, data: deviceID.data(using: .utf8)!)
            Log.info(String(res))
        }
        
        return deviceID
    }
    
    private func createUniqueID() -> String {
        let uuid: CFUUID = CFUUIDCreate(nil)
        let cfStr: CFString = CFUUIDCreateString(nil, uuid)

        let swiftString: String = cfStr as String
        return swiftString
    }
    
    func getUserRandomUniqueNumber() -> String {
        return "user-" + UUID().uuidString
    }
    
    func getFaceAuthStatus(deviceID: String) {
        guard state != .loading else {
            return
        }
        state = .loading
        Task {
            let result = await authService.getFaceAuthStatus(deviceID: deviceID)
            await MainActor.run {
                switch result {
                case .success(let res):
                    // NOTE: Verify Status is either "passed" or "process"
                    verifyStatus = res["status"].stringValue
                    state = .success
                    if(verifyStatus == "passed") {
                        timer?.invalidate()
                    }else {
                        timedEmailCall(id: deviceID)
                    }
                case .failure(let failure):
                    state = .failed(failure)
                    timedEmailCall(id: deviceID)
                }
            }
        }
    }
    
    private func timedEmailCall(id: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] timer in
            self?.getFaceAuthStatus(deviceID: id)
        }
        timer?.tolerance = 0.3
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    private func getRandomBase64String(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func generateQRCode() -> UIImage {
        let random = getRandomBase64String(length: 24)
        filter.message = Data(random.utf8)

        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    func generateHashedQRCode(user: User?) -> UIImage {
        var qrImage: UIImage {
            guard let currentUser = user else {
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

            // Apply color filter to remove white background
            guard let colorFilter = CIFilter(name: "CIFalseColor") else {
                return UIImage(systemName: "xmark.circle")!
            }

            colorFilter.setDefaults()
            colorFilter.setValue(outputImage, forKey: kCIInputImageKey)
            colorFilter.setValue(CIColor(color: .black), forKey: "inputColor0") // QR code color
            colorFilter.setValue(CIColor.clear, forKey: "inputColor1")          // Background color (transparent)

            guard let coloredImage = colorFilter.outputImage else {
                return UIImage(systemName: "xmark.circle")!
            }

            let scaledImage = coloredImage.transformed(by: CGAffineTransform(scaleX: 7, y: 7))

            if let cgimg = context.createCGImage(scaledImage, from: scaledImage.extent) {
                return UIImage(cgImage: cgimg)
            }

            return UIImage(systemName: "xmark.circle")!
        }

        return qrImage
    }

    
    // SHA-1 hashing function
    private func sha1(_ input: String) -> String {
        let data = Data(input.utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &digest)
        }
        return digest.map { String(format: "%02x", $0) }.joined()
    }
    
    class AccountService {
        static func deleteAccount(deviceId: String, authToken: String, completion: @escaping (Result<Void, Error>) -> Void) {
            guard let url = URL(string: "https://your-api.com/auth/account") else {
                return completion(.failure(URLError(.badURL)))
            }

            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.setValue(deviceId, forHTTPHeaderField: "device-id")
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")

            URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    completion(.failure(error))
                } else if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                    completion(.success(()))
                } else {
                    completion(.failure(URLError(.badServerResponse)))
                }
            }.resume()
        }
    }
}
