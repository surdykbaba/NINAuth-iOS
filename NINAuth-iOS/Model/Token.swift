//
//  Token.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 28/01/2025.
//

import Foundation
import RealmSwift
import SwiftyJSON

class Token: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var session: String?
    @Persisted var requestCode: String? = ""

    convenience init(value: JSON?){
        self.init()
        
        self.session = value?["session"].string
        self.requestCode = value?["requestCode"].string
    }
}
