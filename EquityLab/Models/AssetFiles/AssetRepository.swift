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
        try? fetchedResultsController.performFetch()
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
    
    func fetchReceivables() -> [Receivable] {
        let receivableFetchRequest = NSFetchRequest<Receivable>(entityName: String(describing: "Receivable"))
        receivableFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Receivable.grantDate, ascending: true)]
        return (try? fetchedResultsController.managedObjectContext.fetch(receivableFetchRequest)) ?? []
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
        let pool = AssetPool(usedContext: context)
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
    
    func updateReceivable(receivable: Receivable,
                          newName: String,
                          newDebtor: String,
                          newInitialAmount: Decimal,
                          newRepaidAmount: Decimal,
                          newGrantDate: Date,
                          newPool: AssetPool) {
        let context = fetchedResultsController.managedObjectContext
        receivable.name = newName
        receivable.debtor = newDebtor
        receivable.initialAmount = newInitialAmount.nsDecimalNumberValue
        receivable.repaidAmount = newRepaidAmount.nsDecimalNumberValue
        receivable.grantDate = newGrantDate
        receivable.pool = newPool
        try? context.save()
    }
    
    func updatePossession(possession: Possession, newName: String, newIsVolatile: Bool, newPool: AssetPool) {
        let context = fetchedResultsController.managedObjectContext
        possession.name = newName
        possession.volatile = newIsVolatile
        possession.pool = newPool
        try? context.save()
    }
    
    func createReceivable(name: String,
                          pool: AssetPool,
                          debtor: String,
                          initialAmount: Decimal,
                          repaidAmount: Decimal,
                          grantDate: Date) {
        let context = fetchedResultsController.managedObjectContext
        let receivable = Receivable(usedContext: context)
        receivable.name = name
        receivable.pool = pool
        receivable.debtor = debtor
        receivable.initialAmount = initialAmount.nsDecimalNumberValue
        receivable.repaidAmount = repaidAmount.nsDecimalNumberValue
        receivable.grantDate = grantDate
        try? context.save()
    }
    
    func createPossession(name: String, pool: AssetPool, isVolatile: Bool) {
        let context = fetchedResultsController.managedObjectContext
        let possession = Possession(context: context)
        possession.name = name
        possession.volatile = isVolatile
        possession.pool = pool
        try? context.save()
    }
}

extension AssetRepository: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        observers = observers.filter { $0.observer.isNotNil }
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
