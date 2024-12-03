import CoreData

class SnapshotRepository: NSObject {
    public static let production = SnapshotRepository(context: ProductionCoreDataStack.shared.context)
    private let fetchedResultsController: ObservingFetchedResultsController<Snapshot>
    private var observers: [WeakSnapshotObserver]
    
    init(context: NSManagedObjectContext) {
        let request = ObservingFetchRequest<Snapshot>(entityName: "Snapshot")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Snapshot.date, ascending: true)]
        request.observedRelationships = ["assets", "liabilities"]
        fetchedResultsController = .init(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        try? fetchedResultsController.performFetch()
        self.observers = []
        super.init()
        fetchedResultsController.delegate = self
    }
    
    func add(observer: SnapshotObserver) {
        guard !observers.contains(where: { $0.observer === observer }) else { return }
        observers.append(WeakSnapshotObserver(observer: observer))
    }
    
    
    func fetchSnapshots(sortingOrder: SnapshotSortingOrder = .ascending) -> [Snapshot] {
        try? fetchedResultsController.performFetch()
        let snapshots = fetchedResultsController.fetchedObjects as? [Snapshot] ?? []
        switch sortingOrder {
        case .ascending: return snapshots
        case .descending: return snapshots.reversed()
        }
    }
    
    func fetchAssetPositions(of snapshot: Snapshot) -> [AssetPosition] {
        (try? fetchedResultsController.managedObjectContext.fetch(snapshot.getAssetPositionRequest())) ?? []
    }
    
    func fetchAssetPositions(with name: String) -> [AssetPosition] {
        let request = NSFetchRequest<AssetPosition>(entityName: "AssetPosition")
        request.predicate = NSPredicate(format: "name == %@", name)
        return (try? fetchedResultsController.managedObjectContext.fetch(request)) ?? []
    }
    
    func fetchLiabilityPositions(of snapshot: Snapshot) -> [LiabilityPosition] {
        (try? fetchedResultsController.managedObjectContext.fetch(snapshot.getLiabilityPositionRequest())) ?? []
    }
    
    func delete(snapshot: Snapshot) {
        let context = fetchedResultsController.managedObjectContext
        context.delete(snapshot)
        try? context.save()
    }
    
    func createSnapshot(with date: Date, _ assetProxies: [PositionProxy], and liabilityProxies: [PositionProxy]) {
        let context = fetchedResultsController.managedObjectContext
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
        let assetPositions = fetchAssetPositions(of: snapshot)
        assetProxies.forEach { proxy in
            if let position = assetPositions.first(where: { $0.name == proxy.name} ) {
                position.value = proxy.value.nsDecimalNumberValue
            }
        }
        let liabilityPositions = fetchLiabilityPositions(of: snapshot)
        liabilityProxies.forEach { proxy in
            if let position = liabilityPositions.first(where: { $0.name == proxy.name} ) {
                position.value = proxy.value.nsDecimalNumberValue
            }
        }
        try? fetchedResultsController.managedObjectContext.save()
    }
}

extension SnapshotRepository: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        observers = observers.filter { $0.observer.isNotNil }
        observers.forEach{ $0.observer?.notifyAfterSnapshotUpdate()}
    }
}

protocol SnapshotObserver: AnyObject {
    /* TODO: will this create a retain cycle or other memory problems? */
    func notifyAfterSnapshotUpdate()
}

class WeakSnapshotObserver {
    weak var observer: SnapshotObserver?
    init(observer: SnapshotObserver?) {
        self.observer = observer
    }
}

enum SnapshotSortingOrder {
    case ascending
    case descending
}
