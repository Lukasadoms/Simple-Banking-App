//
//  APIManager.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/9/21.
//

import Foundation

struct APIManager {
    
    enum APIHTTPMethod {
        static let get = "GET"
        static let post = "POST"
        static let delete = "DELETE"
        static let put = "PUT"
    }
    
    private var session: URLSession {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration)
    }
    
    func checkIfUserExists(phoneNumber: String, _ completion: @escaping (Result<UserResponse, APIError>) -> Void) {

        guard let url = APIEndpoint.checkUser(phoneNumber: phoneNumber).url
        
        else {
            completion(.failure(.failedURLCreation))
            return
        }

        session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(.failedRequest))
                return
            }

            guard let userResponse = try? JSONDecoder().decode([UserResponse].self, from: data) else {
                completion(.failure(.failedResponse))
                return
            }
            if let user = userResponse.first {
                completion(.success(user))
                return
            } else {
                completion(.failure(.userDoesntExist))
                return
            }
        }.resume()
    }
    
    func createUser(phoneNumber: String, password: String, _ completion: @escaping (Result<UserResponse, APIError>) -> Void) {

        guard let url = APIEndpoint.user.url
        else {
            completion(.failure(.failedURLCreation))
            return
        }
        
        let registerUser = UserResponse(
            userID: "",
            phoneNumber: phoneNumber,
            password: password
        )

        guard let requestJSON = try? JSONEncoder().encode(registerUser) else {
            completion(.failure(.unexpectedDataFormat))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = APIHTTPMethod.post
        request.httpBody = requestJSON
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(.failure(.failedRequest))
                return
            }
            guard let userResponse = try? JSONDecoder().decode(UserResponse.self, from: data) else {
                completion(.failure(.failedResponse))
                return
            }
            completion(.success(userResponse))
        }.resume()
    }
    
    func getUserToken(user: UserResponse, _ completion: @escaping (Result<UserTokenResponse, APIError>) -> Void) {

        guard let url = APIEndpoint.getUserToken(user: user).url
        
        else {
            completion(.failure(.failedURLCreation))
            return
        }

        session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(.failedRequest))
                return
            }

            guard let userTokenResponse = try? JSONDecoder().decode(UserTokenResponse.self, from: data) else {
                completion(.failure(.failedResponse))
                return
            }
            completion(.success(userTokenResponse))
        }.resume()
    }
    
    func createAccount(phoneNumber: String, currency: String, _ completion: @escaping (Result<AccountResponse, APIError>) -> Void) {

        guard let url = APIEndpoint.account.url
        else {
            completion(.failure(.failedURLCreation))
            return
        }
        
        let registerUser = AccountResponse(
            id: "",
            phoneNumber: phoneNumber,
            currency: currency,
            balance: 0
        )

        guard let requestJSON = try? JSONEncoder().encode(registerUser) else {
            completion(.failure(.unexpectedDataFormat))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = APIHTTPMethod.post
        request.httpBody = requestJSON
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(.failure(.failedRequest))
                return
            }
            guard let userResponse = try? JSONDecoder().decode(AccountResponse.self, from: data) else {
                completion(.failure(.failedResponse))
                return
            }
            completion(.success(userResponse))
        }.resume()
    }
    
    func checkIfAccountExists(phoneNumber: String, _ completion: @escaping (Result<AccountResponse, APIError>) -> Void) {

        guard let url = APIEndpoint.checkAccount(phoneNumber: phoneNumber).url
        
        else {
            completion(.failure(.failedURLCreation))
            return
        }

        session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(.failedRequest))
                return
            }

            guard let userResponse = try? JSONDecoder().decode([AccountResponse].self, from: data) else {
                completion(.failure(.failedResponse))
                return
            }
            if let user = userResponse.first {
                completion(.success(user))
                return
            } else {
                completion(.failure(.userDoesntExist))
                return
            }
        }.resume()
    }
    
    func getAccountTransactions(phoneNumber: String, _ completion: @escaping (Result<[TransactionResponse], APIError>) -> Void) {

        guard let url = APIEndpoint.getUserTransactions(phoneNumber: phoneNumber).url
        
        else {
            completion(.failure(.failedURLCreation))
            return
        }

        session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(.failedRequest))
                return
            }

            guard let transactionResponse = try? JSONDecoder().decode([TransactionResponse].self, from: data) else {
                completion(.failure(.failedResponse))
                return
            }
            completion(.success(transactionResponse))
        }.resume()
    }
    
    func postTransaction(senderAccount: AccountResponse,
                         receiverAccount: AccountResponse,
                         amount: Double, currency: String,
                         reference: String,
                         _ completion: @escaping (Result<TransactionResponse, APIError>) -> Void)
    {
        let createdOn = Int(Date().timeIntervalSince1970)
        guard let url = APIEndpoint.transaction.url
        else {
            completion(.failure(.failedURLCreation))
            return
        }
        
        let updatingUser = TransactionResponse(id: "",
                                               senderId: senderAccount.id,
                                               receiverId: receiverAccount.id,
                                               amount: amount,
                                               currency: currency,
                                               createdOn: createdOn,
                                               reference: reference
        )

        guard let requestJSON = try? JSONEncoder().encode(updatingUser) else {
            completion(.failure(.unexpectedDataFormat))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = APIHTTPMethod.post
        request.httpBody = requestJSON
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(.failure(.failedRequest))
                return
            }
            guard let userResponse = try? JSONDecoder().decode(TransactionResponse.self, from: data) else {
                completion(.failure(.failedResponse))
                return
            }
            completion(.success(userResponse))
        }.resume()
    }
    
    func updateAccount(account: AccountResponse, currency: String?, phoneNumber: String?, amount: Double?, _ completion: @escaping (Result<AccountResponse, APIError>) -> Void) {

        guard let url = APIEndpoint.accountWithId(account: account).url
        else {
            completion(.failure(.failedURLCreation))
            return
        }
        
        var updatingUser = AccountResponse(
            id: account.id,
            phoneNumber: account.phoneNumber,
            currency: account.currency,
            balance: account.balance
        )
        if let currency = currency {
            updatingUser.currency = currency
        }
        
        if let phoneNumber = phoneNumber {
            updatingUser.phoneNumber = phoneNumber
        }
        
        if let amount = amount {
            updatingUser.balance += amount
        }

        guard let requestJSON = try? JSONEncoder().encode(updatingUser) else {
            completion(.failure(.unexpectedDataFormat))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = APIHTTPMethod.put
        request.httpBody = requestJSON
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(.failure(.failedRequest))
                return
            }
            guard let accountResponse = try? JSONDecoder().decode(AccountResponse.self, from: data) else {
                completion(.failure(.failedResponse))
                return
            }
            completion(.success(accountResponse))
        }.resume()
    }
}
