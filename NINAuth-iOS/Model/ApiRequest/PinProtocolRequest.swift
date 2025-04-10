//
//  PinProtocolRequest.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 05/02/2025.
//

struct SetPinRequest: Codable {
    var deviceId: String?
    var pin: String?
    var requestCode: String?
}

struct UpdatePinRequest: Codable {
    var deviceId: String?
    var oldPin: String?
    var newPin: String?
}

struct ResetPinRequest: Codable {
    var deviceId: String?
    var ninId: String?
    var deviceMetadata: DeviceMetadata?
}

struct SetNewPin: Codable {
    var newPin: String?
}
