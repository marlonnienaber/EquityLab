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
        self.observers = []
        super.init()
        fetchedResultsController.delegate = self
    }
    
    func add(observer: SnapshotObserver) {
        guard !observers.contains(where: { $0.observer === observer }) else { return }
        observers.append(WeakSnapshotObserver(observer: observer))
    }
    
    func fetchSnapshots() -> [Snapshot] {
        try? fetchedResultsController.performFetch()
        return fetchedResultsController.fetchedObjects as? [Snapshot] ?? []
    }
    
    func fetchAssetPositions(of snapshot: Snapshot) -> [AssetPosition] {
        (try? fetchedResultsController.managedObjectContext.fetch(snapshot.getAssetPositionRequest())) ?? []
    }
    
    func fetchLiabilityPositions(of snapshot: Snapshot) -> [LiabilityPosition] {
        (try? fetchedResultsController.managedObjectContext.fetch(snapshot.getLiabilityPositionRequest())) ?? []
    }
}

extension SnapshotRepository: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        observers = observers.filter { $0.observer != nil }
        observers.forEach{ $0.observer?.updateSnapshots(with: fetchSnapshots())}
    }
}

protocol SnapshotObserver: AnyObject {
    func updateSnapshots(with newSnapshots: [Snapshot])
}

class WeakSnapshotObserver {
    weak var observer: SnapshotObserver?
    init(observer: SnapshotObserver?) {
        self.observer = observer
    }
}
