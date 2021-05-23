//
//  Account+CoreDataProperties.swift
//  
//
//  Created by Lukas Adomavicius on 5/21/21.
//
//

import Foundation
import CoreData


extension Account {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged public var balance: NSDecimalNumber?
    @NSManaged public var currency: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var id: Int64
    @NSManaged public var transactions: NSSet?

}

// MARK: Generated accessors for transactions
extension Account {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: Transaction)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: Transaction)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}
