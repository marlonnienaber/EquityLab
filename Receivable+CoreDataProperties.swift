import Foundation
import CoreData


extension Receivable {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Receivable> {
        return NSFetchRequest<Receivable>(entityName: "Receivable")
    }

    @NSManaged public var name: String
    @NSManaged public var debtor: Person?
    @NSManaged public var pool: AssetPool?
    @NSManaged public var transactions: NSSet?

}

// MARK: Generated accessors for transactions
extension Receivable {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: Transaction)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: Transaction)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}

extension Receivable : Identifiable {

}
