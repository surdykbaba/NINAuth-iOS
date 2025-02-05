//
//  ConsentProtocolRequest.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 05/02/2025.
//

struct ConsentCreate: Codable {
    var requestCode: String?
    var deviceId: String?
    var consent: [String?]?
    var status: String?
    var medium: String?
}

struct ConsentCode: Codable {
    var deviceId: String?
    var requestCode: String?
}
