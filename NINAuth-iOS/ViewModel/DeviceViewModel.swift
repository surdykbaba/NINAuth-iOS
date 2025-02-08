//
//  DeviceViewModel.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 05/02/2025.
//
import Foundation

class DeviceViewModel: ObservableObject {
    
    @Published private(set) var state: LoadingState = .idle
    @Published var devices: [Device] = []
    @Published var deviceRemoved: Bool = false
    
    
    private let deviceService: DeviceService
    
    init() {
        deviceService = DeviceService()
    }
    
    func getDevices() async -> Void {
        guard state != .loading else {
            return
        }
        state = .loading
        let result = await deviceService.getDevices()
        switch result {
        case .success(let allDevice):
            devices = allDevice
            state = .success
        case .failure(let failure):
            state = .failed(failure)
        }
    }
    
    func deleteDevice(deviceRequest: DeviceRequest) async -> Void {
        guard state != .loading else {
            return
        }
        state = .loading
        let result = await deviceService.deleteDevice(deviceRequest: deviceRequest)
        switch result {
        case .success(let result):
            deviceRemoved = true
            state = .success
        case .failure(let failure):
            state = .failed(failure)
        }
    }
    
}
