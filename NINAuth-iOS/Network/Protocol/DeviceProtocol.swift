//
//  DeviceProtocol.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 05/02/2025.
//

protocol DeviceProtocol {
    
    func giveDevices() async -> Result<[Device], ErrorBag>
    
    func deleteDevice(deviceRequest: DeviceRequest) async -> Result<Bool, ErrorBag>
}
