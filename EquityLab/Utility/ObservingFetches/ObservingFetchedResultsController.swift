//
//  ObservingFetchedResultsController.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 14.07.24.
//

import Foundation
import CoreData

public class ObservingFetchedResultsController<ResultType: NSFetchRequestResult>: NSFetchedResultsController<NSFetchRequestResult> {
    
    private var relationshipObserver: RelationshipObserver<ResultType>?
    
    public init(fetchRequest: ObservingFetchRequest<ResultType>, managedObjectContext context: NSManagedObjectContext, sectionNameKeyPath: String?, cacheName name: String?) {
        super.init(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: sectionNameKeyPath, cacheName: name)
        let managedObjectModel = managedObjectContext.persistentStoreCoordinator!.managedObjectModel
        let entityDescription = managedObjectModel.entitiesByName[String(describing: ResultType.self)]!
        let relationshipNames = entityDescription.relationshipsByName.keys
        let existingRelations = fetchRequest.observedRelationships.filter{ relationshipNames.contains($0)}
        relationshipObserver = RelationshipObserver<ResultType>(for: existingRelations, controller: self)
    }
}
