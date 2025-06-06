//
//  LinkedIDService.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 05/02/2025.
//
import Foundation
import SwiftyJSON

struct LinkedIDService: LinkedIDProtocol {
    
    func getLinkedIDs() async -> Result<[LinkedIDs], ErrorBag> {
        let networkResponse = await Service.init().get(URLs.LINKEDID)
        switch networkResponse.isSuccess() {
        case true:
            do {
                let res = try JSONDecoder().decode([LinkedIDs].self, from: networkResponse.getData() ?? Data())
                return .success(res)
            }catch {
                Log.error(error.localizedDescription)
                return .failure(ErrorBag())
            }
        default:
            return .failure(networkResponse.getErrorBag())
        }
    }
    
    func getScore(deviceID: String) async -> Result<Int, ErrorBag> {
        let networkResponse = await Service.init().get(URLs.GET_SCORE + "\(deviceID)/score")
        switch networkResponse.isSuccess() {
        case true:
            let score = networkResponse.getJson()?["score"].int ?? 0
            return .success(score)
        default:
            return .failure(networkResponse.getErrorBag())
        }
    }
    
    func sendDeviceToken(deviceToken: DeviceToken) async -> Result<Bool, ErrorBag> {
        let networkResponse = await Service.init().post(URLs.DEVICE_TOKEN, params: deviceToken)
        switch networkResponse.isSuccess() {
            case true :
            Log.info("Token sent successfully")
            return .success(true)
            default :
            Log.info("Token sending failed")
            return .failure(networkResponse.getErrorBag())
        }
    }
}
