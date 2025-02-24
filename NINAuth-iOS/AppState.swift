//
//  AppState.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 15/02/2025.
//
import Foundation
import UIKit
import SwiftUI

class AppState: ObservableObject {
    
    @Published private(set) var state: LoadingState = .idle
    @AppStorage("biometricsIsOn") var biometricsIsOn = false
    @Published var verifyStatus = ""
    private let authService: AuthService
    var timer: Timer? = nil

    init() {
        authService = AuthService()
        timer?.invalidate()
    }
    
    func getDeviceID() -> String {
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
    
    private func createUniqueID() -> String {
        let uuid: CFUUID = CFUUIDCreate(nil)
        let cfStr: CFString = CFUUIDCreateString(nil, uuid)

        let swiftString: String = cfStr as String
        return swiftString
    }
    
    func getUserRandomUniqueNumber() -> String {
        return "user-" + UUID().uuidString
    }
    
    func getFaceAuthStatus(deviceID: String) {
        guard state != .loading else {
            return
        }
        state = .loading
        Task {
            let result = await authService.getFaceAuthStatus(deviceID: deviceID)
            await MainActor.run {
                switch result {
                case .success(let res):
                    // NOTE: Verify Status is either "passed" or "process"
                    verifyStatus = res["FaceAuthCompleted"].stringValue
                    state = .success
                    if(verifyStatus == "passed") {
                        timer?.invalidate()
                    }else {
                        timedEmailCall(id: deviceID)
                    }
                case .failure(let failure):
                    state = .failed(failure)
                    timedEmailCall(id: deviceID)
                }
            }
        }
    }
    
    private func timedEmailCall(id: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] timer in
            self?.getFaceAuthStatus(deviceID: id)
        }
        timer?.tolerance = 0.3
        RunLoop.current.add(timer!, forMode: .common)
    }
}
