import CoreData

class SnapshotRepository: NSObject {
    public static let production = SnapshotRepository(context: ProductionCoreDataStack.shared.context)
    private let context: NSManagedObjectContext
    private let snapshotFetchedResultsController: NSFetchedResultsController<Snapshot>
    private let assetPositionFetchedResultsController: NSFetchedResultsController<AssetPosition>
    private let liabilityPositionFetchedResultsController: NSFetchedResultsController<LiabilityPosition>
    private var observers: [WeakSnapshotRepositoryObserver]
    
    init(context: NSManagedObjectContext) {
        self.context = context
        
        let snapshotRequest = Snapshot.fetchRequest()
        snapshotRequest.sortDescriptors = []
        snapshotFetchedResultsController = NSFetchedResultsController(request: snapshotRequest, context: context)
        
        let assetPositionRequest = NSFetchRequest<AssetPosition>(entityName: "AssetPosition")
        assetPositionRequest.sortDescriptors = []
        assetPositionFetchedResultsController = NSFetchedResultsController(request: assetPositionRequest, context: context)
        
        let liabilityPositionRequest = NSFetchRequest<LiabilityPosition>(entityName: "LiabilityPosition")
        liabilityPositionRequest.sortDescriptors = []
        liabilityPositionFetchedResultsController = NSFetchedResultsController(request: liabilityPositionRequest, context: context)
        
        self.observers = []
        super.init()
        
        try? snapshotFetchedResultsController.performFetch()
        try? assetPositionFetchedResultsController.performFetch()
        try? liabilityPositionFetchedResultsController.performFetch()
        
        snapshotFetchedResultsController.delegate = self
        assetPositionFetchedResultsController.delegate = self
        liabilityPositionFetchedResultsController.delegate = self
    }
    
    func add(observer: AnyObject) {
        guard !observers.contains(where: { $0.observer === observer }) else { return }
        observers.append(WeakSnapshotRepositoryObserver(observer: observer))
    }
    
    
    func getSnapshots() -> [Snapshot] {
        snapshotFetchedResultsController.fetchedObjects ?? []
    }
    
    func getAssetPositions() -> [AssetPosition] {
        assetPositionFetchedResultsController.fetchedObjects ?? []
    }
    
    func getLiabilityPositions() -> [LiabilityPosition] {
        liabilityPositionFetchedResultsController.fetchedObjects ?? []
    }
    
    func delete(snapshot: Snapshot) {
        let context = snapshotFetchedResultsController.managedObjectContext
        context.delete(snapshot)
        try? context.save()
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
        snapshot.date = date.startOfDay
        let assetPositions = getAssetPositions().filter{ $0.snapshot == snapshot }
        assetProxies.forEach { proxy in
            if let position = assetPositions.first(where: { $0.name == proxy.name} ) {
                position.value = proxy.value.nsDecimalNumberValue
            }
        }
        let liabilityPositions = getLiabilityPositions().filter{ $0.snapshot == snapshot }
        liabilityProxies.forEach { proxy in
            if let position = liabilityPositions.first(where: { $0.name == proxy.name} ) {
                position.value = proxy.value.nsDecimalNumberValue
            }
        }
        try? snapshotFetchedResultsController.managedObjectContext.save()
    }
}

extension SnapshotRepository: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        observers = observers.filter { $0.observer.isNotNil }
        if controller == snapshotFetchedResultsController {
            for weakObserver in observers {
                if let snapshotObserver = weakObserver.observer as? SnapshotObserver {
                    snapshotObserver.notifyAfterSnapshotUpdate()
                }
            }
        }
        if controller == assetPositionFetchedResultsController {
            for weakObserver in observers {
                if let assetPositionObserver = weakObserver.observer as? AssetPositionObserver {
                    assetPositionObserver.notifyAfterAssetPositionUpdate()
                }
            }
        }
        
        if controller == liabilityPositionFetchedResultsController {
            for weakObserver in observers {
                if let liabilityPositionObserver = weakObserver.observer as? LiabilityPositionObserver {
                    liabilityPositionObserver.notifyAfterLiabilityPositionUpdate()
                }
            }
        }
    }
}

protocol SnapshotObserver: AnyObject {
    func notifyAfterSnapshotUpdate()
}

protocol AssetPositionObserver: AnyObject {
    func notifyAfterAssetPositionUpdate()
}

protocol LiabilityPositionObserver: AnyObject {
    func notifyAfterLiabilityPositionUpdate()
}

class WeakSnapshotRepositoryObserver {
    weak var observer: AnyObject?
    init(observer: AnyObject?) {
        self.observer = observer
    }
}
