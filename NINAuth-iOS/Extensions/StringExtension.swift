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
        guard let imageData = Data(base64Encoded: self) else {
            return nil
        }
        return UIImage(data: imageData)
    }
    
    func convertToDate(formater: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = formater
        let date = dateFormatter.date(from:self)
        return date
    }
}
