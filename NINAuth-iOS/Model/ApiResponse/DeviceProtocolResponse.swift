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
}


struct DeleteAt: Codable {
    var Time: String?
    var Valid: Bool?
}
