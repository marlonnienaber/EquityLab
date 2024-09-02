import CoreData

class SnapshotRepository: NSObject {
    public static let production = SnapshotRepository(context: ProductionCoreDataStack.shared.context)
    private let fetchedResultsController: ObservingFetchedResultsController<Snapshot>
    private var observers: [SnapshotObserver]
    
    init(context: NSManagedObjectContext) {
        let request = ObservingFetchRequest<Snapshot>(entityName: "Snapshot")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Snapshot.date, ascending: true)]
        request.observedRelationships = ["liabilities"]
        fetchedResultsController = .init(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.observers = []
        super.init()
        fetchedResultsController.delegate = self
    }
    
    func add(observer: SnapshotObserver) {
        guard !observers.contains(where: { $0 === observer }) else { return }
        observers.append(observer)
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
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        observers.forEach{ $0.updateSnapshots(with: fetchSnapshots())}
    }
}

protocol SnapshotObserver: AnyObject {
    func updateSnapshots(with newSnapshots: [Snapshot])
}
