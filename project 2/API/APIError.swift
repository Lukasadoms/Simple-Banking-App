//
//  APIErrors.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/9/21.
//

import Foundation

enum APIError: Error {
    case failedRequest
    case unexpectedDataFormat
    case failedResponse
    case failedURLCreation
    case userDoesntExist
    
    var errorDescription: String {
        switch self {
        case .failedRequest:
            return "Missing required values, or passwords don`t match!"
        case .unexpectedDataFormat:
            return "Error try again later!"
        case .failedResponse:
            return "Error try again later!"
        case .failedURLCreation:
            return "Error try again later!"
        case .userDoesntExist:
            return "Account with this username is not found!"
        }
    }
}
