import Foundation
import CoreData


extension AssetPool {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AssetPool> {
        return NSFetchRequest<AssetPool>(entityName: "AssetPool")
    }

    @NSManaged public var name: String
    @NSManaged public var possessions: NSSet?
    @NSManaged public var receivables: NSSet?

}

// MARK: Generated accessors for possessions
extension AssetPool {

    @objc(addPossessionsObject:)
    @NSManaged public func addToPossessions(_ value: Possession)

    @objc(removePossessionsObject:)
    @NSManaged public func removeFromPossessions(_ value: Possession)

    @objc(addPossessions:)
    @NSManaged public func addToPossessions(_ values: NSSet)

    @objc(removePossessions:)
    @NSManaged public func removeFromPossessions(_ values: NSSet)

}

// MARK: Generated accessors for receivables
extension AssetPool {

    @objc(addReceivablesObject:)
    @NSManaged public func addToReceivables(_ value: Receivable)

    @objc(removeReceivablesObject:)
    @NSManaged public func removeFromReceivables(_ value: Receivable)

    @objc(addReceivables:)
    @NSManaged public func addToReceivables(_ values: NSSet)

    @objc(removeReceivables:)
    @NSManaged public func removeFromReceivables(_ values: NSSet)

}

extension AssetPool : Identifiable {

}
