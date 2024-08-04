//
//  Snapshot+CoreDataProperties.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 15.07.24.
//
//

import Foundation
import CoreData


extension Snapshot {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Snapshot> {
        return NSFetchRequest<Snapshot>(entityName: "Snapshot")
    }

    @NSManaged public var date: Date
    @NSManaged public var assets: NSSet?
    @NSManaged public var liabilities: NSSet?

}

// MARK: Generated accessors for assets
extension Snapshot {

    @objc(addAssetsObject:)
    @NSManaged public func addToAssets(_ value: AssetPosition)

    @objc(removeAssetsObject:)
    @NSManaged public func removeFromAssets(_ value: AssetPosition)

    @objc(addAssets:)
    @NSManaged public func addToAssets(_ values: NSSet)

    @objc(removeAssets:)
    @NSManaged public func removeFromAssets(_ values: NSSet)

}

// MARK: Generated accessors for liabilities
extension Snapshot {

    @objc(addLiabilitiesObject:)
    @NSManaged public func addToLiabilities(_ value: LiabilityPosition)

    @objc(removeLiabilitiesObject:)
    @NSManaged public func removeFromLiabilities(_ value: LiabilityPosition)

    @objc(addLiabilities:)
    @NSManaged public func addToLiabilities(_ values: NSSet)

    @objc(removeLiabilities:)
    @NSManaged public func removeFromLiabilities(_ values: NSSet)

}

extension Snapshot : Identifiable {

}
