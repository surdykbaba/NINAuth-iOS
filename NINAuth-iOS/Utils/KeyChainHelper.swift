//
//  KeyChainHelper.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 15/02/2025.
//
import Foundation

struct KeyChainHelper {
    
    static var deviceID = "NinAuth_Device_ID_key"
    
    static func storeData(key: String, data: Data) -> Bool {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key,
            kSecValueData as String   : data ] as [String : Any]

        SecItemDelete(query as CFDictionary)

        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    static func loadData(key: String) -> String? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue!,
            kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]

        var dataTypeRef: AnyObject? = nil

        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == noErr {
            if let data = dataTypeRef as! Data? {
                return String(data: data, encoding: .utf8)
            }
        }
        return nil
    }

}
