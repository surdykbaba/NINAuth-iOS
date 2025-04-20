//
//  Service.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 28/01/2025.
//

import Foundation
import RealmSwift
import SwiftyJSON
import UIKit

struct Service{
    
    func post<T: Codable>(_ urlString: String, params: T?, authoriseHeader: Bool = true, increaseTimeout: Bool = false) async -> NetworkResponseModel {
        do {
            var request = NetworkResponseModel.generateHeader(endpoint: urlString, authoriseHeader: authoriseHeader)
            request.httpMethod = "POST"
            let jsonData = try? JSONEncoder().encode(params)
            request.httpBody = jsonData
            if(increaseTimeout) {
                request.timeoutInterval = 120
            }
            #if DEBUG
            try? Log.info("The sending json body \(params.jsonPrettyPrinted())")
            #endif
        
            let (data, response) = try await URLSession.shared.data(for: request)
            let httpResponse = response as? HTTPURLResponse
            let networkResponse = NetworkResponseModel(statusCode: (httpResponse?.statusCode ?? 0))
            if(networkResponse.isSuccess()) {
                if(networkResponse.statusCode != 204) {
                    let jsonValue = try JSON(data: data)
                    #if DEBUG
                    print(jsonValue)
                    #endif
                    return NetworkResponseModel(statusCode: networkResponse.statusCode, data: data, json: jsonValue)
                }else {
                    return NetworkResponseModel(statusCode: networkResponse.statusCode, data: data)
                }
            }else {
                return NetworkResponseModel(statusCode: networkResponse.statusCode, data: data)
            }
        }catch {
            Log.error("\(urlString) -->\(error.localizedDescription)")
            return NetworkResponseModel(statusCode: 0, data: nil, errorMessage: error.localizedDescription)
        }
    }
    
    func get(_ urlString: String, authoriseHeader: Bool = true) async -> NetworkResponseModel {
        do {
            var request = NetworkResponseModel.generateHeader(endpoint: urlString, authoriseHeader: authoriseHeader)
            request.httpMethod = "GET"
        
            let (data, response) = try await URLSession.shared.data(for: request)
            let httpResponse = response as? HTTPURLResponse
            let networkResponse = NetworkResponseModel(statusCode: (httpResponse?.statusCode ?? 0))
            if(networkResponse.isSuccess()) {
                let jsonValue = try JSON(data: data)
                #if DEBUG
                print(jsonValue)
                #endif
                return NetworkResponseModel(statusCode: networkResponse.statusCode, data: data, json: jsonValue)
            }else {
                return NetworkResponseModel(statusCode: networkResponse.statusCode, data: data)
            }
        }catch {
            Log.error("\(urlString) -->\(error)")
            return NetworkResponseModel(statusCode: 0, data: nil, errorMessage: error.localizedDescription)
        }
    }
    
    func patch<T: Codable>(_ urlString: String, params: T?, authoriseHeader: Bool = true) async -> NetworkResponseModel {
        do {
            var request = NetworkResponseModel.generateHeader(endpoint: urlString, authoriseHeader: authoriseHeader)
            request.httpMethod = "PATCH"
            let jsonData = try? JSONEncoder().encode(params)
            request.httpBody = jsonData
            #if DEBUG
            try? Log.info("The sending json body \(params.jsonPrettyPrinted())")
            #endif
        
            let (data, response) = try await URLSession.shared.data(for: request)
            let httpResponse = response as? HTTPURLResponse
            let networkResponse = NetworkResponseModel(statusCode: (httpResponse?.statusCode ?? 0))
            if(networkResponse.isSuccess()) {
                let jsonValue = try JSON(data: data)
                #if DEBUG
                print(jsonValue)
                #endif
                return NetworkResponseModel(statusCode: networkResponse.statusCode, data: data, json: jsonValue)
            }else {
                return NetworkResponseModel(statusCode: networkResponse.statusCode, data: data)
            }
        }catch {
            Log.error("\(urlString) -->\(error.localizedDescription)")
            return NetworkResponseModel(statusCode: 0, data: nil, errorMessage: error.localizedDescription)
        }
    }
    
