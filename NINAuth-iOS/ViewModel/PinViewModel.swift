//
//  PinViewModel.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 05/02/2025.
//
import Foundation

class PinViewModel: ObservableObject {
    
    @Published private(set) var state: LoadingState = .idle
    @Published var pinIsSet: Bool = false
    @Published private(set) var pinUpdated: Bool = false
    @Published var randomNumber: Int = 0
    

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
    
}
