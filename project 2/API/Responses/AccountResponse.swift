//
//  AccountResponse.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/11/21.
//

import Foundation

struct AccountResponse: Codable {
    let id: String
    let phoneNumber: String
    let currency: String
    let balance: Double
}
