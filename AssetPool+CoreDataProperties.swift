//
//  AssetPool+CoreDataProperties.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 14.07.24.
//
//

import Foundation
import CoreData


extension AssetPool {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AssetPool> {
        return NSFetchRequest<AssetPool>(entityName: "AssetPool")
    }

    @NSManaged public var name: String
    @NSManaged public var assets: NSSet?

}

// MARK: Generated accessors for assets
extension AssetPool {

    @objc(addAssetsObject:)
    @NSManaged public func addToAssets(_ value: Asset)

    @objc(removeAssetsObject:)
    @NSManaged public func removeFromAssets(_ value: Asset)

    @objc(addAssets:)
    @NSManaged public func addToAssets(_ values: NSSet)

    @objc(removeAssets:)
    @NSManaged public func removeFromAssets(_ values: NSSet)

}

extension AssetPool : Identifiable {

}
