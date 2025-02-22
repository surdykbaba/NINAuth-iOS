//
//  AuthProtocolRequest.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 05/02/2025.
//

struct RegisterUserRequest: Codable {
    var deviceId: String?
    var requestCode: String?
    var ninId: String?
    var deviceMetadata: DeviceMetadata?
}

 struct DeviceMetadata: Codable {
    var os: String? = "IOS"
}

struct RegisterUserSelfieRequest: Codable {
    var deviceId: String?
    var images: [SelfieImage?]?
}

struct SelfieImage: Codable {
    var image_type: String?
    var image: String?
}

struct LoginUserRequest: Codable {
    var deviceId: String?
    var pin: String?
    var device: DeviceMetadata?
}

struct LoginWithNIN: Codable {
    var deviceId: String?
    var pin: String?
    var ninId: String?
    var device: DeviceMetadata?
}

struct LogOutRequest: Codable {
    var deviceId: String?
}

struct StartSessionRequest: Codable {
    var enterpriseId: String = "NAT03765128F624"
    var requestType: String = "Account opening"
    var consent: [String] = ["first_name", "middle_name", "last_name", "photo", "telephoneno"]
    var note: String = "For account Opening"
}
