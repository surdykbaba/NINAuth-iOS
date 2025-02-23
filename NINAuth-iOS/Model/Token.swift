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
    @Persisted(primaryKey: true) var access: String?
    @Persisted var refresh: String? = ""
    @Persisted var requestCode: String? = ""

    convenience init(value: JSON?){
        self.init()
        
        self.access = value?["access"].string
        self.refresh = value?["refresh"].string
        self.requestCode = value?["requestCode"].string
    }
}
