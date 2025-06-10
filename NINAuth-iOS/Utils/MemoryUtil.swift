//
//  MemoryUtil.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 26/02/2025.
//

import Foundation

struct MemoryUtil {
    
    let authentication_key = "Enable_Authentication"
    let lock_app = "LocKK_APPPP"
    let notification_push_key = "Push_nin_auth_notification_fire_base_apn" // Notification device
    let apn_data = "APn_nin_auth_data" // APN key
    
    func setValue(key: String, value: Any) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
    }
    
    func getDataValue(key: String) -> Data? {
        let defaults = UserDefaults.standard
        return defaults.data(forKey: key)
    }
    
    func getStringValue(key: String) -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: key)
    }
    
    func getBoolValue(key: String) -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: key)
    }
    
}
