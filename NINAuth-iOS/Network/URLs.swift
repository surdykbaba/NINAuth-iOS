//
//  URLs.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 28/01/2025.
//

enum URLs {
    
    static var baseurl: String {
        #if DEBUG
        return "https://enterprise.ninauth.com/api/v1/"
        #else
        return "https://enterprise.ninauth.com/api/v1/"
        #endif
    }
    
    
    //MARK: Auth
    static let REGISTER_USER = "auth/register"
    static let REGISTER_USER_SELFIE = "auth/face-auth"
    static let LOGIN = "auth/login"
    static let LOGIN_NIN = "auth/login-with-nin"
    static let LOGOUT = "auth/logout"
    static let FACE_AUTH_STATUS = "auth/face-auth-status/"
    static let RE_GENERATE_CODE = "integration/enterprise/online/session/regenerate/"
    static let START_SESSION = "integration/enterprise/online/session/create"
    static let REGISTER_WITH_NIN = "auth/register-with-nin"
    static let UPDATE_USER_INFO = "auth/update-user-info"
    static let OTP = "otp"
    static let OTP_VALIDATE = "otp/validate"
    
    
    //MARK: Consent
    static let CONSENT = "consent"
    static let ALL_CONSENT = "consent/all"
    static let VERIFY_CONSENT = "request-code/verify"
    static let UPDATE_CONSENT = "consent/status"
    
    
    
    //MARK: Devices
    static let DEVICES = "devices"
    static let SHARE_CODE = "share-code"
    static let SHARE_CODE_LOGS = "share-code/70053C/logs"
    
    
    
    //MARK: LinkedID
    static let LINKEDID = "ids"
    static let GET_SCORE = "devices/"
    
    
    
    //MARK: Pin
    static let SET_PIN = "pin/new-user/set"
    static let UPDATE_PIN = "pin/update"
    static let RESET_PIN = "auth/new-session"
    static let SET_NEW_PIN = "pin/set-new"
    
}

