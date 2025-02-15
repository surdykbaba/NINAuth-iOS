//
//  AuthViewModel.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 05/02/2025.
//

import Foundation

@MainActor
class AuthViewModel: ObservableObject  {
    
    @Published private(set) var state: LoadingState = .idle
    @Published var continueReg = false
    @Published var verifyStatus = ""
    @Published var isLoggedIn = false
    @Published private(set) var requestCode: String?
    @Published private(set) var logOut = false
    
    private let authService: AuthService
    
    init() {
        authService = AuthService()
    }
    
    func registerUser(registerUserRequest: RegisterUserRequest) async -> Void {
        guard state != .loading else {
            return
        }
        state = .loading
        let result = await authService.registerUser(registerUserRequest: registerUserRequest)
        switch result {
        case .success(_):
            continueReg = true
            state = .success
        case .failure(let failure):
            state = .failed(failure)
        }
    }
    
    func registerUserSelfie(registerUserSelfieRequest: RegisterUserSelfieRequest) async -> Void {
        guard state != .loading else {
            return
        }
        state = .loading
        let result = await authService.registerUserSelfie(registerUserSelfieRequest: registerUserSelfieRequest)
        switch result {
        case .success(let res):
            // NOTE: Verify Status is either "passed" or "process"
            verifyStatus = res["FaceAuthCompleted"].stringValue
            state = .success
        case .failure(let failure):
            state = .failed(failure)
        }
    }
    
    func getFaceAuthStatus(deviceID: String) async -> Void {
        guard state != .loading else {
            return
        }
        state = .loading
        let result = await authService.getFaceAuthStatus(deviceID: deviceID)
        switch result {
        case .success(let res):
            // NOTE: Verify Status is either "passed" or "process"
            verifyStatus = res["FaceAuthCompleted"].stringValue
            state = .success
        case .failure(let failure):
            state = .failed(failure)
        }
    }
    
    func loginUser(loginUserRequest: LoginUserRequest) async -> Void {
        guard state != .loading else {
            return
        }
        state = .loading
        let result = await authService.login(loginUserRequest: loginUserRequest)
        switch result {
        case .success(_):
            isLoggedIn = true
            state = .success
        case .failure(let failure):
            state = .failed(failure)
        }
    }
    
    func reGenerateCode() async -> Void {
        guard state != .loading else {
            return
        }
        state = .loading
        let sessionID = await startSession()
        let result = await authService.regenerateCode(sessionID: sessionID)
        switch result {
        case .success(let res):
            requestCode = res["data"]["qrCode"].stringValue
            state = .success
        case .failure(let failure):
            state = .failed(failure)
        }
    }
    
    private func startSession() async -> String {
        let result = await authService.startSession(startSessionRequest: StartSessionRequest())
        switch result {
        case .success(let res):
            return res.sessionId ?? ""
        case .failure(let failure):
            return ""
        }
    }
    
    func logoutUser(logOutRequest: LogOutRequest) async -> Void {
        guard state != .loading else {
            return
        }
        state = .loading
        let result = await authService.logout(logOutRequest: logOutRequest)
        switch result {
        case .success(_):
            logOut = true
            state = .success
        case .failure(let failure):
            state = .failed(failure)
        }
    }
}
