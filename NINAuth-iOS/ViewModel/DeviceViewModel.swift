//
//  DeviceViewModel.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 05/02/2025.
//
import Foundation

@MainActor
class DeviceViewModel: ObservableObject {
    
    @Published private(set) var state: LoadingState = .idle
    @Published var loadingDevices: Bool = false
    @Published var devices: [Device] = []
    @Published var deviceRemoved: Bool = false
    @Published var shareCode: String = ""
    @Published var expiry: Int = 30
    @Published var consents: [Consent] = []
    
    
    private let deviceService: DeviceService
    
    init() {
        deviceService = DeviceService()
    }
    
    func getDevices() async -> Void {
        guard state != .loading else {
            return
        }
        state = .loading
        loadingDevices = true
        let result = await deviceService.getDevices()
        switch result {
        case .success(let allDevice):
            devices = allDevice
            state = .success
            loadingDevices = false
        case .failure(let failure):
            state = .failed(failure)
            loadingDevices = false
        }
    }
    
    func deleteDevice(deviceRequest: DeviceRequest) async -> Void {
        let deletedDevice = devices.filter{ $0.device_id == deviceRequest.deviceId }.first
        guard state != .loading else {
            return
        }
        state = .loading
        let result = await deviceService.deleteDevice(deviceRequest: deviceRequest)
        switch result {
        case .success(_):
            devices.removeAll { $0.device_id == deletedDevice?.device_id }
            deviceRemoved = true
            state = .success
        case .failure(let failure):
            state = .failed(failure)
        }
    }
    
    func getShareCode() async -> Void {
        guard state != .loading else {
            return
        }
        state = .loading
        let result =  await deviceService.getShareCode()
        switch result {
        case .success(let json):
            state = .success
            shareCode = json?["data"]["share_code"].string ?? ""
            expiry = json?["data"]["days_to_expire"].int ?? 30
            Task {
                await getLogs(code: shareCode)
            }
        case .failure(let failure):
            state = .failed(failure)
        }
    }
    
    func getLogs(code: String) async -> Void {
        guard state != .loading else {
            return
        }
        state = .loading
        let result =  await deviceService.getShareLogs(code: code)
        switch result {
        case .success(let data):
            state = .success
            consents = data
        case .failure(let failure):
            state = .failed(failure)
        }
    }
    
    func regenerateShareCode() async -> Void {
        guard state != .loading else {
            return
        }
        state = .loading
        let result =  await deviceService.regenerateShareCode()
        switch result {
        case .success(let json):
            state = .success
            shareCode = json?["data"]["share_code"].string ?? ""
            expiry = json?["data"]["days_to_expire"].int ?? 30
//            Task {
//                await getLogs(code: shareCode)
//            }
        case .failure(let failure):
            state = .failed(failure)
        }
    }
    
}
