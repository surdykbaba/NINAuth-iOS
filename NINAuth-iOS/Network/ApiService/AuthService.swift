//
//  AuthService.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 05/02/2025.
//
import Foundation
import RealmSwift
import SwiftyJSON

struct AuthService: AuthProtocol {
    
    @MainActor
    func registerUser(registerUserRequest: RegisterUserRequest) async -> Result<Bool, ErrorBag> {
        let networkResponse = await Service.init().post(URLs.REGISTER_USER, params: registerUserRequest, authoriseHeader: false)
        switch networkResponse.isSuccess() {
        case true:
            do {
                let realm = try await Realm()
                try await realm.asyncWrite {
                    let token = Token(value: networkResponse.getJson())
                    token.requestCode = registerUserRequest.requestCode
                    realm.deleteAll()
                    realm.add(token)
                    let mem = MemoryUtil()
                    mem.setValue(key: mem.authentication_key, value: false)
                }
                return .success(true)
            }catch {
                Log.error(error.localizedDescription)
                return .failure(ErrorBag())
            }
        default:
            return .failure(networkResponse.getErrorBag())
        }
    }
    
    func registerUserSelfie(registerUserSelfieRequest: RegisterUserSelfieRequest) async -> Result<JSON, ErrorBag> {
        let networkResponse = await Service.init().post(URLs.REGISTER_USER_SELFIE, params: registerUserSelfieRequest, authoriseHeader: true, increaseTimeout: true)
        
        switch networkResponse.isSuccess() {
        case true:
            return .success(networkResponse.getJson()!)
        default:
            return .failure(networkResponse.getErrorBag())
        }
    }
    
    @MainActor
    func login(loginUserRequest: LoginUserRequest) async -> Result<Bool, ErrorBag> {
        let networkResponse = await Service.init().post(URLs.LOGIN, params: loginUserRequest, authoriseHeader: false)
        switch networkResponse.isSuccess() {
        case true:
            do {
                let realm = try await Realm()
                try await realm.asyncWrite {
                    let token = Token(value: networkResponse.getJson())
                    let user = User(value: networkResponse.getJson()?["user"])
                    realm.deleteAll()
                    realm.add(token)
                    realm.add(user)
                }
                return .success(true)
            }catch {
                Log.error(error.localizedDescription)
                return .failure(ErrorBag())
            }
        default:
            return .failure(networkResponse.getErrorBag())
        }
    }
    
    func logout(logOutRequest: LogOutRequest) async -> Result<Bool, ErrorBag> {
        do {
            var request = NetworkResponseModel.generateHeader(endpoint: URLs.LOGOUT, authoriseHeader: true)
            request.httpMethod = "POST"
            let jsonData = try? JSONEncoder().encode(logOutRequest)
            request.httpBody = jsonData
            let (data, response) = try await URLSession.shared.data(for: request)
            let httpResponse = response as? HTTPURLResponse
            let networkResponse = NetworkResponseModel(statusCode: (httpResponse?.statusCode ?? 0))
            if(networkResponse.isSuccess()) {
                return .success(true)
            }else {
                let networkResponseFailed = NetworkResponseModel(statusCode: networkResponse.getStatusCode(), data: data)
                return .failure(networkResponseFailed.getErrorBag())
            }
        }catch {
            let networkResponse = NetworkResponseModel(statusCode: 0, data: nil, errorMessage: error.localizedDescription)
            return .failure(networkResponse.getErrorBag())
        }
    }
    
    func getFaceAuthStatus(deviceID: String) async -> Result<JSON, ErrorBag> {
        let networkResponse = await Service.init().get(URLs.FACE_AUTH_STATUS + deviceID, authoriseHeader: true)
        switch networkResponse.isSuccess() {
        case true:
            return .success(networkResponse.getJson()!)
        default:
            return .failure(networkResponse.getErrorBag())
        }
    }
    
    @MainActor
    func loginWithNIN(loginWithNIN: LoginWithNIN) async -> Result<Bool, ErrorBag> {
        let networkResponse = await Service.init().post(URLs.LOGIN_NIN, params: loginWithNIN, authoriseHeader: false)
        switch networkResponse.isSuccess() {
        case true:
            do {
                let realm = try await Realm()
                try await realm.asyncWrite {
                    let token = Token(value: networkResponse.getJson())
                    let user = User(value: networkResponse.getJson()?["user"])
                    realm.deleteAll()
                    realm.add(token)
                    realm.add(user)
                }
                return .success(true)
            }catch {
                Log.error(error.localizedDescription)
                return .failure(ErrorBag())
            }
        default:
            return .failure(networkResponse.getErrorBag())
        }
    }
    
    func registerWithNIN(registerWithNIN: RegisterWithNIN) async -> Result<Bool, ErrorBag> {
        let networkResponse = await Service.init().post(URLs.REGISTER_WITH_NIN, params: registerWithNIN, authoriseHeader: false)
        switch networkResponse.isSuccess() {
        case true:
            do {
                let realm = try await Realm()
                try await realm.asyncWrite {
                    let token = Token(value: networkResponse.getJson())
                    realm.deleteAll()
                    realm.add(token)
                    let mem = MemoryUtil()
                    mem.setValue(key: mem.authentication_key, value: false)
                }
                return .success(true)
            }catch {
                Log.error(error.localizedDescription)
                return .failure(ErrorBag())
            }
        default:
            return .failure(networkResponse.getErrorBag())
        }
    }
    
    func updateUserInfo(updateUserInfo: UpdateUserInfo) async -> Result<Bool, ErrorBag> {
        let networkResponse = await Service.init().post(URLs.UPDATE_USER_INFO, params: updateUserInfo)
        switch networkResponse.isSuccess() {
        case true:
            return .success(true)
        default:
            return .failure(networkResponse.getErrorBag())
        }
    }
    
    func sendOTP(sendOTPRequest: SendOTPRequest) async -> Result<Bool, ErrorBag> {
        let networkResponse = await Service.init().post(URLs.OTP, params: sendOTPRequest)
        switch networkResponse.isSuccess() {
        case true:
            return .success(true)
        default:
            return .failure(networkResponse.getErrorBag())
        }
    }
    
    func validateOTP(validateOTP: ValidateOTP) async -> Result<Bool, ErrorBag> {
        let networkResponse = await Service.init().post(URLs.OTP_VALIDATE, params: validateOTP)
        switch networkResponse.isSuccess() {
        case true:
            return .success(true)
        default:
            return .failure(networkResponse.getErrorBag())
        }
    }
    
}
