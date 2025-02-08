//
//  ConsentProtocol.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 05/02/2025.
//

protocol ConsentProtocol {
    
    func giveConsent(consentCreated: ConsentCreate) async -> Result<Bool, ErrorBag>
    
    func getUserConsents() async -> Result<ConsentResponse, ErrorBag>
    
    func verifyConsent(consentCode: ConsentCode) async -> Result<ConsentRequest, ErrorBag>
}
