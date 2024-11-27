import CoreData
import ObservableProperties

class AssetRepository: NSObject {
    public static let production = AssetRepository(context: ProductionCoreDataStack.shared.context)
    
    private let assetPoolFetchedResultsController: NSFetchedResultsController<AssetPool>
    private let possessionFetchedResultsController: NSFetchedResultsController<Possession>
    private let receivableFetchedResultsController: NSFetchedResultsController<Receivable>
    private let receivableTransactionsFetchedResultsController: NSFetchedResultsController<Transaction>
    private let receivableTransactionSharesFetchedResultsController: NSFetchedResultsController<Share>
    
    @Retriever var assetPools: [AssetPool]
    @Retriever var possessions: [Possession]
    @Retriever var receivables: [Receivable]
    @Retriever var receivableTransactions: [Transaction]
    @Retriever var receivableTransactionShares: [Share]
    
    
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
        
        let transactionRequest = NSFetchRequest<Transaction>(entityName: "Transaction")
        transactionRequest.sortDescriptors = []
        transactionRequest.predicate = NSPredicate(format: "receivable != nil")
        receivableTransactionsFetchedResultsController = .init(fetchRequest: transactionRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        try? receivableTransactionsFetchedResultsController.performFetch()
        
        let transactionShareRequest = NSFetchRequest<Share>(entityName: "Share")
        transactionShareRequest.sortDescriptors = []
        receivableTransactionSharesFetchedResultsController = .init(fetchRequest: transactionShareRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        try? receivableTransactionSharesFetchedResultsController.performFetch()
        
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
        $receivableTransactionShares.toRetrieveDo { [unowned self] in
            (receivableTransactionSharesFetchedResultsController.fetchedObjects ?? []).filter{ $0.transaction?.receivable.isNotNil ?? false }
        }

        assetPoolFetchedResultsController.delegate = self
        possessionFetchedResultsController.delegate = self
        receivableFetchedResultsController.delegate = self
        receivableTransactionsFetchedResultsController.delegate = self
        receivableTransactionSharesFetchedResultsController.delegate = self
    }
    
    
    func createReceivable(name: String,
                          pool: AssetPool,
                          debtor: Person,
                          disbursedAmount: Decimal,
                          grantDate: Date) {
        let context = assetPoolFetchedResultsController.managedObjectContext
        
        let receivable = Receivable(usedContext: context)
        receivable.name = name
        receivable.pool = pool
        receivable.debtor = debtor
        
        let initialTransaction = Transaction(usedContext: context)
        initialTransaction.receivable = receivable
        initialTransaction.amount = disbursedAmount.nsDecimalNumberValue
        initialTransaction.date = grantDate
        initialTransaction.note = "initial disbursement"
        initialTransaction.emoji = "⛽"
        
        /* TODO: implement mechanism for saving user specified distribution */
        let userShare = Share(usedContext: context)
        let userAmount = disbursedAmount / 2
        userShare.transaction = initialTransaction
        userShare.amount = userAmount.nsDecimalNumberValue
        let debtorShare = Share(usedContext: context)
        let debtorAmount = disbursedAmount - userAmount
        debtorShare.transaction = initialTransaction
        debtorShare.amount = debtorAmount.nsDecimalNumberValue
        
        try? context.save()
    }
    
    func updateReceivable(receivable: Receivable,
                          newName: String,
                          newPool: AssetPool,
                          newDebtor: Person) {
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
        if controller == receivableTransactionSharesFetchedResultsController {
            receivableTransactionShares = receivableTransactionSharesFetchedResultsController.fetchedObjects ?? []
        }
    }
}
