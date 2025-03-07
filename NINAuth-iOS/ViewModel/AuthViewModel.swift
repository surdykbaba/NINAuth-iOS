//
//  AuthViewModel.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 05/02/2025.
//

import Foundation
import RealmSwift

@MainActor
class AuthViewModel: ObservableObject  {
    
    @Published private(set) var state: LoadingState = .idle
    @Published var continueReg = false
    @Published var verifyStatus = ""
    @Published var isLoggedIn = false
    @Published private(set) var requestCode: String?
    @Published var logOut = false

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
            verifyStatus = res["face_auth_completed"].stringValue
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
            verifyStatus = res["face_auth_completed"].stringValue
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
        case .success(let userResponse):
            isLoggedIn = true
            Log.info(userResponse.description)
            state = .success
        case .failure(let failure):
            state = .failed(failure)
        }
    }
    
    func loginWithNIN(loginWithNIN: LoginWithNIN) async -> Void {
        guard state != .loading else {
            return
        }
        state = .loading
        let result = await authService.loginWithNIN(loginWithNIN: loginWithNIN)
        switch result {
        case .success(let userResponse):
            isLoggedIn = true
            Log.info(userResponse.description)
            state = .success
        case .failure(let failure):
            state = .failed(failure)
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
            do {
                let realm = try await Realm()
                try? realm.write {
                    realm.deleteAll()
                }
            }catch {
                Log.info(error.localizedDescription)
            }
            logOut = true
            state = .success
        case .failure(let failure):
            state = .failed(failure)
        }
    }
}
