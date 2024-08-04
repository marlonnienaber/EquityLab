//
//  Receivable+CoreDataProperties.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 14.07.24.
//
//

import Foundation
import CoreData


extension Receivable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Receivable> {
        return NSFetchRequest<Receivable>(entityName: "Receivable")
    }

    @NSManaged public var debtor: String
    @NSManaged public var grantDate: Date
    @NSManaged public var initialAmount: Double
    @NSManaged public var repaidAmount: Double

}
