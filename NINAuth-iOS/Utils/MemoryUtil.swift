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
