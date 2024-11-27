import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var amount: NSDecimalNumber
    @NSManaged public var date: Date
    @NSManaged public var note: String
    @NSManaged public var emoji: String
    @NSManaged public var issuer: Person?
    @NSManaged public var liability: Liability?
    @NSManaged public var receivable: Receivable?
    @NSManaged public var shares: NSSet?

}

// MARK: Generated accessors for shares
extension Transaction {

    @objc(addSharesObject:)
    @NSManaged public func addToShares(_ value: Share)

    @objc(removeSharesObject:)
    @NSManaged public func removeFromShares(_ value: Share)

    @objc(addShares:)
    @NSManaged public func addToShares(_ values: NSSet)

    @objc(removeShares:)
    @NSManaged public func removeFromShares(_ values: NSSet)

}

extension Transaction : Identifiable {

}
