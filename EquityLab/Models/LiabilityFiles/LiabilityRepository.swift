import CoreData
import ObservableProperties

class LiabilityRepository: NSObject {
    public static let production = LiabilityRepository(context: ProductionCoreDataStack.shared.context)
    
    private let liabilityPoolFetchedResultsController: NSFetchedResultsController<LiabilityPool>
    private let liabilityFetchedResultsController: NSFetchedResultsController<Liability>
    private let liabilityTransactionFetchedResultsController: NSFetchedResultsController<LoanTransaction>
    
    @Retriever var liabilityPools: [LiabilityPool]
    @Retriever var liabilities: [Liability]
    @Retriever var liabilityTransactions: [LoanTransaction]
    
    
    init(context: NSManagedObjectContext) {
        let liabilityPoolRequest = NSFetchRequest<LiabilityPool>(entityName: "LiabilityPool")
        liabilityPoolRequest.sortDescriptors = []
        liabilityPoolFetchedResultsController = .init(fetchRequest: liabilityPoolRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        try? liabilityPoolFetchedResultsController.performFetch()
        
        let liabilityRequest = NSFetchRequest<Liability>(entityName: "Liability")
        liabilityRequest.sortDescriptors = []
        liabilityFetchedResultsController = .init(fetchRequest: liabilityRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        try? liabilityFetchedResultsController.performFetch()
        
        let liabilityTransactionRequest = NSFetchRequest<LoanTransaction>(entityName: "LoanTransaction")
        liabilityTransactionRequest.sortDescriptors = []
        liabilityTransactionFetchedResultsController = .init(fetchRequest: liabilityTransactionRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        try? liabilityTransactionFetchedResultsController.performFetch()
        
        super.init()
        
        $liabilityPools.toRetrieveDo { [unowned self] in
            liabilityPoolFetchedResultsController.fetchedObjects ?? .defaultValue
        }
        $liabilities.toRetrieveDo { [unowned self] in
            liabilityFetchedResultsController.fetchedObjects ?? .defaultValue
        }
        $liabilityTransactions.toRetrieveDo { [unowned self] in
            liabilityTransactionFetchedResultsController.fetchedObjects ?? .defaultValue
        }
        
        liabilityPoolFetchedResultsController.delegate = self
        liabilityFetchedResultsController.delegate = self
        liabilityTransactionFetchedResultsController.delegate = self
    }
    
    
    func createLiabilityPool(named name: String) {
        let context = liabilityPoolFetchedResultsController.managedObjectContext
        let pool = LiabilityPool(context: context)
        pool.name = name
        try? context.save()
    }
    
    func updateLiabilityPool(liabilityPool: LiabilityPool, newName: String) {
        let context = liabilityPoolFetchedResultsController.managedObjectContext
        liabilityPool.name = newName
        try? context.save()
    }
    
    func deleteLiabilityPool(liabilityPool: LiabilityPool) {
        let context = liabilityPoolFetchedResultsController.managedObjectContext
        context.delete(liabilityPool)
        try? context.save()
    }
    
    
    func createLiability(name: String,
                         pool: LiabilityPool,
                         creditor: LoanPartner,
                         disbursedAmount: Decimal,
                         grantDate: Date) {
        let context = liabilityFetchedResultsController.managedObjectContext
        
        let liability = Liability(usedContext: context)
        liability.creditor = creditor
        liability.name = name
        liability.pool = pool
        
        let initialTransaction = LoanTransaction(usedContext: context)
        initialTransaction.issuer = creditor
        initialTransaction.liability = liability
        initialTransaction.amount = disbursedAmount.nsDecimalNumberValue
        initialTransaction.date = grantDate
        initialTransaction.note = "initial disbursement"
        try? context.save()
    }
    
    func updateLiability(liability: Liability,
                         newName: String,
                         newPool: LiabilityPool,
                         newCreditor: LoanPartner) {
        let context = liabilityFetchedResultsController.managedObjectContext
        liability.name = newName
        liability.pool = newPool
        if liability.creditor != newCreditor {
            liability.creditor = newCreditor
            let transactions = liabilityTransactions.filter{ $0.liability == liability && $0.issuer.isNotNil }
            transactions.forEach{ $0.issuer = newCreditor }
        }
        try? context.save()
    }
    
    func deleteLiability(liability: Liability) {
        let context = liabilityFetchedResultsController.managedObjectContext
        context.delete(liability)
        try? context.save()
    }
}

extension LiabilityRepository: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == liabilityPoolFetchedResultsController {
            liabilityPools = liabilityPoolFetchedResultsController.fetchedObjects ?? .defaultValue
        }
        if controller == liabilityFetchedResultsController {
            liabilities = liabilityFetchedResultsController.fetchedObjects ?? .defaultValue
        }
        if controller == liabilityTransactionFetchedResultsController {
            liabilityTransactions = liabilityTransactionFetchedResultsController.fetchedObjects ?? .defaultValue
        }
    }
}



