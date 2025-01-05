import CoreData

class AssetRepository: NSObject {
    public static let production = AssetRepository(context: ProductionCoreDataStack.shared.context)
    private let context: NSManagedObjectContext
    private let assetPoolFetchedResultsController: NSFetchedResultsController<AssetPool>
    private let possessionFetchedResultsController: NSFetchedResultsController<Possession>
    private let receivableFetchedResultsController: NSFetchedResultsController<Receivable>
    private let receivableTransactionsFetchedResultsController: NSFetchedResultsController<LoanTransaction>
    private var observers: [WeakAssetRepositoryObserver]
    
    init(context: NSManagedObjectContext) {
        self.context = context
        
        let assetPoolRequest = AssetPool.fetchRequest()
        assetPoolRequest.sortDescriptors = []
        assetPoolFetchedResultsController = NSFetchedResultsController(request: assetPoolRequest, context: context)
        
        
        let possessionRequest = Possession.fetchRequest()
        possessionRequest.sortDescriptors = []
        possessionFetchedResultsController = NSFetchedResultsController(request: possessionRequest, context: context)
        
        let receivableRequest = Receivable.fetchRequest()
        receivableRequest.sortDescriptors = []
        receivableFetchedResultsController = NSFetchedResultsController(request: receivableRequest, context: context)
        
        let receivableTransactionRequest = LoanTransaction.fetchRequest()
        receivableTransactionRequest.sortDescriptors = []
        receivableTransactionRequest.predicate = NSPredicate(format: "receivable != nil")
        receivableTransactionsFetchedResultsController = .init(request: receivableTransactionRequest, context: context)
        
        self.observers = []
        super.init()
        
        try? assetPoolFetchedResultsController.performFetch()
        try? possessionFetchedResultsController.performFetch()
        try? receivableFetchedResultsController.performFetch()
        try? receivableTransactionsFetchedResultsController.performFetch()
        
        assetPoolFetchedResultsController.delegate = self
        possessionFetchedResultsController.delegate = self
        receivableFetchedResultsController.delegate = self
        receivableTransactionsFetchedResultsController.delegate = self
    }
    
    func add(observer: AnyObject) {
        guard !observers.contains(where: { $0.observer === observer }) else { return }
        observers.append(WeakAssetRepositoryObserver(observer: observer))
    }
    
    func getTransactions() -> [LoanTransaction] {
        receivableTransactionsFetchedResultsController.fetchedObjects ?? []
    }
    
    func updateReceivableTransaction(
        transaction: LoanTransaction,
        amount: Decimal,
        date: Date,
        note: String,
        issuer: LoanPartner?
    ) {
        transaction.amount = amount.nsDecimalNumberValue
        transaction.date = date
        transaction.emoji = issuer.isNil ? "📤" : "💶"
        transaction.note = note
        transaction.issuer = issuer
        try? context.save()
    }
    
    func createReceivableTransaction(
        amount: Decimal,
        date: Date,
        note: String,
        issuer: LoanPartner?,
        receivable: Receivable
    ) {
        let transaction = LoanTransaction(usedContext: context)
        transaction.amount = amount.nsDecimalNumberValue
        transaction.date = date
        transaction.emoji = issuer.isNil ? "📤" : "💶"
        transaction.note = note
        transaction.issuer = issuer
        transaction.receivable = receivable
        try? context.save()
    }
    
    func getAssetPools() -> [AssetPool] {
        assetPoolFetchedResultsController.fetchedObjects ?? []
    }
    
    func getReceivables() -> [Receivable] {
        receivableFetchedResultsController.fetchedObjects ?? []
    }
    
    func getPossessions() -> [Possession] { /* TODO: let callers treat sorting themselves since sorting was elimintaed here */
        possessionFetchedResultsController.fetchedObjects ?? []
    }
    
    func delete(transaction: LoanTransaction) {
        context.delete(transaction)
        try? context.save()
    }
    
    func delete(possession: Possession) {
        context.delete(possession)
        try? context.save()
    }
    
    func delete(receivable: Receivable) {
        context.delete(receivable)
        try? context.save()
    }
    
    func createAssetPool(named name: String) {
        let pool = AssetPool(usedContext: context)
        pool.name = name
        try? context.save()
    }
    
    func delete(assetPool: AssetPool) {
        context.delete(assetPool)
        try? context.save()
    }
    
    func update(assetPool: AssetPool, newName: String) {
        assetPool.name = newName
        try? context.save()
    }
    
    func updateReceivable(receivable: Receivable,
                          newName: String,
                          newDebtor: LoanPartner,
                          newPool: AssetPool) {
        receivable.name = newName
        receivable.debtor = newDebtor
        receivable.pool = newPool
        try? context.save()
    }
    
    func updatePossession(possession: Possession, newName: String, newIsVolatile: Bool, newPool: AssetPool) {
        possession.name = newName
        possession.volatile = newIsVolatile
        possession.pool = newPool
        try? context.save()
    }
    
    func createReceivable(name: String,
                          debtor: LoanPartner,
                          pool: AssetPool,
                          disbursedAmount: Decimal,
                          grantDate: Date) {
        let receivable = Receivable(usedContext: context)
        receivable.name = name
        receivable.pool = pool
        receivable.debtor = debtor
        let initialTransaction = LoanTransaction(usedContext: context)
        initialTransaction.date = grantDate
        initialTransaction.amount = disbursedAmount.nsDecimalNumberValue
        initialTransaction.note = "disbursed amount"
        initialTransaction.emoji = "📤"
        initialTransaction.receivable = receivable
        try? context.save()
    }
    
    func createPossession(name: String, pool: AssetPool, isVolatile: Bool) {
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
        if controller == assetPoolFetchedResultsController {
            for weakObserver in observers {
                if let assetPoolObserver = weakObserver.observer as? AssetPoolObserver {
                    assetPoolObserver.notifyAfterAssetPoolUpdate()
                }
            }
        }
        if controller == possessionFetchedResultsController {
            for weakObserver in observers {
                if let possessionObserver = weakObserver.observer as? PossessionObserver {
                    possessionObserver.notifyAfterPossessionUpdate()
                }
            }
        }
        if controller == receivableFetchedResultsController {
            for weakObserver in observers {
                if let receivableObserver = weakObserver.observer as? ReceivableObserver {
                    receivableObserver.notifyAfterReceivableUpdate()
                }
            }
        }
        if controller == receivableTransactionsFetchedResultsController {
            for weakObserver in observers {
                if let receivableTransactionObserver = weakObserver.observer as? ReceivableTransactionObserver {
                    receivableTransactionObserver.notifyAfterReceivableTransactionUpdate()
                }
            }
        }
    }
}

/* TODO: will the callback logic create a retain cycle or other memory problems? */
protocol AssetPoolObserver: AnyObject {
    func notifyAfterAssetPoolUpdate()
}

protocol PossessionObserver: AnyObject {
    func notifyAfterPossessionUpdate()
}

protocol ReceivableObserver: AnyObject {
    func notifyAfterReceivableUpdate()
}

protocol ReceivableTransactionObserver: AnyObject {
    func notifyAfterReceivableTransactionUpdate()
}

class WeakAssetRepositoryObserver {
    weak var observer: AnyObject?
    init(observer: AnyObject?) {
        self.observer = observer
    }
}
