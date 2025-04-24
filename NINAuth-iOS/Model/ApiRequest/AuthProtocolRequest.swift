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

struct RegisterWithNIN: Codable {
    var deviceId: String?
    var ninId: String?
    var deviceMetadata: DeviceMetadata?
}

struct UpdateUserInfo: Codable {
    var ids: [UserkeyPair]?
    var medium: String? = "sms"
}

struct UserkeyPair: Codable {
    var key: String?
    var value: String?
}

struct DeviceMetadata: Codable {
    var os: String? = "IOS"
    var lat: Double?
    var lng: Double?
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
    var sessionId: String?
}


// Request model for sending OTP
struct SendOTPRequest: Codable {
    var receiverId: String?
    var medium: String? = "sms"
    var reason: String? = "contact validation"
}


struct ValidateOTP: Codable {
    var otp: String?
}

struct StartSessionRequest: Codable {
    var enterpriseId: String = "NAT03765128F624"
    var requestType: String = "Account opening"
    var consent: [String] = ["first_name", "middle_name", "last_name", "photo", "telephoneno","origin_local_government","origin_state"]
    var note: String = "For account Opening"
}

struct EmptyRequest: Codable {
    
}
