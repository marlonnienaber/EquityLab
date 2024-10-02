import CoreData

class AssetRepository: NSObject {
    public static let production = AssetRepository(context: ProductionCoreDataStack.shared.context)
    private let fetchedResultsController: ObservingFetchedResultsController<AssetPool>
    private var observers: [WeakAssetObserver]
    
    init(context: NSManagedObjectContext) {
        let request = ObservingFetchRequest<AssetPool>(entityName: "AssetPool")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \AssetPool.name, ascending: true)]
        request.observedRelationships = ["assets"]
        fetchedResultsController = .init(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.observers = []
        super.init()
        fetchedResultsController.delegate = self
    }
    
    func add(observer: AssetObserver) {
        guard !observers.contains(where: { $0.observer === observer }) else { return }
        observers.append(WeakAssetObserver(observer: observer))
    }
    
    func fetchAssetPools() -> [AssetPool] {
        try? fetchedResultsController.performFetch()
        return fetchedResultsController.fetchedObjects as? [AssetPool] ?? []
    }
    
    func fetchAssets() -> [Asset] {
        let assetFetchRequest = NSFetchRequest<Asset>(entityName: String(describing: "Asset"))
        return (try? fetchedResultsController.managedObjectContext.fetch(assetFetchRequest)) ?? []
    }
    
    func fetchAssets(for pool: AssetPool) -> [Asset] {
        (try? fetchedResultsController.managedObjectContext.fetch(pool.getAssetRequest())) ?? []
    }
    
    func delete(asset: Asset) {
        let context = fetchedResultsController.managedObjectContext
        context.delete(asset)
        try? context.save()
    }
    
    func createAssetPool(named name: String) {
        let context = fetchedResultsController.managedObjectContext
        let pool = AssetPool(context: context)
        pool.name = name
        try? context.save()
    }
    
    func delete(assetPool: AssetPool) {
        let context = fetchedResultsController.managedObjectContext
        context.delete(assetPool)
        try? context.save()
    }
    
    func update(assetPool: AssetPool, newName: String) {
        let context = fetchedResultsController.managedObjectContext
        assetPool.name = newName
        try? context.save()
    }
}

extension AssetRepository: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        observers = observers.filter { $0.observer != nil }
        observers.forEach{ $0.observer?.notifyAfterAssetUpdate()}
    }
}

protocol AssetObserver: AnyObject {
    /* TODO: will this create a retain cycle or other memory problems */
    func notifyAfterAssetUpdate()
}

class WeakAssetObserver {
    weak var observer: AssetObserver?
    init(observer: AssetObserver?) {
        self.observer = observer
    }
}
