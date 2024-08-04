//
//  DataService.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 14.07.24.
//

import UIKit
import CoreData

class DataService: NSObject {
    static let shared = DataService()
    let persistentContainer: NSPersistentContainer
    
    private override init() {
        persistentContainer = NSPersistentContainer(name: "CoreDataModel")
        persistentContainer.loadPersistentStores{ (_, error) in
            if let error = error {
                fatalError("failed to load persistentStores of persistentContainer. Error: \(error)")
            }
        }
    }
}
