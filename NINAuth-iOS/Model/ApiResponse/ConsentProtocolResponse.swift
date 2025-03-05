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


struct Consent: Codable, Hashable {
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
    var request_id: String?
    
    func getDisplayDate() -> String {
        if (updated_at == nil) {
            return ""
        }else {
            let date = updated_at?.convertToDate(formater: DateFormat.UniversalDateFormat)
            let stringDate = date?.getFormattedDate(format: DateFormat.Dateformat) ?? ""
            return stringDate
        }
    }
    
    func getRequestString() -> String {
        let stringArray = data_requested?.map { $0 ?? "" }
        return stringArray?.joined(separator: ", ") ?? ""
    }
}

struct Enterprise: Codable, Hashable {
    var id: String?
    var name: String?
    var logo: String?
    var website: String?
    var client_id: String?
}


struct ConsentRequest: Codable {
    var consent: Consent?
    var enterprise: Enterprise?
}


struct EnterpriseInRequest: Codable {
    var name: String?
    var industry: String?
}