    func put<T: Codable>(_ urlString: String, params: T?, authoriseHeader: Bool = true) async -> NetworkResponseModel {
        do {
            var request = NetworkResponseModel.generateHeader(endpoint: urlString, authoriseHeader: authoriseHeader)
            request.httpMethod = "PUT"
            let jsonData = try? JSONEncoder().encode(params)
            request.httpBody = jsonData
            #if DEBUG
            try? Log.info("The sending json body \(params.jsonPrettyPrinted())")
            #endif
        
            let (data, response) = try await URLSession.shared.data(for: request)
            let httpResponse = response as? HTTPURLResponse
            let networkResponse = NetworkResponseModel(statusCode: (httpResponse?.statusCode ?? 0))
            if(networkResponse.isSuccess()) {
                if(networkResponse.statusCode != 204) {
                    let jsonValue = try JSON(data: data)
                    #if DEBUG
                    print(jsonValue)
                    #endif
                    return NetworkResponseModel(statusCode: networkResponse.statusCode, data: data, json: jsonValue)
                }else {
                    return NetworkResponseModel(statusCode: networkResponse.statusCode, data: data)
                }
            }else {
                return NetworkResponseModel(statusCode: networkResponse.statusCode, data: data)
            }
        }catch {
            Log.error("\(urlString) -->\(error.localizedDescription)")
            return NetworkResponseModel(statusCode: 0, data: nil, errorMessage: error.localizedDescription)
        }
    }
    
    func delete<T: Codable>(_ urlString: String, params: T?, authoriseHeader: Bool = true) async -> NetworkResponseModel {
        do {
            var request = NetworkResponseModel.generateHeader(endpoint: urlString, authoriseHeader: authoriseHeader)
            request.httpMethod = "DELETE"
            let jsonData = try? JSONEncoder().encode(params)
            request.httpBody = jsonData
            #if DEBUG
            try? Log.info("The sending json body \(params.jsonPrettyPrinted())")
            #endif
        
            let (data, response) = try await URLSession.shared.data(for: request)
            let httpResponse = response as? HTTPURLResponse
            let networkResponse = NetworkResponseModel(statusCode: (httpResponse?.statusCode ?? 0))
            if(networkResponse.isSuccess()) {
                if(networkResponse.statusCode != 204) {
                    let jsonValue = try JSON(data: data)
                    #if DEBUG
                    print(jsonValue)
                    #endif
                    return NetworkResponseModel(statusCode: networkResponse.statusCode, data: data, json: jsonValue)
                }else {
                    return NetworkResponseModel(statusCode: networkResponse.statusCode, data: data)
                }
            }else {
                return NetworkResponseModel(statusCode: networkResponse.statusCode, data: data)
            }
        }catch {
            Log.error("\(urlString) -->\(error.localizedDescription)")
            return NetworkResponseModel(statusCode: 0, data: nil, errorMessage: error.localizedDescription)
        }
    }
    
}

struct NetworkResponseModel {
    fileprivate var statusCode: Int
    private var data: Data?
    private var errorMessage: String?
    private var errorTitle: String?
    private var json: JSON?
   
    
    init(statusCode: Int) {
        self.statusCode = statusCode
    }
    
    init(statusCode: Int, data: Data? = nil, json: JSON? = nil, errorMessage: String? = nil, errorTitle: String? = "Error") {
        self.statusCode = statusCode
        self.data = data
        self.errorMessage = errorMessage
        self.errorTitle = errorTitle
        self.json = json
        
        if !self.isSuccess(),
           self.errorMessage == nil{
            self.errorMessage = getNetworkErrorMessage()
        }
    }
    
    func getStatusCode() -> Int {
        return statusCode
    }
    
    static func initLogoutResponse(errorMessage: String? = nil) -> NetworkResponseModel {
        return NetworkResponseModel(statusCode: 403)
    }
    
    func isSuccess() -> Bool {
        return statusCode == 200 || statusCode == 201 || statusCode == 204
    }
    
    fileprivate func isFailed() -> Bool {
        return statusCode == 422
    }
    
    fileprivate func isBadRequest() -> Bool {
        return statusCode == 404 || statusCode == 400
    }
    
    fileprivate func isAuthorizationError() -> Bool {
        return statusCode == 401 || statusCode == 403
    }
    
    func getData() -> Data? {
        return data
    }
    
    func getJson() -> JSON? {
        return json
    }
    
    func getErrorBag() -> ErrorBag {
        let errorBag = ErrorBag(title: errorTitle ?? "", description: getNetworkErrorMessage() ?? "")
        return errorBag
    }
    
