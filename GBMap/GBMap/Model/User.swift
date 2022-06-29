//
//  User.swift
//  GBMap
//
//  Created by Dmitry Zasenko on 20.06.22.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var login: String = ""
    @objc dynamic var password: String = ""
    
    override static func primaryKey() -> String? {
        return "login"
    }
}
