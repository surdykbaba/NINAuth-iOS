//
//  LinkedIDViewModel.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 05/02/2025.
//
import Foundation

@MainActor
class LinkedIDViewModel: ObservableObject {
    
    @Published private(set) var state: LoadingState = .idle
    @Published var linkedIds: [LinkedIDs] = []
    @Published var score: Double = 3.0
    @Published var displayedScore: Int = 0
    
    private let linkedIDService: LinkedIDService
    
    init() {
        linkedIDService = LinkedIDService()
    }
    
    func getLinkedIDs() async -> Void {
        guard state != .loading else {
            return
        }
        state = .loading
        let result = await linkedIDService.getLinkedIDs()
        switch result {
        case .success(let linkID):
            linkedIds = linkID
            state = .success
        case .failure(let failure):
            state = .failed(failure)
        }
    }
    
    func getScore(deviceID: String) async -> Void {
        guard state != .loading else {
            return
        }
        state = .loading
        let result = await linkedIDService.getScore(deviceID: deviceID)
        switch result {
        case .success(let result):
            score = Double(result / 100)
            displayedScore = result
            state = .success
        case .failure(let failure):
            state = .failed(failure)
            score = 0.0
            displayedScore = 0
        }
    }
}

