//
//  LinkedIDProtocol.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 05/02/2025.
//

protocol LinkedIDProtocol {
    
    func getLinkedIDs() async -> Result<[LinkedIDs], ErrorBag>
}
