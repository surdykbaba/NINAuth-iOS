//
//  PinService.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 05/02/2025.
//

import RealmSwift
import SwiftyJSON

struct PinService : PinProtocol {
    
    func setPin(setPinRequest: SetPinRequest) async -> Result<Bool, ErrorBag> {
        let networkResponse = await Service.init().post(URLs.SET_PIN, params: setPinRequest)
        switch networkResponse.isSuccess() {
        case true:
            do {
                let realm = try await Realm()
                try await realm.asyncWrite {
                    let sessionID = realm.objects(Token.self).first?.freeze().session ?? ""
                    let user = User(value: networkResponse.getJson()?["user"])
                    realm.deleteAll()
                    let token = Token()
                    token.session = sessionID
                    realm.add(token, update: .all)
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
    
    func updatePin(updatePinRequest: UpdatePinRequest) async -> Result<Bool, ErrorBag> {
        let networkResponse = await Service.init().patch(URLs.UPDATE_PIN, params: updatePinRequest)
        switch networkResponse.isSuccess() {
        case true:
            return .success(true)
        default:
            return .failure(networkResponse.getErrorBag())
        }
    }
    
    func resetPin(resetPinRequest: ResetPinRequest) async -> Result<JSON, ErrorBag> {
        let networkResponse = await Service.init().put(URLs.RESET_PIN, params: resetPinRequest)
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
                    mem.setValue(key: mem.lock_app, value: false)
                }
                //return .success(networkResponse.getJson()?["user_id"].string ?? "")
                return .success(networkResponse.getJson() ?? JSON())
            }catch {
                Log.error(error.localizedDescription)
                return .failure(ErrorBag())
            }
        default:
            return .failure(networkResponse.getErrorBag())
        }
    }
    
    func resetNewPin(setNewPin: SetNewPin) async -> Result<Bool, ErrorBag> {
        let networkResponse = await Service.init().post(URLs.SET_NEW_PIN, params: setNewPin)
        switch networkResponse.isSuccess() {
        case true:
            do {
                let realm = try await Realm()
                try await realm.asyncWrite {
                    let sessionID = realm.objects(Token.self).first?.freeze().session ?? ""
                    let user = User(value: networkResponse.getJson()?["user"])
                    realm.deleteAll()
                    let token = Token()
                    token.session = sessionID
                    realm.add(token, update: .all)
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
}
