//
//  GIF.swift
//  IOSproj
//
//  Created by Rana Tarek on 29/01/2025.
//

import Foundation
import RealmSwift

class GIFRealmModel: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var tinygifURL: String = ""
    @objc dynamic var createdAt: Date = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
