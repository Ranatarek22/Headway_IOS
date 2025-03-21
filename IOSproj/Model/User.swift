//
//  User.swift
//  FinalProject
//
//  Created by Rana Tarek on 25/01/2025.
//

import Foundation

struct User : Identifiable, Codable {
    let id :String
    var fullName : String
    let email :String
    let mobileNumber:String
    
    var intials: String {
        let formatter = PersonNameComponentsFormatter()
        
        if let components = formatter.personNameComponents(from: fullName){
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
  
}
extension User {
    static var MOCK_USER = User(id : NSUUID().uuidString,fullName: "Rana Tarek", email: "rt589611@gmail.com", mobileNumber: "01019404727")
}
