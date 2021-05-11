//
//  TokenResponse.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/11/21.
//

import Foundation

struct UserTokenResponse: Decodable {
    let accessToken: String
    let expiresIn: Int
}
