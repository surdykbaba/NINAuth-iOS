//
//  DeviceProtocol.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 05/02/2025.
//

protocol DeviceProtocol {
    
    func getDevices() async -> Result<[Device], ErrorBag>
    
    func deleteDevice(deviceRequest: DeviceRequest) async -> Result<Bool, ErrorBag>
    
    func getShareCode() async -> Result<String, ErrorBag>
}
