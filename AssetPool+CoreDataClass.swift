//
//  AssetPool+CoreDataClass.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 14.07.24.
//
//

import Foundation
import CoreData

@objc(AssetPool)
public class AssetPool: NSManagedObject {

    func getAssetRequest() -> NSFetchRequest<Asset> {
        let request = Asset.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Asset.name, ascending: true)]
        request.predicate = NSPredicate(format: "pool = %@", self)
        return request
    }

}
