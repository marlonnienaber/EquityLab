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
        liabilityFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Liability.grantDate, ascending: true)]
        return (try? fetchedResultsController.managedObjectContext.fetch(liabilityFetchRequest)) ?? []
    }
    
    func fetchLiabilities(for pool: LiabilityPool) -> [Liability] {
        return (try? fetchedResultsController.managedObjectContext.fetch(pool.getLiabilityRequest())) ?? []
    }
    
    func fetchLiabilityPools() -> [LiabilityPool] {
        try? fetchedResultsController.performFetch()
        return fetchedResultsController.fetchedObjects as? [LiabilityPool] ?? []
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
                         initialAmount: Decimal,
                         repaidAmount: Decimal,
                         grantDate: Date) {
        let context = fetchedResultsController.managedObjectContext
        let liability = Liability(usedContext: context)
        liability.grantDate = grantDate
        liability.creditor = creditor
        liability.initialAmount = initialAmount.nsDecimalNumberValue
        liability.repaidAmount = repaidAmount.nsDecimalNumberValue
        liability.name = name
        liability.pool = pool
        try? context.save()
    }
    
    func updateLiability(liability: Liability,
                         newName: String,
                         newCreditor: String,
                         newInitialAmount: Decimal,
                         newRepaidAmount: Decimal,
                         newGrantDate: Date,
                         newPool: LiabilityPool) {
        let context = fetchedResultsController.managedObjectContext
        liability.grantDate = newGrantDate.startOfDay
        liability.creditor = newCreditor
        liability.initialAmount = newInitialAmount.nsDecimalNumberValue
        liability.repaidAmount = newRepaidAmount.nsDecimalNumberValue
        liability.name = newName
        liability.pool = newPool
        try? context.save()
    }
}

extension LiabilityRepository: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        observers = observers.filter { $0.observer.isNotNil }
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
