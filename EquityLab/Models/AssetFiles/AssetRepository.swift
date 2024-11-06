import CoreData
import ObservableProperties

class AssetRepository: NSObject {
    public static let production = AssetRepository(context: ProductionCoreDataStack.shared.context)
    private let fetchedResultsController: ObservingFetchedResultsController<AssetPool>
    @Publisher var assetPools: [AssetPool]
    
    init(context: NSManagedObjectContext) {
        let request = ObservingFetchRequest<AssetPool>(entityName: "AssetPool")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \AssetPool.name, ascending: true)]
        request.observedRelationships = ["assets"]
        fetchedResultsController = .init(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        try? fetchedResultsController.performFetch()
        self.assetPools = fetchedResultsController.fetchedObjects as? [AssetPool] ?? []
        super.init()
        fetchedResultsController.delegate = self
    }
    
    
    func fetchAssetPools() -> [AssetPool] {
        try? fetchedResultsController.performFetch()
        return fetchedResultsController.fetchedObjects as? [AssetPool] ?? []
    }
    
    func fetchPossessions(for assetPool: AssetPool) -> [Possession] {
        (try? fetchedResultsController.managedObjectContext.fetch(assetPool.getPossessionRequest())) ?? []
    }
    
    func fetchReceivables(for assetPool: AssetPool) -> [Receivable] {
        (try? fetchedResultsController.managedObjectContext.fetch(assetPool.getReceivableRequest())) ?? []
    }
    
    func fetchReceivables() -> [Receivable] {
        let receivableFetchRequest = NSFetchRequest<Receivable>(entityName: String(describing: "Receivable"))
        receivableFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Receivable.grantDate, ascending: true)]
        return (try? fetchedResultsController.managedObjectContext.fetch(receivableFetchRequest)) ?? []
    }
    
    func fetchPossessions() -> [Possession] {
        let possessionFetchRequest = NSFetchRequest<Possession>(entityName: String(describing: "Possession"))
        return (try? fetchedResultsController.managedObjectContext.fetch(possessionFetchRequest)) ?? []
    }
    
    func delete(receivable: Receivable) {
        let context = fetchedResultsController.managedObjectContext
        context.delete(receivable)
        try? context.save()
    }
    
    func delete(possession: Possession) {
        let context = fetchedResultsController.managedObjectContext
        context.delete(possession)
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
                          newInitialAmount: Double,
                          newRepaidAmount: Double,
                          newGrantDate: Date,
                          newPool: AssetPool) {
        let context = fetchedResultsController.managedObjectContext
        receivable.name = newName
        receivable.debtor = newDebtor
        receivable.initialAmount = newInitialAmount
        receivable.repaidAmount = newRepaidAmount
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
                          initialAmount: Double,
                          repaidAmount: Double,
                          grantDate: Date) {
        let context = fetchedResultsController.managedObjectContext
        let receivable = Receivable(usedContext: context)
        receivable.name = name
        receivable.pool = pool
        receivable.debtor = debtor
        receivable.initialAmount = initialAmount
        receivable.repaidAmount = repaidAmount
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
        assetPools = fetchedResultsController.fetchedObjects as? [AssetPool] ?? []
    }
}
