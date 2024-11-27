import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String
    @NSManaged public var liabilities: NSSet?
    @NSManaged public var receivables: NSSet?
    @NSManaged public var transactions: NSSet?
    @NSManaged public var shares: NSSet?

}

// MARK: Generated accessors for liabilities
extension Person {

    @objc(addLiabilitiesObject:)
    @NSManaged public func addToLiabilities(_ value: Receivable)

    @objc(removeLiabilitiesObject:)
    @NSManaged public func removeFromLiabilities(_ value: Receivable)

    @objc(addLiabilities:)
    @NSManaged public func addToLiabilities(_ values: NSSet)

    @objc(removeLiabilities:)
    @NSManaged public func removeFromLiabilities(_ values: NSSet)

}

// MARK: Generated accessors for receivables
extension Person {

    @objc(addReceivablesObject:)
    @NSManaged public func addToReceivables(_ value: Liability)

    @objc(removeReceivablesObject:)
    @NSManaged public func removeFromReceivables(_ value: Liability)

    @objc(addReceivables:)
    @NSManaged public func addToReceivables(_ values: NSSet)

    @objc(removeReceivables:)
    @NSManaged public func removeFromReceivables(_ values: NSSet)

}

// MARK: Generated accessors for transactions
extension Person {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: Transaction)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: Transaction)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}

// MARK: Generated accessors for shares
extension Person {

    @objc(addSharesObject:)
    @NSManaged public func addToShares(_ value: Share)

    @objc(removeSharesObject:)
    @NSManaged public func removeFromShares(_ value: Share)

    @objc(addShares:)
    @NSManaged public func addToShares(_ values: NSSet)

    @objc(removeShares:)
    @NSManaged public func removeFromShares(_ values: NSSet)

}

extension Person : Identifiable {

}
