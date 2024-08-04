//
//  AssetPosition+CoreDataProperties.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 15.07.24.
//
//

import Foundation
import CoreData


extension AssetPosition {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AssetPosition> {
        return NSFetchRequest<AssetPosition>(entityName: "AssetPosition")
    }

    @NSManaged public var snapshot: Snapshot?

}
