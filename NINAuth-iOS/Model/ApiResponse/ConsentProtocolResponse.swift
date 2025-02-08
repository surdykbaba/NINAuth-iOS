//
//  ConsentProtocolResponse.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 05/02/2025.
//

struct ConsentResponse: Codable {
    var consents: [Consent]?
    var page: Int?
    var page_size: Int?
    var total_consents: Int?
    var total_pages: Int?
}


struct Consent: Codable {
    var id: String?
    var userId: String?
    var enterprise_id: String?
    var enterprise: Enterprise?
    var data_requested: [String?]?
    var medium: String?
    var reason: String?
    var status: String?
    var created_at: String?
    var updated_at: String?
}

struct Enterprise: Codable {
    var id: String?
    var name: String?
    var logo: String?
    var website: String?
    var client_id: String?
}


struct ConsentRequest: Codable {
    var consent: ConsentInRequest?
    var enterprise: Enterprise?
}


struct ConsentInRequest: Codable {
    var id: String?
    var userId: String?
    var enterprise_id: String?
    var enterprise: EnterpriseInRequest?
    var data_requested: [String]?
    var medium: String?
    var reason: String?
    var status: String?
    var created_at: String?
    var updated_at: String?
}


struct EnterpriseInRequest: Codable {
    var name: String?
    var industry: String?
}
