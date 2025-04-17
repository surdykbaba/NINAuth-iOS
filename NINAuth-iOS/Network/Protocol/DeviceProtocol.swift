//
//  DeviceProtocol.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 05/02/2025.
//
import SwiftyJSON

protocol DeviceProtocol {
    
    func getDevices() async -> Result<[Device], ErrorBag>
    
    func deleteDevice(deviceRequest: DeviceRequest) async -> Result<Bool, ErrorBag>
    
    func getShareCode() async -> Result<JSON?, ErrorBag>
    
    func getShareLogs(code: String) async -> Result<[Consent], ErrorBag>
    
    func regenerateShareCode() async -> Result<JSON?, ErrorBag>
}
