//
//  AccountManager.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/10/21.
//

import Foundation

class AccountManager {

    enum AccountManagerError: Error {
        case missingValues
        case accountAlreadyExists
        case wrongPassword
        case accountNotFound

        var errorDescription: String {
            switch self {
            case .missingValues:
                return "Please make sure phone number is correct and password has at least one uppercase letter and one special symbol"
            case .accountAlreadyExists:
                return "This phoneNumber is already taken!"
            case .wrongPassword:
                return "Password is incorrect!"
            case .accountNotFound:
                return "Account with this username is not found!"
            }
        }
    }
    
    var currentAccount: AccountResponse?
}
    // MARK: - Main functionality

extension AccountManager {
    
    func checkIfPasswordIsCorrect(password: String, user: UserResponse) -> Bool {
        password == user.password
    }
    
    func validatePhoneNumberAndPassword(phoneNumber: String, password: String) -> Bool {
        let phoneRegex = "^[0-9]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        let passwordRegex = "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@ ", passwordRegex)
        guard
            phoneTest.evaluate(with: phoneNumber),
            passwordTest.evaluate(with: password)
        else { return false }
        
        return true
    }
    
    func updateAccountInfo(account: AccountResponse, apiManager: APIManager, transcationManager: TransactionManager) throws {
        
//        apiManager.checkIfAccountExists(phoneNumber: account.phoneNumber, { [weak self] result in
//            switch result {
//            case .failure(let error):
//                throw error
//            case .success(let account):
//                DispatchQueue.main.async {
//                    self?.accountManager.currentAccount = account
//                }
//            }
//        })
//        apiManager.getAccountTransactions(phoneNumber: account.phoneNumber, { [weak self] result in throws
//            switch result {
//            case .failure(let error):
//                    throw error
//            case .success(let transactions):
//                try self?.transactionManager.saveTransactionsToDataBase(transactions: transactions)
//            }
//        })
    }
}


