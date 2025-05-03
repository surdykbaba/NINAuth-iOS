//
//  PinProtocol.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 05/02/2025.
//

protocol PinProtocol {
    
    func setPin(setPinRequest: SetPinRequest) async -> Result<Bool, ErrorBag>
    
    func updatePin(updatePinRequest: UpdatePinRequest) async -> Result<Bool, ErrorBag>
    
    func resetPin(resetPinRequest: ResetPinRequest) async -> Result<String, ErrorBag>
    
    func resetNewPin(setNewPin: SetNewPin) async -> Result<Bool, ErrorBag>
}
