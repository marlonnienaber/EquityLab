//
//  DataService.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 14.07.24.
//

import UIKit
import CoreData

class ProductionCoreDataStack: NSObject {
    static let shared = ProductionCoreDataStack()
    private let persistentContainer: NSPersistentContainer
    let context: NSManagedObjectContext
    
    private override init() {
        persistentContainer = NSPersistentContainer(name: "CoreDataModel")
        persistentContainer.loadPersistentStores{ (_, error) in
            if let error = error {
                fatalError("failed to load persistentStores of persistentContainer. Error: \(error)")
            }
        }
        context = persistentContainer.viewContext
    }
}
