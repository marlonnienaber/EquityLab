//
//  Snapshot+CoreDataClass.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 15.07.24.
//
//

import Foundation
import CoreData

@objc(Snapshot)
public class Snapshot: NSManagedObject {
    
    func getAssetPositionRequest() -> NSFetchRequest<AssetPosition> {
        let request = NSFetchRequest<AssetPosition>(entityName: "AssetPosition")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \AssetPosition.name, ascending: true)]
        request.predicate = NSPredicate(format: "snapshot = %@", self)
        return request
    }

    func getLiabilityPositionRequest() -> NSFetchRequest<LiabilityPosition> {
        let request = NSFetchRequest<LiabilityPosition>(entityName: "LiabilityPosition")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \LiabilityPosition.name, ascending: true)]
        request.predicate = NSPredicate(format: "snapshot = %@", self)
        return request
    }

}
