import Foundation
import CoreData


extension Liability {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Liability> {
        return NSFetchRequest<Liability>(entityName: "Liability")
    }

    @NSManaged public var name: String
    @NSManaged public var creditor: Person?
    @NSManaged public var pool: LiabilityPool?
    @NSManaged public var transactions: NSSet?

}

// MARK: Generated accessors for transactions
extension Liability {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: Transaction)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: Transaction)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}

extension Liability : Identifiable {

}
