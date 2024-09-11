//
//  Liability+CoreDataProperties.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 14.07.24.
//
//


import CoreData


extension Liability {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Liability> {
        return NSFetchRequest<Liability>(entityName: "Liability")
    }

    @NSManaged public var creditor: String
    @NSManaged public var grantDate: Date
    @NSManaged public var initialAmount: Double
    @NSManaged public var name: String
    @NSManaged public var repaidAmount: Double
    @NSManaged public var pool: LiabilityPool?

}

extension Liability : Identifiable {

}
