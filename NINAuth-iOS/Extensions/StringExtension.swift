//
//  StringExtension.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 21/02/2025.
//

import Foundation
import UIKit

extension String {
    var localized: String {
        return NSLocalizedString(self, comment:"")
    }
    
    var imageFromBase64: UIImage? {
        guard let imageData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return UIImage(data: imageData)
    }
}
