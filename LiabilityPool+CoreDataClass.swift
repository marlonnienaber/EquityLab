//
//  LiabilityPool+CoreDataClass.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 14.07.24.
//
//

import Foundation
import CoreData

@objc(LiabilityPool)
public class LiabilityPool: NSManagedObject {
    
    func getLiabilityRequest() -> NSFetchRequest<Liability> {
        let request = Liability.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Liability.grantDate, ascending: true)]
        request.predicate = NSPredicate(format: "pool = %@", self)
        return request
    }

}
