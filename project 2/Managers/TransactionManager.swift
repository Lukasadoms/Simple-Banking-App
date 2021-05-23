//
//  TransactionManager.swift
//  project 2
//
//  Created by Lukas Adomavicius on 5/21/21.
//

import Foundation

struct TransactionManager {
    
    func saveTransactionsToDataBase(transactions: [TransactionResponse]) throws {
        try CoreDataManager.deleteTransactions()
        for transaction in transactions {
            let newTransaction = Transaction(context: CoreDataManager.managedContext)
            newTransaction.amount = NSDecimalNumber(decimal: transaction.amount)
            newTransaction.createdOn = Int64(transaction.createdOn)
            //newTransaction.account = currentAccount
            newTransaction.currency = transaction.currency
            newTransaction.receiverId = transaction.receiverId
            newTransaction.senderId = transaction.senderId
            newTransaction.reference = transaction.reference
            try CoreDataManager.saveContext()
        }
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
