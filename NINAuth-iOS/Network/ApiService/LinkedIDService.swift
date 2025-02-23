//
//  LinkedIDService.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 05/02/2025.
//
import Foundation
import SwiftyJSON

struct LinkedIDService: LinkedIDProtocol {
    
    func getLinkedIDs() async -> Result<[LinkedIDs], ErrorBag> {
        let networkResponse = await Service.init().get(URLs.LINKEDID)
        switch networkResponse.isSuccess() {
        case true:
            do {
                let res = try JSONDecoder().decode([LinkedIDs].self, from: networkResponse.getData() ?? Data())
                return .success(res)
            }catch {
                Log.error(error.localizedDescription)
                return .failure(ErrorBag())
            }
        default:
            return .failure(networkResponse.getErrorBag())
        }
    }
}
