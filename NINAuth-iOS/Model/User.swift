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
    @Persisted var nin: String?
    @Persisted var first_name: String?
    @Persisted var middle_name: String?
    @Persisted var last_name: String?
    @Persisted var gender: String?
    @Persisted var phone_number: String?
    @Persisted var date_of_birth: String?
    @Persisted var address: String?
    @Persisted var image: String?
    @Persisted var face_auth_completed: String?
    @Persisted var created_at: String?
    @Persisted var updated_at: String?
    @Persisted var origin_local_government: String?
    @Persisted var origin_state: String?
    @Persisted var registration_medium: String?
    @Persisted var last_login: String?
    convenience init(value: JSON?){
        self.init()
        
        self.id = value?["id"].string
        self.nin = value?["nin"].string
        self.first_name = value?["first_name"].string
        self.middle_name = value?["middle_name"].string
        self.last_name = value?["last_name"].string
        self.gender = value?["gender"].string
        self.phone_number = value?["phone_number"].string
        self.date_of_birth = value?["date_of_birth"].string
        self.address = value?["address"].string
        self.image = value?["image"].string
        self.face_auth_completed = value?["face_auth_completed"].string
        self.created_at = value?["created_at"].string
        self.updated_at = value?["updated_at"].string
        self.origin_local_government = value?["origin_local_government"].string
        self.origin_state = value?["origin_state"].string
        self.registration_medium = value?["registration_medium"].string
        self.last_login = value?["last_login"].string
    }
    
    func getDOB() -> String {
        if (date_of_birth == nil) {
            return ""
        }else {
            let date = date_of_birth?.convertToDate(formater: DateFormat.yrMonthDayFormat)
            let stringDate = date?.getFormattedDate(format: DateFormat.dateFormat) ?? ""
            return stringDate
        }
    }
    
    func getLastLogin() -> String {
        if (last_login == nil) {
            return ""
        }else {
            let date = last_login?.convertToDate(formater: DateFormat.UniversalDateFormat)
            let stringDate = date?.getFormattedDate(format: DateFormat.fineDateFormat) ?? ""
            return stringDate
        }
    }
}
