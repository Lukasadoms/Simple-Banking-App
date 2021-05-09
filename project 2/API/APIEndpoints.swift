//
//  APIEndpoints.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/9/21.
//

import Foundation

enum APIEndpoint {
    case user(phoneNumber: String)
//    case transactions
//    case accounts


    var url: URL? {
        switch self {
        case .user(let phoneNumber):
            let queryItem = URLQueryItem(name: PhoneNumberQueryKey, value: phoneNumber)
            return makeURL(endpoint: "/api/v6/user", queryItems: [queryItem])
//        case .transactions:
//            let queryItem = URLQueryItem(name: CategoryNameQueryKey, value: SeriesName)
//            return makeURL(endpoint: "/api/characters", queryItems: [queryItem])
//        case .characterInfo(let name):
//            let queryItem = URLQueryItem(name: CharacterNameQueryKey, value: name)
//            return makeURL(endpoint: "/api/characters", queryItems: [queryItem])
//        case .characterQuotes(let name):
//            let queryItem = URLQueryItem(name: AuthorNameQueryKey, value: name)
//            return makeURL(endpoint: "/api/quote", queryItems: [queryItem])
//        case .randomQuote:
//            return makeURL(endpoint: "/api/quote/random")
        }
    }
}

// MARK: - Helpers

private extension APIEndpoint {
    
    var PhoneNumberQueryKey: String {
        "phoneNumber"
    }

    var BaseURL: String {
        "https://608886b3a6f4a3001742691d.mockapi.io/api/v6/"
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
