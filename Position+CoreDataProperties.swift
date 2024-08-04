//
//  Position+CoreDataProperties.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 14.07.24.
//
//

import Foundation
import CoreData


extension Position {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Position> {
        return NSFetchRequest<Position>(entityName: "Position")
    }

    @NSManaged public var name: String
    @NSManaged public var poolName: String
    @NSManaged public var value: Double

}

extension Position : Identifiable {

}
