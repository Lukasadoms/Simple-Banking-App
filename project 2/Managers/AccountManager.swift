//
//  AccountManager.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/10/21.
//

import Foundation
import CoreData

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
    
    func saveAccountToDatabase(account: AccountResponse) throws {
        let newAccount = Account(context: CoreDataManager.managedContext)
        newAccount.balance = NSDecimalNumber(decimal: account.balance)
        newAccount.currency = account.currency
        newAccount.id = Int64(account.id)!
        newAccount.phoneNumber = account.phoneNumber
        do {
            try CoreDataManager.saveContext()
        }
        catch {
            throw error
        }
    }
    
    func getAccountFromDatabase (accountPhoneNumber: String) -> Account? {
        
        do {
            let fetchRequest : NSFetchRequest<Account> = Account.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "phoneNumber == %@", accountPhoneNumber)
            let fetchedResults = try CoreDataManager.managedContext.fetch(fetchRequest)
            if let account = fetchedResults.first {
                return account
            }
        }
        catch {
            return nil
        }
        return nil
    }
    
    func getTransactionsFromDataBase() -> [Transaction]? {
        do {
            return try CoreDataManager.managedContext.fetch(Transaction.fetchRequest())
        }
        catch {
            return nil
        }
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


