//
//  ConsentProtocolRequest.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 05/02/2025.
//

struct ConsentCreate: Codable {
    var requestCode: String?
    var status: String?
}

struct ConsentCode: Codable {
    var deviceId: String?
    var requestCode: String?
}

struct ConsentUpdate: Codable {
    var status: String?
    var consentId: String?
}
