//
//  UserManager.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/9/21.
//

import Foundation

struct UserManager {
    
    private enum UserManagerKey {
        static let userId: String = "current user id"
        static let tokenExpiration: String = "current token expiration"
    }
    
    private let userDefaults = UserDefaults.standard
    private let keyChain = KeychainSwift()

    func getUserId() -> Int? {
        return userDefaults.object(forKey: UserManagerKey.userId) as? Int
    }
    
    func saveUserId(id: Int) {
        userDefaults.setValue(id, forKey: UserManagerKey.userId)
    }
    
    func getTokenExpiration() -> Int? {
        return userDefaults.object(forKey: UserManagerKey.tokenExpiration) as? Int
    }
    
    func saveTokenExpiration(_ expiration: Int) {
        userDefaults.setValue(expiration, forKey: UserManagerKey.tokenExpiration)
    }
    
    func saveToken(_ token: String, userId: Int) {
        keyChain.set(token, forKey: String(userId))
    }
    
    func getToken(userId: Int) -> String? {
        keyChain.get(String(userId))
    }
    
    func isUserLoggedIn() -> Bool {
        guard let userId = getUserId(),
              let _ = getToken(userId: userId),
              let expirationTimestamp = getTokenExpiration() else {
            return false
        }
        
        let currentTimestamp = Date().timeIntervalSince1970
                
        return expirationTimestamp > Int(currentTimestamp)
    }
}
