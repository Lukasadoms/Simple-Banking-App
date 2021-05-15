//
//  APIEndpoints.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/9/21.
//

import Foundation

enum APIEndpoint {
    case checkUser(phoneNumber: String)
    case checkAccount(phoneNumber: String)
    case user
    case getUserToken(user: UserResponse)
    case account
    case getUserTransactions(phoneNumber: String)


    var url: URL? {
        switch self {
        case .checkUser(let phoneNumber):
            let queryItem = URLQueryItem(name: PhoneNumberQueryKey, value: phoneNumber)
            return makeURL(endpoint: "/api/v6/user", queryItems: [queryItem])
        case .checkAccount(let phoneNumber):
            let queryItem = URLQueryItem(name: PhoneNumberQueryKey, value: phoneNumber)
            return makeURL(endpoint: "/api/v6/account", queryItems: [queryItem])
        case .user:
            return makeURL(endpoint: "/api/v6/user")
        case .getUserToken(let user):
            let userId = user.userID
            return makeURL(endpoint: "/api/v6/user/\(userId)")
        case .account:
            return makeURL(endpoint: "/api/v6/account")
        case .getUserTransactions(let phoneNumber):
            let queryItem = URLQueryItem(name: SearchQueryKey, value: phoneNumber)
            return makeURL(endpoint: "/api/v6/transaction", queryItems: [queryItem])
        }
    }
}

// MARK: - Helpers

private extension APIEndpoint {
    
    var PhoneNumberQueryKey: String {
        "phoneNumber"
    }
    
    var SearchQueryKey: String {
        "search"
    }

    var BaseURL: String {
        "https://608886b3a6f4a3001742691d.mockapi.io"
    }

    func makeURL(endpoint: String, queryItems: [URLQueryItem]? = nil) -> URL? {
        let urlString = BaseURL + endpoint
        
        guard let queryItems = queryItems else {
            return URL(string: urlString)
        }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "608886b3a6f4a3001742691d.mockapi.io"
        urlComponents.path = endpoint
        urlComponents.queryItems = queryItems
        
        return urlComponents.url
    }
}
