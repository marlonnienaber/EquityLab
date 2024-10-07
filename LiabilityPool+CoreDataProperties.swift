import CoreData

extension LiabilityPool {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LiabilityPool> {
        return NSFetchRequest<LiabilityPool>(entityName: "LiabilityPool")
    }

    @NSManaged public var name: String
    @NSManaged public var liabilities: NSSet?

}

// MARK: Generated accessors for liabilities
extension LiabilityPool {

    @objc(addLiabilitiesObject:)
    @NSManaged public func addToLiabilities(_ value: Liability)

    @objc(removeLiabilitiesObject:)
    @NSManaged public func removeFromLiabilities(_ value: Liability)

    @objc(addLiabilities:)
    @NSManaged public func addToLiabilities(_ values: NSSet)

    @objc(removeLiabilities:)
    @NSManaged public func removeFromLiabilities(_ values: NSSet)

}

extension LiabilityPool : Identifiable {

}
