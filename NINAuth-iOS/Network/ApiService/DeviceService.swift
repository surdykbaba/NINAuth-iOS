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
    
    
}
