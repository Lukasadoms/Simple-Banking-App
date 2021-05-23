//
//  TransactionManager.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/21/21.
//

import Foundation

struct TransactionManager {
    
    let apiManager = APIManager()
    let accountManager = AccountManager()
    
    func saveTransactionsToDataBase(transactions: [TransactionResponse]) throws {
        try CoreDataManager.deleteTransactions()
        for transaction in transactions {
            let newTransaction = Transaction(context: CoreDataManager.managedContext)
            newTransaction.amount = NSDecimalNumber(decimal: transaction.amount)
            newTransaction.createdOn = Int64(transaction.createdOn)
            newTransaction.currency = transaction.currency
            newTransaction.receiverId = transaction.receiverId
            newTransaction.senderId = transaction.senderId
            newTransaction.reference = transaction.reference
            if transaction.senderId == transaction.receiverId {
                var phoneNumberArray: [String] = []
                phoneNumberArray.append(transaction.senderId)
                try addAccountReferenceToTransaction(accountsPhoneNumbers: phoneNumberArray, transaction: newTransaction)
            }
            else {
                let accountsPhoneNumbers = [transaction.senderId, transaction.receiverId]
                try addAccountReferenceToTransaction(accountsPhoneNumbers: accountsPhoneNumbers, transaction: newTransaction)
            }
        }
        try CoreDataManager.saveContext()
    }
    
    func addAccountReferenceToTransaction(accountsPhoneNumbers: [String], transaction: Transaction) throws {
        for accountPhoneNumber in accountsPhoneNumbers{
            if let account = accountManager.getAccountFromDatabase(accountPhoneNumber: accountPhoneNumber) {
                transaction.addToAccount(account)
            }
            else {
                var newAccount: AccountResponse?
                apiManager.checkIfAccountExists(phoneNumber: accountPhoneNumber, { result in
                    switch result {
                    case .success(let account):
                        newAccount = account
                    case .failure(let error):
                        print(error)
                    }
                })
                guard let newAccount = newAccount else { return }
                try accountManager.saveAccountToDatabase(account: newAccount)
                if let account = accountManager.getAccountFromDatabase(accountPhoneNumber: newAccount.phoneNumber) {
                    transaction.addToAccount(account)
                }
            }
        }
        try CoreDataManager.saveContext()
    }
    
    func getTransactionsFromDataBase() -> [Transaction]?  {
        do {
            return try CoreDataManager.managedContext.fetch(Transaction.fetchRequest())
        }
        catch {
            return nil
        }
    }
    
}
