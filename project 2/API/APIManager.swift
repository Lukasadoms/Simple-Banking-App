//
//  APIManager.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/9/21.
//

import Foundation

struct APIManager {
    
    private var session: URLSession {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration)
    }
    
    // MARK: - Get All Episodes
    
    func checkIfUserExists(phoneNumber: String, _ completion: @escaping (Result<[UserResponse], APIError>) -> Void) {

        guard let url = APIEndpoint.user(phoneNumber: phoneNumber).url
        else {
            completion(.failure(.failedURLCreation))
            return
        }

        session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(.failedRequest))
                return
            }

            guard let episodesResponse = try? JSONDecoder().decode([UserResponse].self, from: data) else {
                completion(.failure(.userDoesntExist))
                return
            }
            completion(.success(episodesResponse))
        }.resume()
    }
}
