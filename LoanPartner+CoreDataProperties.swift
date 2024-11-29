import Foundation
import CoreData


extension LoanPartner {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LoanPartner> {
        return NSFetchRequest<LoanPartner>(entityName: "LoanPartner")
    }

    @NSManaged public var name: String
    @NSManaged public var liabilities: NSSet?
    @NSManaged public var receivables: NSSet?
    @NSManaged public var transactions: NSSet?

}

// MARK: Generated accessors for liabilities
extension LoanPartner {

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
extension LoanPartner {

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
extension LoanPartner {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: LoanTransaction)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: LoanTransaction)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}

extension LoanPartner : Identifiable {

}
