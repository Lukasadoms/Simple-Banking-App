//
//  UserManager.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/9/21.
//

import Foundation

struct UserManager {
    
    private enum UserManagerKey {
        static let phoneNumber: String = "current user phoneNumber"
        static let tokenExpiration: String = "current token expiration"
    }
    
    private let userDefaults = UserDefaults.standard
    private let keyChain = KeychainSwift()

    func getUserphoneNumber() -> String? {
        return userDefaults.object(forKey: UserManagerKey.phoneNumber) as? String
    }
    
    func saveUserPhoneNumber(phoneNumber: String) {
        userDefaults.setValue(phoneNumber, forKey: UserManagerKey.phoneNumber)
    }
    
    func getTokenExpiration() -> Int? {
        return userDefaults.object(forKey: UserManagerKey.tokenExpiration) as? Int
    }
    
    func saveTokenExpiration(_ expiration: Int) {
        userDefaults.setValue(expiration, forKey: UserManagerKey.tokenExpiration)
    }
    
    func saveToken(_ token: String, phoneNumber: String) {
        keyChain.set(token, forKey: phoneNumber)
    }
    
    func getToken(phoneNumber: String) -> String? {
        keyChain.get(phoneNumber)
    }
    
    func isUserLoggedIn() -> Bool {
        guard let phoneNumber = getUserphoneNumber(),
              let _ = getToken(phoneNumber: phoneNumber),
              let expirationTimestamp = getTokenExpiration() else {
            return false
        }
        
        let currentTimestamp = Date().timeIntervalSince1970
                
        return expirationTimestamp > Int(currentTimestamp)
    }
}
