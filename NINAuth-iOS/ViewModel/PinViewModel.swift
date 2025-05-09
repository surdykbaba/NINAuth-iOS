//
//  PinViewModel.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 05/02/2025.
//
import Foundation

@MainActor
class PinViewModel: ObservableObject {
    
    @Published private(set) var state: LoadingState = .idle
    @Published var userID: String = ""
    @Published var jobID: String = ""
    @Published var pinIsSet: Bool = false
    @Published var newPinSet: Bool = false
    @Published private(set) var pinUpdated: Bool = false
    @Published var randomNumber: Int = 0
    @Published var forgotPinSet: Bool = false
    

    private let pinService: PinService
    
    init() {
        pinService = PinService()
    }
    
    func setPin(setPinRequest: SetPinRequest) async -> Void {
        guard state != .loading else {
            return
        }
        state = .loading
        let result = await pinService.setPin(setPinRequest: setPinRequest)
        switch result {
        case .success(_):
            pinIsSet = true
            state = .success
        case .failure(let failure):
            state = .failed(failure)
        }
    }
    
    func updatePin(updatePinRequest: UpdatePinRequest) async -> Void {
        guard state != .loading else {
            return
        }
        state = .loading
        let result = await pinService.updatePin(updatePinRequest: updatePinRequest)
        switch result {
        case .success(_):
            pinUpdated = true
            state = .success
        case .failure(let failure):
            state = .failed(failure)
        }
    }

    private func randomNumberWith(_ digits:Int) -> Int {
        let min = Int(pow(Double(10), Double(digits-1))) - 1
        let max = Int(pow(Double(10), Double(digits))) - 1
        return Int(Range(uncheckedBounds: (min, max)))
    }
    
    func generateRandomNumber() {
        randomNumber = randomNumberWith(6)
    }
    
    func forgotPin(resetPinRequest: ResetPinRequest) async -> Void {
        guard state != .loading else {
            return
        }
        state = .loading
        let result = await pinService.resetPin(resetPinRequest: resetPinRequest)
        switch result {
        case .success(let json):
            userID = json["user_id"].string ?? ""
            jobID = json["enrollment_jon_id"].string ?? ""
            forgotPinSet = true
            state = .success
        case .failure(let failure):
            state = .failed(failure)
        }
    }
    
    
    func setNewPin(setNewPin: SetNewPin) async -> Void {
        guard state != .loading else {
            return
        }
        state = .loading
        let result = await pinService.resetNewPin(setNewPin: setNewPin)
        switch result {
        case .success(_):
            newPinSet = true
            state = .success
        case .failure(let failure):
            state = .failed(failure)
        }
    }
    
}
