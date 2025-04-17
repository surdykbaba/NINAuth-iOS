//
//  AuthProtocol.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 05/02/2025.
//
import SwiftyJSON

protocol AuthProtocol {
    func registerUser(registerUserRequest: RegisterUserRequest) async -> Result<Bool, ErrorBag>
    
    func registerUserSelfie(registerUserSelfieRequest: RegisterUserSelfieRequest) async -> Result<JSON, ErrorBag>
    
    func login(loginUserRequest: LoginUserRequest) async -> Result<Bool, ErrorBag>

    func logout(logOutRequest: LogOutRequest) async -> Result<Bool, ErrorBag>
    
    func getFaceAuthStatus(deviceID: String) async -> Result<JSON, ErrorBag>
    
    func loginWithNIN(loginWithNIN: LoginWithNIN) async -> Result<Bool, ErrorBag>
    
    func registerWithNIN(registerWithNIN: RegisterWithNIN) async -> Result<Bool, ErrorBag>
    
    func updateUserInfo(updateUserInfo: UpdateUserInfo) async -> Result<Bool, ErrorBag>
    
    func sendOTP(sendOTPRequest: SendOTPRequest) async -> Result<Bool, ErrorBag>
    
    func validateOTP(validateOTP: ValidateOTP) async -> Result<Bool, ErrorBag>
    
    func resetDevice() async -> Result<Bool, ErrorBag>
}
