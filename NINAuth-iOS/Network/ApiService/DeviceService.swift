//
//  DeviceService.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 05/02/2025.
//
import SwiftyJSON
import Foundation

struct DeviceService: DeviceProtocol {
    
    func getDevices() async -> Result<[Device], ErrorBag> {
        let networkResponse = await Service.init().get(URLs.DEVICES)
        switch networkResponse.isSuccess() {
        case true:
            do {
                let res = try JSONDecoder().decode([Device].self, from: networkResponse.getData() ?? Data())
                return .success(res)
            }catch {
                Log.error(error.localizedDescription)
                return .failure(ErrorBag())
            }
        default:
            return .failure(networkResponse.getErrorBag())
        }
    }
    
    func deleteDevice(deviceRequest: DeviceRequest) async -> Result<Bool, ErrorBag> {
        let networkResponse = await Service.init().delete(URLs.DEVICES, params: deviceRequest)
        switch networkResponse.isSuccess() {
        case true:
            return .success(true)
        default:
            return .failure(networkResponse.getErrorBag())
        }
    }
    
    func getShareCode() async -> Result<String, ErrorBag> {
        let networkResponse = await Service.init().get(URLs.SHARE_CODE)
        switch networkResponse.isSuccess() {
        case true:
            let code = networkResponse.getJson()?["data"]["share_code"].string ?? ""
            return .success(code)
        default:
            return .failure(networkResponse.getErrorBag())
        }
    }
    
    func getShareLogs(code: String) async -> Result<[Consent], ErrorBag> {
        let networkResponse = await Service.init().get(URLs.SHARE_CODE_LOGS + "\(code)/logs")
        switch networkResponse.isSuccess() {
        case true:
            do {
                let res = try JSONDecoder().decode([Consent].self, from: networkResponse.getJson()?["data"]["share_code_logs"].array?.data() ?? Data())
                return .success(res)
            }catch {
                Log.error(error.localizedDescription)
                return .failure(ErrorBag())
            }
        default:
            return .failure(networkResponse.getErrorBag())
        }
    }
    
    
}
