//
//  AppState.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 15/02/2025.
//
import Foundation
import UIKit
import SwiftUI
import RealmSwift
import CommonCrypto
import CoreImage.CIFilterBuiltins

class AppState: ObservableObject {
    
    @ObservedResults(User.self) var user
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
    
    func removeDeviceID() {
        KeyChainHelper.removeData(key: KeyChainHelper.deviceID)
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
                    if(verifyStatus == "passed" || verifyStatus == "failed") {
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
        timer = Timer.scheduledTimer(withTimeInterval: 9, repeats: true) { [weak self] timer in
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
    
    
    // Generate first line of MRZ (TD1 format)
    public func generateTD1Line1() -> String {
        // Format: ID<issuing country><document number><check digit>
        let documentType = "ID"
        let issuingCountry = "NGA"
        let documentNumber = formatMRZText(user.first?.nin?.prefix(9).uppercased() ?? "UNKNOWN", maxLength: 9)
        let documentCheckDigit = calculateCheckDigit(documentNumber)
        
        // Optional data (can be used for additional document info)
        let optionalData = formatMRZText("", maxLength: 15)
        
        // Combine all elements
        var line = documentType + issuingCountry + documentNumber + documentCheckDigit + optionalData
        
        // Ensure line is exactly 30 characters
        line = line.padding(toLength: 30, withPad: "<", startingAt: 0)
        
        return line
    }
    
    // Generate second line of MRZ (TD1 format)
    public func generateTD1Line2() -> String {
        // Format: birth date<check digit><sex><expiry date<check digit><nationality><optional data><composite check digit>
        
        // Parse DOB from user data
        let dobString = user.first?.getDOB() ?? "01/01/1990"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dobDate = dateFormatter.date(from: dobString) ?? Date()
        
        dateFormatter.dateFormat = "yyMMdd"
        let formattedDOB = dateFormatter.string(from: dobDate)
        let dobCheckDigit = calculateCheckDigit(formattedDOB)
        
        // Gender (M/F/X)
        let gender = user.first?.gender?.prefix(1).uppercased() ?? "X"
        let validGender = (gender == "M" || gender == "F") ? gender : "X"
        
        // Expiry date (current date + 5 years)
        let expiryDate = Calendar.current.date(byAdding: .year, value: 5, to: Date()) ?? Date()
        let formattedExpiry = dateFormatter.string(from: expiryDate)
        let expiryCheckDigit = calculateCheckDigit(formattedExpiry)
        
        // Nationality
        let nationality = "NGA"
        
        // Optional data
        let optionalData = formatMRZText("", maxLength: 11)
        
        // Calculate composite check digit
        let documentNumber = formatMRZText(user.first?.nin?.prefix(9).uppercased() ?? "UNKNOWN", maxLength: 9)
        let compositeString = documentNumber + calculateCheckDigit(documentNumber) +
                             formattedDOB + dobCheckDigit +
                             formattedExpiry + expiryCheckDigit + optionalData
        let compositeCheckDigit = calculateCheckDigit(compositeString)
        
        // Combine all elements
        var line = formattedDOB + dobCheckDigit + validGender + formattedExpiry + expiryCheckDigit +
                  nationality + optionalData + compositeCheckDigit
        
        // Ensure line is exactly 30 characters
        line = line.padding(toLength: 30, withPad: "<", startingAt: 0)
        
        return line
    }
    
    // Generate third line of MRZ (TD1 format)
    public func generateTD1Line3() -> String {
        // Format: surname<given names
        let surname = user.first?.last_name?.uppercased() ?? "UNKNOWN"
        let givenNames = (user.first?.first_name?.uppercased() ?? "") +
                        (user.first?.middle_name != nil ? " " + user.first!.middle_name!.uppercased() : "")
        
        // Format names
        let formattedSurname = formatMRZText(surname, maxLength: 15)
        let formattedGivenNames = formatMRZText(givenNames, maxLength: 15)
        
        // Combine with proper separator
        var line = formattedSurname + "<<" + formattedGivenNames
        
        // Ensure line is exactly 30 characters
        line = line.padding(toLength: 30, withPad: "<", startingAt: 0)
        
        return line
    }
    
    // Helper function to format text for MRZ
    private func formatMRZText(_ text: String, maxLength: Int) -> String {
        // Replace spaces and special characters with <
        var formatted = text.replacingOccurrences(of: " ", with: "<")
        
        // Remove any characters that aren't allowed in MRZ
        let allowedCharacters = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789<")
        formatted = formatted.components(separatedBy: allowedCharacters.inverted).joined()
        
        // Truncate or pad to exact length
        if formatted.count > maxLength {
            return String(formatted.prefix(maxLength))
        } else {
            return formatted.padding(toLength: maxLength, withPad: "<", startingAt: 0)
        }
    }
    
    // Calculate check digit according to ICAO 9303 standard
    private func calculateCheckDigit(_ input: String) -> String {
        // Weight factors for check digit calculation
        let weights = [7, 3, 1]
        var sum = 0
        
        for (index, char) in input.enumerated() {
            let value: Int
            if char.isNumber {
                value = Int(String(char)) ?? 0
            } else if char.isLetter {
                // A=10, B=11, ..., Z=35
                value = Int(char.asciiValue ?? 0) - 55
            } else if char == "<" {
                value = 0
            } else {
                value = 0
            }
            
            // Apply weight factor based on position
            sum += value * weights[index % 3]
        }
        
        // Return remainder of division by 10
        return String(sum % 10)
    }
}
