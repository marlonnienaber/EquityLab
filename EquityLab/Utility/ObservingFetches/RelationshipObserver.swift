//
//  RelationshipObserver.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 14.07.24.
//

import Foundation
import CoreData

public class RelationshipObserver<ResultType: NSFetchRequestResult> {
    
    private unowned let fetchedResultsController: ObservingFetchedResultsController<ResultType>
    private var relations: Set<String>
    private var updatedObjectIDs: Set<NSManagedObjectID>
    
    init(for relations: Set<String>, controller: ObservingFetchedResultsController<ResultType>) {
        self.fetchedResultsController = controller
        self.relations = relations
        self.updatedObjectIDs = []
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidChangeNotification(notification:)), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: controller.managedObjectContext)
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidSaveNotification(notification:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: controller.managedObjectContext)
    }
    
    @objc private func contextDidChangeNotification(notification: NSNotification) {
        guard let updatedObjects = notification.userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject> else { return }
        for updatedObject in updatedObjects {
            for relationship in updatedObject.entity.relationshipsByName.values {
                guard let destinationEntity = relationship.destinationEntity else { continue }
                if let destinationObject = updatedObject.value(forKey: relationship.name) as? NSManagedObject, destinationObject is ResultType {
                    updatedObjectIDs.insert(destinationObject.objectID)
                    break
                }
            }
        }
    }
    
    @objc private func contextDidSaveNotification(notification: NSNotification) {
        guard !updatedObjectIDs.isEmpty else { return }
        guard let fetchedObjects = fetchedResultsController.fetchedObjects as? [NSManagedObject], !fetchedObjects.isEmpty else { return }
        fetchedObjects.forEach { object in
            guard updatedObjectIDs.contains(object.objectID) else { return }
            fetchedResultsController.managedObjectContext.refresh(object, mergeChanges: true)
        }
        updatedObjectIDs.removeAll()
    }
}
