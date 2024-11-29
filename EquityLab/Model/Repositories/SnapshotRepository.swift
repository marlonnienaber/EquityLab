import CoreData
import ObservableProperties

class SnapshotRepository: NSObject {
    public static let production = SnapshotRepository(context: ProductionCoreDataStack.shared.context)
    private let snapshotFetchedResultsController: NSFetchedResultsController<Snapshot>
    private let assetPositionFetchedResultsController: NSFetchedResultsController<AssetPosition>
    private let liabilityPositionFetchedResultsController: NSFetchedResultsController<LiabilityPosition>
    
    @Retriever var snapshots: [Snapshot]
    @Retriever var assetPositions: [AssetPosition]
    @Retriever var liabilityPositions: [LiabilityPosition]
    
    
    init(context: NSManagedObjectContext) {
        let snapshotRequest = NSFetchRequest<Snapshot>(entityName: "Snapshot")
        snapshotRequest.sortDescriptors = []
        snapshotFetchedResultsController = .init(fetchRequest: snapshotRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        try? snapshotFetchedResultsController.performFetch()
        
        let assetPositionRequest = NSFetchRequest<AssetPosition>(entityName: "AssetPosition")
        assetPositionRequest.sortDescriptors = []
        assetPositionFetchedResultsController = .init(fetchRequest: assetPositionRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        try? snapshotFetchedResultsController.performFetch()
        
        let liabilityPositionRequest = NSFetchRequest<LiabilityPosition>(entityName: "LiabilityPosition")
        liabilityPositionRequest.sortDescriptors = []
        liabilityPositionFetchedResultsController = .init(fetchRequest: liabilityPositionRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        try? snapshotFetchedResultsController.performFetch()
        
        super.init()
        
        $snapshots.toRetrieveDo { [unowned self] in
            snapshotFetchedResultsController.fetchedObjects ?? .defaultValue
        }
        $assetPositions.toRetrieveDo { [unowned self] in
            assetPositionFetchedResultsController.fetchedObjects ?? .defaultValue
        }
        $liabilityPositions.toRetrieveDo { [unowned self] in
            liabilityPositionFetchedResultsController.fetchedObjects ?? .defaultValue
        }
        
        snapshotFetchedResultsController.delegate = self
        assetPositionFetchedResultsController.delegate = self
        liabilityPositionFetchedResultsController.delegate = self
    }
    
    
    func createSnapshot(with date: Date, _ assetProxies: [PositionProxy], and liabilityProxies: [PositionProxy]) {
        let context = snapshotFetchedResultsController.managedObjectContext
        let snapshot = Snapshot(usedContext: context)
        snapshot.date = date.startOfDay
        
        var assetPositions = [AssetPosition]()
        assetProxies.forEach { proxy in
            let position = AssetPosition(usedContext: context)
            position.name = proxy.name
            position.value = proxy.value.nsDecimalNumberValue
            position.poolName = proxy.poolName
            position.snapshot = snapshot
            assetPositions.append(position)
        }
        
        var liabilityPositions = [LiabilityPosition]()
        liabilityProxies.forEach { proxy in
            let position = LiabilityPosition(usedContext: context)
            position.name = proxy.name
            position.value = proxy.value.nsDecimalNumberValue
            position.poolName = proxy.poolName
            position.snapshot = snapshot
            liabilityPositions.append(position)
        }
        try? context.save()
    }
    
    func updateSnapshot(_ snapshot: Snapshot, using date: Date, _ assetProxies: [PositionProxy], and liabilityProxies: [PositionProxy]) {
        let context = snapshotFetchedResultsController.managedObjectContext
        snapshot.date = date.startOfDay
        let assetPositions = assetPositions.filter{ $0.snapshot == snapshot }
        assetProxies.forEach { proxy in
            if let position = assetPositions.first(where: { $0.name == proxy.name} ) {
                position.value = proxy.value.nsDecimalNumberValue
            }
        }
        let liabilityPositions = liabilityPositions.filter{ $0.snapshot == snapshot }
        liabilityProxies.forEach { proxy in
            if let position = liabilityPositions.first(where: { $0.name == proxy.name} ) {
                position.value = proxy.value.nsDecimalNumberValue
            }
        }
        try? context.save()
    }
    
    func deleteSnapshot(snapshot: Snapshot) {
        let context = snapshotFetchedResultsController.managedObjectContext
        context.delete(snapshot)
        try? context.save()
    }
}

extension SnapshotRepository: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == snapshotFetchedResultsController {
            snapshots = snapshotFetchedResultsController.fetchedObjects ?? .defaultValue
        }
        if controller == assetPositionFetchedResultsController {
            assetPositions = assetPositionFetchedResultsController.fetchedObjects ?? .defaultValue
        }
        if controller == liabilityPositionFetchedResultsController {
            liabilityPositions = liabilityPositionFetchedResultsController.fetchedObjects ?? .defaultValue
        }
    }
}
