import CoreData
import ObservableProperties

class AssetRepository: NSObject {
    public static let production = AssetRepository(context: ProductionCoreDataStack.shared.context)
    
    private let assetPoolFetchedResultsController: NSFetchedResultsController<AssetPool>
    private let possessionFetchedResultsController: NSFetchedResultsController<Possession>
    private let receivableFetchedResultsController: NSFetchedResultsController<Receivable>
    private let receivableTransactionsFetchedResultsController: NSFetchedResultsController<LoanTransaction>
    
    @Retriever var assetPools: [AssetPool]
    @Retriever var possessions: [Possession]
    @Retriever var receivables: [Receivable]
    @Retriever var receivableTransactions: [LoanTransaction]
    
    
    init(context: NSManagedObjectContext) {
        let assetPoolRequest = NSFetchRequest<AssetPool>(entityName: "AssetPool")
        assetPoolRequest.sortDescriptors = [NSSortDescriptor(keyPath: \AssetPool.name, ascending: true)]
        assetPoolFetchedResultsController = .init(fetchRequest: assetPoolRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        try? assetPoolFetchedResultsController.performFetch()
        
        let possessionRequest = NSFetchRequest<Possession>(entityName: "Possession")
        possessionRequest.sortDescriptors = []
        possessionFetchedResultsController = .init(fetchRequest: possessionRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        try? possessionFetchedResultsController.performFetch()
        
        let receivableRequest = NSFetchRequest<Receivable>(entityName: "Receivable")
        receivableRequest.sortDescriptors = []
        receivableFetchedResultsController = .init(fetchRequest: receivableRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        try? receivableFetchedResultsController.performFetch()
        
        let transactionRequest = NSFetchRequest<LoanTransaction>(entityName: "LoanTransaction")
        transactionRequest.sortDescriptors = []
        transactionRequest.predicate = NSPredicate(format: "receivable != nil")
        receivableTransactionsFetchedResultsController = .init(fetchRequest: transactionRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        try? receivableTransactionsFetchedResultsController.performFetch()
        
        super.init()
        
        $assetPools.toRetrieveDo { [unowned self] in
            assetPoolFetchedResultsController.fetchedObjects ?? .defaultValue
        }
        $possessions.toRetrieveDo { [unowned self] in
            possessionFetchedResultsController.fetchedObjects ?? .defaultValue
        }
        $receivables.toRetrieveDo { [unowned self] in
            receivableFetchedResultsController.fetchedObjects ?? .defaultValue
        }
        $receivableTransactions.toRetrieveDo { [unowned self] in
            receivableTransactionsFetchedResultsController.fetchedObjects ?? .defaultValue
        }

        assetPoolFetchedResultsController.delegate = self
        possessionFetchedResultsController.delegate = self
        receivableFetchedResultsController.delegate = self
        receivableTransactionsFetchedResultsController.delegate = self
    }
    
    
    func createReceivable(name: String,
                          pool: AssetPool,
                          debtor: LoanPartner,
                          disbursedAmount: Decimal,
                          grantDate: Date) {
        let context = assetPoolFetchedResultsController.managedObjectContext
        
        let receivable = Receivable(usedContext: context)
        receivable.name = name
        receivable.pool = pool
        receivable.debtor = debtor
        
        let initialTransaction = LoanTransaction(usedContext: context)
        initialTransaction.receivable = receivable
        initialTransaction.amount = disbursedAmount.nsDecimalNumberValue
        initialTransaction.date = grantDate
        initialTransaction.note = "initial disbursement"
        initialTransaction.emoji = "📤"
        
        try? context.save()
    }
    
    func updateReceivable(receivable: Receivable,
                          newName: String,
                          newPool: AssetPool,
                          newDebtor: LoanPartner) {
        let context = receivableFetchedResultsController.managedObjectContext
        receivable.name = newName
        receivable.pool = newPool
        if receivable.debtor != newDebtor {
            receivable.debtor = newDebtor
            let transactions = receivableTransactions.filter{ $0.receivable == receivable && $0.issuer.isNotNil }
            transactions.forEach{ $0.issuer = newDebtor }
        }
        try? context.save()
    }
    
    func deleteReceivable(receivable: Receivable) {
        let context = assetPoolFetchedResultsController.managedObjectContext
        context.delete(receivable)
        try? context.save()
    }
    
    
    func createPossession(name: String, pool: AssetPool, isVolatile: Bool) {
        let context = assetPoolFetchedResultsController.managedObjectContext
        let possession = Possession(context: context)
        possession.name = name
        possession.volatile = isVolatile
        possession.pool = pool
        try? context.save()
    }
    
    func updatePossession(possession: Possession, newName: String, newIsVolatile: Bool, newPool: AssetPool) {
        let context = assetPoolFetchedResultsController.managedObjectContext
        possession.name = newName
        possession.volatile = newIsVolatile
        possession.pool = newPool
        try? context.save()
    }
    
    func deletePossession(possession: Possession) {
        let context = assetPoolFetchedResultsController.managedObjectContext
        context.delete(possession)
        try? context.save()
    }
    
    
    func createAssetPool(named name: String) {
        let context = assetPoolFetchedResultsController.managedObjectContext
        let pool = AssetPool(usedContext: context)
        pool.name = name
        try? context.save()
    }
    
    func updateAssetPool(assetPool: AssetPool, newName: String) {
        let context = assetPoolFetchedResultsController.managedObjectContext
        assetPool.name = newName
        try? context.save()
    }
    
    func deleteAssetPool(assetPool: AssetPool) {
        let context = assetPoolFetchedResultsController.managedObjectContext
        context.delete(assetPool)
        try? context.save()
    }
    
    
    func createReceivableTransaction(
        amount: Decimal,
        date: Date,
        note: String,
        issuer: LoanPartner?,
        receivable: Receivable
    ) {
        let context = receivableTransactionsFetchedResultsController.managedObjectContext
        
        let transaction = LoanTransaction(usedContext: context)
        transaction.amount = amount.nsDecimalNumberValue
        transaction.note = note
        transaction.date = date.startOfDay
        transaction.issuer = issuer
        transaction.emoji = issuer.isNil ? "📤" : "💶"
        transaction.receivable = receivable
        
        try? context.save()
    }
    
    func updateReceivableTransaction(
        transaction: LoanTransaction,
        amount: Decimal,
        date: Date,
        note: String,
        issuer: LoanPartner?,
        receivable: Receivable
    ) {
        let context = receivableTransactionsFetchedResultsController.managedObjectContext
        
        transaction.amount = amount.nsDecimalNumberValue
        transaction.note = note
        transaction.date = date.startOfDay
        transaction.issuer = issuer
        transaction.emoji = issuer.isNil ? "📤" : "💶"
        transaction.receivable = receivable
        
        try? context.save()
    }
}

extension AssetRepository: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == assetPoolFetchedResultsController {
            assetPools = assetPoolFetchedResultsController.fetchedObjects ?? []
        }
        if controller == possessionFetchedResultsController {
            possessions = possessionFetchedResultsController.fetchedObjects ?? []
        }
        if controller == receivableFetchedResultsController {
            receivables = receivableFetchedResultsController.fetchedObjects ?? []
        }
        if controller == receivableTransactionsFetchedResultsController {
            receivableTransactions = receivableTransactionsFetchedResultsController.fetchedObjects ?? []
        }
    }
}
