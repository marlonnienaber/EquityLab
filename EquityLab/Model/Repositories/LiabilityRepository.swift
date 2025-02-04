import CoreData

class LiabilityRepository: NSObject {
    public static let production = LiabilityRepository(context: ProductionCoreDataStack.shared.context)
    private let context: NSManagedObjectContext
    private let liabilityPoolFetchedResultsController: NSFetchedResultsController<LiabilityPool>
    private let liabilityFetchedResultsController: NSFetchedResultsController<Liability>
    private let liabilityTransactionsFetchedResultsController: NSFetchedResultsController<LoanTransaction>
    private var observers: [WeakLiabilityRepositoryObserver]
    
    init(context: NSManagedObjectContext) {
        self.context = context
        
        let liabilityPoolRequest = LiabilityPool.fetchRequest()
        liabilityPoolRequest.sortDescriptors = []
        liabilityPoolFetchedResultsController = NSFetchedResultsController(request: liabilityPoolRequest, context: context)
        
        let liabilityRequest = Liability.fetchRequest()
        liabilityRequest.sortDescriptors = []
        liabilityFetchedResultsController = NSFetchedResultsController(request: liabilityRequest, context: context)
        
        let liabilityTransactionRequest = LoanTransaction.fetchRequest()
        liabilityTransactionRequest.sortDescriptors = []
        liabilityTransactionRequest.predicate = NSPredicate(format: "liability != nil")
        liabilityTransactionsFetchedResultsController = .init(request: liabilityTransactionRequest, context: context)
        
        self.observers = []
        super.init()
        
        try? liabilityPoolFetchedResultsController.performFetch()
        try? liabilityFetchedResultsController.performFetch()
        try? liabilityTransactionsFetchedResultsController.performFetch()
        
        liabilityPoolFetchedResultsController.delegate = self
        liabilityFetchedResultsController.delegate = self
        liabilityTransactionsFetchedResultsController.delegate = self
    }
    
    func add(observer: AnyObject) {
        guard !observers.contains(where: { $0.observer === observer }) else { return }
        observers.append(WeakLiabilityRepositoryObserver(observer: observer))
    }
    
    func getLiabilities() -> [Liability] {
        liabilityFetchedResultsController.fetchedObjects ?? []
    }
    
    func getLiabilityPools() -> [LiabilityPool] {
        liabilityPoolFetchedResultsController.fetchedObjects ?? []
    }
    
    func getTransactions() -> [LoanTransaction] {
        liabilityTransactionsFetchedResultsController.fetchedObjects ?? []
    }
    
    func delete(liability: Liability) {
        let context = liabilityPoolFetchedResultsController.managedObjectContext
        context.delete(liability)
        try? context.save()
    }
    
    func delete(liabilityPool: LiabilityPool) {
        context.delete(liabilityPool)
        try? context.save()
    }
    
    func delete(transaction: LoanTransaction) {
        context.delete(transaction)
        try? context.save()
    }
    
    func createLiabilityPool(named name: String) {
        let pool = LiabilityPool(context: context)
        pool.name = name
        try? context.save()
    }
    
    func update(liabilityPool: LiabilityPool, newName: String) {
        liabilityPool.name = newName
        try? context.save()
    }
    
    func createLiability(name: String,
                         pool: LiabilityPool,
                         creditor: LoanPartner,
                         initialAmount: Decimal,
                         grantDate: Date) {
        let liability = Liability(usedContext: context)
        liability.creditor = creditor
        liability.name = name
        liability.pool = pool
        let initialTransaction = LoanTransaction(usedContext: context)
        initialTransaction.date = grantDate
        initialTransaction.amount = initialAmount.nsDecimalNumberValue
        initialTransaction.issuer = creditor
        initialTransaction.note = "disbursed amount"
        initialTransaction.emoji = "💶"
        initialTransaction.liability = liability
        try? context.save()
    }
    
    func updateLiability(liability: Liability,
                         newName: String,
                         newPool: LiabilityPool,
                         newCreditor: LoanPartner) {
        liability.creditor = newCreditor
        liability.name = newName
        liability.pool = newPool
        try? context.save()
    }
    
    func createLiabilityTransaction(
        amount: Decimal,
        date: Date,
        note: String,
        issuer: LoanPartner?,
        liability: Liability
    ) {
        let transaction = LoanTransaction(usedContext: context)
        transaction.amount = amount.nsDecimalNumberValue
        transaction.date = date
        transaction.emoji = issuer.isNil ? "🔁" : "💶"
        transaction.note = note
        transaction.issuer = issuer
        transaction.liability = liability
        try? context.save()
    }
    
    func updateLiabilityTransaction(
        transaction: LoanTransaction,
        amount: Decimal,
        date: Date,
        note: String,
        issuer: LoanPartner?
    ) {
        transaction.amount = amount.nsDecimalNumberValue
        transaction.date = date
        transaction.emoji = issuer.isNil ? "🔁" : "💶"
        transaction.note = note
        transaction.issuer = issuer
        try? context.save()
    }
}

extension LiabilityRepository: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        observers = observers.filter { $0.observer.isNotNil }
        if controller == liabilityPoolFetchedResultsController {
            for weakObserver in observers {
                if let liabilityPoolObserver = weakObserver.observer as? LiabilityPoolObserver {
                    liabilityPoolObserver.notifyAfterLiabilityPoolUpdate()
                }
            }
        }
        if controller == liabilityFetchedResultsController {
            for weakObserver in observers {
                if let liabilityObserver = weakObserver.observer as? LiabilityObserver {
                    liabilityObserver.notifyAfterLiabilityUpdate()
                }
            }
        }
        if controller == liabilityTransactionsFetchedResultsController {
            for weakObserver in observers {
                if let liabilityTransactionObserver = weakObserver.observer as? LiabilityTransactionObserver {
                    liabilityTransactionObserver.notifyAfterLiabilityTransactionUpdate()
                }
            }
        }
    }
}

protocol LiabilityPoolObserver: AnyObject {
    func notifyAfterLiabilityPoolUpdate()
}

protocol LiabilityObserver: AnyObject {
    func notifyAfterLiabilityUpdate()
}

protocol LiabilityTransactionObserver: AnyObject {
    func notifyAfterLiabilityTransactionUpdate()
}

class WeakLiabilityRepositoryObserver {
    weak var observer: AnyObject?
    init(observer: AnyObject?) {
        self.observer = observer
    }
}
