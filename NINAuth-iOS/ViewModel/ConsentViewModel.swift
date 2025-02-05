//
//  ConsentViewModel.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 05/02/2025.
//
import Foundation

@MainActor
class ConsentViewModel: ObservableObject {
    
    @Published private(set) var state: LoadingState = .idle
    @Published private(set) var consent = ConsentResponse()
    @Published private(set) var consentRevoked: Bool = false
    @Published private(set) var consentApprove: Bool = false
    @Published private(set) var consentRequest = ConsentRequest()
    
    
    private let consentService: ConsentService
    
    init() {
        consentService = ConsentService()
    }
    
    func getAllConsents() async -> Void {
        guard state != .loading else {
            return
        }
        state = .loading
        let result = await consentService.getUserConsents()
        switch result {
        case .success(let consentResponse):
            consent = consentResponse
            state = .success
        case .failure(let failure):
            state = .failed(failure)
        }
    }
    
    func rejectConsent(consentCreated: ConsentCreate) async -> Void {
        guard state != .loading else {
            return
        }
        state = .loading
        let result = await consentService.giveConsent(consentCreated: consentCreated)
        switch result {
        case .success(let result):
            consentRevoked = true
            state = .success
        case .failure(let failure):
            state = .failed(failure)
        }
    }
    
    func approveConsent(consentCreated: ConsentCreate) async -> Void {
        guard state != .loading else {
            return
        }
        state = .loading
        let result = await consentService.giveConsent(consentCreated: consentCreated)
        switch result {
        case .success(let result):
            consentApprove = true
            state = .success
        case .failure(let failure):
            state = .failed(failure)
        }
    }
    
    func verifyConsent(consentCode: ConsentCode) async -> Void {
        guard state != .loading else {
            return
        }
        state = .loading
        let result = await consentService.verifyConsent(consentCode: consentCode)
        switch result {
        case .success(let consentReq):
            consentRequest = consentReq
            state = .success
        case .failure(let failure):
            state = .failed(failure)
        }
    }
}
