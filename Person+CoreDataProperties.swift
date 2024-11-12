import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String
    @NSManaged public var liabilities: NSSet?
    @NSManaged public var receivables: NSSet?

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

extension Person : Identifiable {

}