    private func getNetworkErrorMessage() -> String? {
        if isBadRequest() {
            return getBadRequestMessage(_data: data as Any)
        }else if isFailed() {
            return getValidationErrorMessage(_data: data as Any)
        }else if isAuthorizationError() {
            return "Unauthorized request"
        }else {
            return "Unable to fecth details, try again later"
        }
    }
    
    private func getBadRequestMessage(_data : Any) -> String {
        var msg: String = ""
        do{
            if let safeData = _data as? Data{
                let json = try JSON(data: safeData)
                if let safeMessage = json["error"].string{
                    msg = safeMessage
                }
            }
        }catch{ msg = error.localizedDescription }
        return msg
    }
    
    private func getValidationErrorMessage(_data: Any) -> String? {
        var desc: String? = ""
        do{
            if let _data = _data as? Data{
                let _data = try JSON(data: _data)
                desc = _data["error"].stringValue
            }
        }catch { }
        return desc
    }
    
    fileprivate static func getToken() -> String {
        do {
            let realm = try Realm()
            let token = realm.objects(Token.self).first
            Log.info(token?.session ?? "")
            return token?.session ?? ""
        } catch{
            Log.error(error.localizedDescription)
        }
        return ""
    }
    
    static func generateHeader(endpoint: String, authoriseHeader: Bool) -> URLRequest {
        Log.info(URLs.baseurl + endpoint)
        let url = URL(string: URLs.baseurl + endpoint)
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.setValue(getDeviceID(), forHTTPHeaderField: "device-id")
        if(authoriseHeader) {
            request.setValue("Bearer \(getToken())", forHTTPHeaderField: "Authorization")
        }
//        if let fields = request.allHTTPHeaderFields {
//            // get your authorization token here
//            // it probably is in the headers
//            for (_, field) in fields.enumerated() {
//                // ACTIONS REQUIRED FROM YOU:
//                // do something here to match field's key so that you get the authorization token
//                #if DEBUG
//                print(field)
//                #endif
//            }
//        }
        return request
    }
    
    private static func getDeviceID() -> String {
        var deviceID: String = ""
        if let id = KeyChainHelper.loadData(key: KeyChainHelper.deviceID) {
            deviceID = id
        }else {
            if let uuid = UIDevice.current.identifierForVendor?.uuidString {
                deviceID = uuid
            }else {
                deviceID = createUniqueID()
            }
            
            let res = KeyChainHelper.storeData(key: KeyChainHelper.deviceID, data: deviceID.data(using: .utf8)!)
            Log.info(String(res))
        }
        
        return deviceID
    }
    
    private static func createUniqueID() -> String {
        let uuid: CFUUID = CFUUIDCreate(nil)
        let cfStr: CFString = CFUUIDCreateString(nil, uuid)

        let swiftString: String = cfStr as String
        return swiftString
    }
    
//    static func generateSecretHeader(endpoint: String, authoriseHeader: Bool) -> URLRequest {
//        Log.info(URLs.baseurl + endpoint)
//        let clientID = Bundle.main.object(forInfoDictionaryKey: "CLIENT_ID") as! String
//        let clientSecret = Bundle.main.object(forInfoDictionaryKey: "CLIENT_SECRET") as! String
//        let url = URL(string: URLs.baseurl + endpoint)
//        var request = URLRequest(url: url!)
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("*/*", forHTTPHeaderField: "Accept")
//        request.setValue("client-id", forHTTPHeaderField: clientID)
//        request.setValue("client-secret", forHTTPHeaderField: clientSecret)
//        if(authoriseHeader) {
//            request.setValue("Bearer " + getToken(), forHTTPHeaderField: "Authorization")
//        }
//        return request
//    }
}

protocol CustomError: Error {
    var title: String { get }
    var description: String { get }
}

struct ErrorBag: CustomError, Equatable {
    var title: String
    var description: String
    
    init() {
        self.title = "Error"
        self.description = "Data Error"
    }
    
    init(title: String) {
        self.title = title
        self.description = "Unknown Error"
    }
    
    init(description: String) {
        self.title = "Error"
        self.description = description
    }
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}

enum LoadingState: Equatable {
    case idle
    case loading
    case success
    case failed(ErrorBag)
}

enum APIVerb: String, CaseIterable {
    case POST = "POST"
    case GET = "GET"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
}

