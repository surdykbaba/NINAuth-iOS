//
//  ConsentService.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 05/02/2025.
//
import Foundation
import SwiftyJSON

struct ConsentService: ConsentProtocol {
    
    func giveConsent(consentCreated: ConsentCreate) async -> Result<Bool, ErrorBag> {
        do {
            var request = NetworkResponseModel.generateHeader(endpoint: URLs.CONSENT, authoriseHeader: true)
            request.httpMethod = APIVerb.POST.rawValue
            let jsonData = try? JSONEncoder().encode(consentCreated)
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
    
    func getUserConsents() async -> Result<ConsentResponse, ErrorBag> {
        let networkResponse = await Service.init().get(URLs.ALL_CONSENT)
        switch networkResponse.isSuccess() {
        case true:
            do {
                let res = try JSONDecoder().decode(ConsentResponse.self, from: networkResponse.getData() ?? Data())
                return .success(res)
            }catch {
                Log.error(error.localizedDescription)
                return .failure(ErrorBag())
            }
        default:
            return .failure(networkResponse.getErrorBag())
        }
    }
    
    func verifyConsent(consentCode: ConsentCode) async -> Result<ConsentRequest, ErrorBag> {
        let networkResponse = await Service.init().post(URLs.VERIFY_CONSENT, params: consentCode)
        switch networkResponse.isSuccess() {
        case true:
            do {
                let res = try JSONDecoder().decode(ConsentRequest.self, from: networkResponse.getData() ?? Data())
                return .success(res)
            }catch {
                Log.error(error.localizedDescription)
                return .failure(ErrorBag())
            }
        default:
            let str = String(decoding: networkResponse.getData() ?? Data(), as: UTF8.self)
            Log.error(str)
            return .failure(networkResponse.getErrorBag())
        }
    }
    
    func updateConsent(consentUpdate: ConsentUpdate) async -> Result<Bool, ErrorBag> {
        do {
            var request = NetworkResponseModel.generateHeader(endpoint: URLs.UPDATE_CONSENT, authoriseHeader: true)
            request.httpMethod = APIVerb.PATCH.rawValue
            let jsonData = try? JSONEncoder().encode(consentUpdate)
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
    
}
