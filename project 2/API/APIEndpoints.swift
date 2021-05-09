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
            return makeURL(endpoint: "users", queryItems: [queryItem])
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
    
    var CategoryNameQueryKey: String {
        "category"
    }

    var AuthorNameQueryKey: String {
        "author"
    }
    
    var CharacterNameQueryKey: String {
        "name"
    }
    
    var SeriesName: String {
        "Breaking+Bad"
    }

    var BaseURL: String {
        "https://608886b3a6f4a3001742691d.mockapi.io/api/v6/"
    }

    func makeURL(endpoint: String, queryItems: [URLQueryItem]? = nil) -> URL? {
        let urlString = BaseURL + endpoint

        guard let queryItems = queryItems else {
            return URL(string: urlString)
        }

        var components = URLComponents(string: urlString)
        components?.queryItems = queryItems
        return components?.url
    }
}
