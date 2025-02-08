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
    
    func regenerateCode(sessionID: String) async -> Result<JSON, ErrorBag>
    
    func startSession(startSessionRequest: StartSessionRequest) async -> Result<SessionResponse, ErrorBag>

}
