//
//  AccountManager.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/10/21.
//

import Foundation

class AccountManager {
    
    let apiManager = APIManager()

    enum AccountManagerError: Error {
        case missingValues
        case accountAlreadyExists
        case wrongPassword
        case accountNotFound

        var errorDescription: String {
            switch self {
            case .missingValues:
                return "Missing required values!"
            case .accountAlreadyExists:
                return "This phoneNumber is already taken!"
            case .wrongPassword:
                return "Password is incorrect!"
            case .accountNotFound:
                return "Account with this username is not found!"
            }
        }
    }

    static var loggedInAccount: Account? /*{
        willSet(newAccount) {
            print("Will set account. Old username: \(loggedInAccount?.username ?? "nil"), new username: \(newAccount?.username ?? "nil")")
        } didSet {
            print("Did set account. Old username: \(oldValue?.username ?? "nil"), new username: \(loggedInAccount?.username ?? "nil")")
        }
    }*/
}
    // MARK: - Main functionality

extension AccountManager {
    
    func checkIfPasswordIsCorrect(password: String, user: UserResponse) -> Bool {
        password == user.password
    }
}

// MARK: - Helpers

private extension AccountManager {
    
    static func isUsernameTaken(_ username: String) -> Bool {
        return false
    }
}


