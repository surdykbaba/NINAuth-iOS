//
//  User.swift
//  NINAuth-iOS
//
//  Created by Maxwell Nwanna on 28/01/2025.
//

import Foundation
import RealmSwift
import SwiftyJSON

class User: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: String?
    @Persisted var nin: String? = ""
    @Persisted var first_name: String? = ""
    @Persisted var last_name: String? = ""
    @Persisted var gender: String? = ""
    @Persisted var phone_number: String? = ""
    @Persisted var date_of_birth: String?
    @Persisted var address: String? = ""
    @Persisted var image: String? = ""
    @Persisted var FaceAuthCompleted: String? = ""
    @Persisted var created_at: String? = ""
    @Persisted var updated_at: String? = ""
    
    convenience init(value: JSON?){
        self.init()
        
        self.id = value?["id"].string
        self.nin = value?["nin"].string
        self.first_name = value?["first_name"].string
        self.last_name = value?["last_name"].string
        self.gender = value?["gender"].string
        self.phone_number = value?["phone_number"].string
        self.date_of_birth = value?["date_of_birth"].string
        self.address = value?["address"].string
        self.image = value?["image"].string
        self.FaceAuthCompleted = value?["FaceAuthCompleted"].string
        self.created_at = value?["created_at"].string
        self.updated_at = value?["updated_at"].string
    
    }
}
