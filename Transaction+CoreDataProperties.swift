//
//  Transaction+CoreDataProperties.swift
//  
//
//  Created by Lukas Adomavicius on 5/21/21.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var amount: NSDecimalNumber
    @NSManaged public var createdOn: Int64
    @NSManaged public var receiverId: String
    @NSManaged public var senderId: String
    @NSManaged public var id: Int64
    @NSManaged public var currency: String
    @NSManaged public var account: NSSet

}

// MARK: Generated accessors for account
extension Transaction {

    @objc(addAccountObject:)
    @NSManaged public func addToAccount(_ value: Account)

    @objc(removeAccountObject:)
    @NSManaged public func removeFromAccount(_ value: Account)

    @objc(addAccount:)
    @NSManaged public func addToAccount(_ values: NSSet)

    @objc(removeAccount:)
    @NSManaged public func removeFromAccount(_ values: NSSet)

}
