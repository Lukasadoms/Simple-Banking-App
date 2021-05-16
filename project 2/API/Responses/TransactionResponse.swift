//
//  TransactionResponse.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/15/21.
//

import Foundation

struct TransactionResponse: Codable {
    let id: String
    let senderId: String
    let receiverId: String
    let amount: Double
    let currency: String
    let createdOn: Int
    let reference: String
}

