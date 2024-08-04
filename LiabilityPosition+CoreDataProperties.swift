//
//  LiabilityPosition+CoreDataProperties.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 15.07.24.
//
//

import Foundation
import CoreData


extension LiabilityPosition {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LiabilityPosition> {
        return NSFetchRequest<LiabilityPosition>(entityName: "LiabilityPosition")
    }

    @NSManaged public var snapshot: Snapshot?

}
