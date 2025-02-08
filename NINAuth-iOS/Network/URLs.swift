//
//  URLs.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 28/01/2025.
//

enum URLs {
    
    static var baseurl: String {
        #if DEBUG
        return "https://api.ninauth.com/api/v1/"
        #else
        return "https://api.ninauth.com/api/v1/"
        #endif
    }
    
    
    //MARK: Auth
    static let REGISTER_USER = "auth/register"
    static let REGISTER_USER_SELFIE = "auth/face-auth"
    static let LOGIN = "auth/login"
    static let LOGOUT = "auth/logout"
    static let FACE_AUTH_STATUS = "auth/face-auth-status/"
    static let RE_GENERATE_CODE = "integration/enterprise/online/session/regenerate/"
    static let START_SESSION = "integration/enterprise/online/session/create"
    
    
    
    //MARK: Consent
    static let CONSENT = "consent"
    static let ALL_CONSENT = "consent/all"
    static let VERIFY_CONSENT = "request-code/verify"
    
    
    
    //MARK: Devices
    static let DEVICES = "devices"
    
    
    
    //MARK: LinkedID
    static let LINKEDID = "ids"
    
    
    
    //MARK: Pin
    static let SET_PIN = "pin/new-user/set"
    static let UPDATE_PIN = "pin/update"
    
}

