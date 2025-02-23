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
}

