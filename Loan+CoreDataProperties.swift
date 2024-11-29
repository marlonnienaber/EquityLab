import Foundation
import CoreData


extension Loan {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Loan> {
        return NSFetchRequest<Loan>(entityName: "Loan")
    }

    @NSManaged public var name: String
    @NSManaged public var partner: LoanPartner?
    @NSManaged public var liabilityPool: LiabilityPool?
    @NSManaged public var transactions: NSSet?
    @NSManaged public var assetPool: AssetPool?

}

// MARK: Generated accessors for transactions
extension Loan {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: LoanTransaction)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: LoanTransaction)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}

extension Loan : Identifiable {

}
