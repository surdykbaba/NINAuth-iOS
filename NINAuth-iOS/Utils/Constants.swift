//
//  Constants.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 10/06/2025.
//

import Foundation

struct Constants {
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}
