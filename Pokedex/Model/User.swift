//
//  User.swift
//  Pokedex
//
//  Created by Nathat Kuanthanom on 12/11/2566 BE.
//

import Foundation

struct User: Identifiable, Codable{
    let id: String
    let firstname: String
    let lastname: String
    let email: String
}

//extension User{
//    static var MOCK_USER = User(id: NSUUID().uuidString, firstname: "John", lastname: "Doe", email: "jd@mail.com")
//}
