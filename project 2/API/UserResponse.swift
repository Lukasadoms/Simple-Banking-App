//
//  UserResponse.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/9/21.
//

import Foundation

struct UserResponse: Decodable {
    var userID: String
    var phoneNumber: String
    var password: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "id"
        case phoneNumber, password
    }
}
