//
//  Possession+CoreDataProperties.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 14.07.24.
//
//

import Foundation
import CoreData


extension Possession {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Possession> {
        return NSFetchRequest<Possession>(entityName: "Possession")
    }

    @NSManaged public var volatile: Bool

}
