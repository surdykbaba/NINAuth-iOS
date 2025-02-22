//
//  DeviceProtocolResponse.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 05/02/2025.
//

struct Device: Codable {
    var id: String?
    var user_id: String?
    var device_id: String?
    var metadata: DeviceMetadata?
    var created_at: String?
    var deleted_at: DeleteAt?
    var updated_at: String?
    
    func getDisplayedDate() -> String {
        if (updated_at == nil) {
            return ""
        }else {
            let date = updated_at?.convertToDate(formater: DateFormat.UniversalDateFormat)
            let stringDate = date?.getFormattedDate(format: DateFormat.Dateformat) ?? ""
            return stringDate
        }
    }
}


struct DeleteAt: Codable {
    var Time: String?
    var Valid: Bool?
}
