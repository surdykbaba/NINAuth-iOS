//
//  PinService.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 05/02/2025.
//

struct PinService : PinProtocol {
    
    func setPin(setPinRequest: SetPinRequest) async -> Result<Bool, ErrorBag> {
        let networkResponse = await Service.init().post(URLs.SET_PIN, params: setPinRequest)
        switch networkResponse.isSuccess() {
        case true:
            return .success(true)
        default:
            return .failure(networkResponse.getErrorBag())
        }
    }
    
    func updatePin(updatePinRequest: UpdatePinRequest) async -> Result<Bool, ErrorBag> {
        let networkResponse = await Service.init().patch(URLs.UPDATE_PIN, params: updatePinRequest)
        switch networkResponse.isSuccess() {
        case true:
            return .success(true)
        default:
            return .failure(networkResponse.getErrorBag())
        }
    }
}
