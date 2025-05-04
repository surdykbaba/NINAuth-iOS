//
//  PinProtocol.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 05/02/2025.
//
import SwiftyJSON

protocol PinProtocol {
    
    func setPin(setPinRequest: SetPinRequest) async -> Result<Bool, ErrorBag>
    
    func updatePin(updatePinRequest: UpdatePinRequest) async -> Result<Bool, ErrorBag>
    
    func resetPin(resetPinRequest: ResetPinRequest) async -> Result<JSON, ErrorBag>
    
    func resetNewPin(setNewPin: SetNewPin) async -> Result<Bool, ErrorBag>
}
