import CoreData

class LiabilityRepository: NSObject {
    public static let production = LiabilityRepository(context: ProductionCoreDataStack.shared.context)
    private let fetchedResultsController: ObservingFetchedResultsController<LiabilityPool>
    private var observers: [WeakLiabilityObserver]
    
    init(context: NSManagedObjectContext) {
        let request = ObservingFetchRequest<LiabilityPool>(entityName: "LiabilityPool")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \LiabilityPool.name, ascending: true)]
        request.observedRelationships = ["liabilities"]
        fetchedResultsController = .init(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        try? fetchedResultsController.performFetch()
        self.observers = []
        super.init()
        fetchedResultsController.delegate = self
    }
    
    func add(observer: LiabilityObserver) {
        guard !observers.contains(where: { $0.observer === observer }) else { return }
        observers.append(WeakLiabilityObserver(observer: observer))
    }
    
    func fetchLiabilities() -> [Liability] {
        let liabilityFetchRequest = NSFetchRequest<Liability>(entityName: String(describing: "Liability"))
        return (try? fetchedResultsController.managedObjectContext.fetch(liabilityFetchRequest)) ?? []
    }
    
    func fetchLiabilities(for pool: LiabilityPool) -> [Liability] {
        return (try? fetchedResultsController.managedObjectContext.fetch(pool.getLiabilityRequest())) ?? []
    }
    
    func fetchLiabilityPools() -> [LiabilityPool] {
        try? fetchedResultsController.performFetch()
        let liabilityPools = fetchedResultsController.fetchedObjects as? [LiabilityPool] ?? []
        if liabilityPools.isEmpty{
            print("no liabilityPools could be fetched")
        } else {
            print("\(liabilityPools.count) liabilityPools were fetched")
        }
        return liabilityPools
    }
    
    func delete(liability: Liability) {
        let context = fetchedResultsController.managedObjectContext
        context.delete(liability)
        try? context.save()
    }
    
    func delete(liabilityPool: LiabilityPool) {
        let context = fetchedResultsController.managedObjectContext
        context.delete(liabilityPool)
        try? context.save()
    }
    
    func createLiabilityPool(named name: String) {
        let context = fetchedResultsController.managedObjectContext
        let pool = LiabilityPool(context: context)
        pool.name = name
        try? context.save()
    }
    
    func update(liabilityPool: LiabilityPool, newName: String) {
        let context = fetchedResultsController.managedObjectContext
        liabilityPool.name = newName
        try? context.save()
    }
    
    func createLiability(name: String,
                         pool: LiabilityPool,
                         creditor: String,
                         initialAmount: Double,
                         repaidAmount: Double,
                         grantDate: Date) {
        let context = fetchedResultsController.managedObjectContext
        let liability = Liability(usedContext: context)
        liability.grantDate = grantDate
        liability.creditor = creditor
        liability.initialAmount = initialAmount
        liability.repaidAmount = repaidAmount
        liability.name = name
        liability.pool = pool
        try? context.save()
    }
    
    func updateLiability(liability: Liability,
                         newName: String,
                         newCreditor: String,
                         newInitialAmount: Double,
                         newRepaidAmount: Double,
                         newGrantDate: Date) {
        let context = fetchedResultsController.managedObjectContext
        liability.grantDate = newGrantDate.startOfDay
        liability.creditor = newCreditor
        liability.initialAmount = newInitialAmount
        liability.repaidAmount = newRepaidAmount
        liability.name = newName
        try? context.save()
    }
}

extension LiabilityRepository: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        observers = observers.filter { $0.observer != nil }
        observers.forEach{ $0.observer?.notifyAfterLiabilityUpdate()}
    }
}

protocol LiabilityObserver: AnyObject {
    /* TODO: will this create a retain cycle or other memory problems */
    func notifyAfterLiabilityUpdate()
}

class WeakLiabilityObserver {
    weak var observer: LiabilityObserver?
    init(observer: LiabilityObserver?) {
        self.observer = observer
    }
}
