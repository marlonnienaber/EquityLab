import CoreData
import ObservableProperties

class LoanPartnerRepository: NSObject {
    public static let production = LoanPartnerRepository(context: ProductionCoreDataStack.shared.context)
    private let context: NSManagedObjectContext
    private let loanPartnerFetchedResultsController: NSFetchedResultsController<LoanPartner>
    private var observers: [WeakPersonRepositoryObserver]
    
    init(context: NSManagedObjectContext) {
        self.context = context
        
        let request = LoanPartner.fetchRequest()
        request.sortDescriptors = []
        loanPartnerFetchedResultsController = NSFetchedResultsController(request: request, context: context)
        
        observers = []
        super.init()
        
        try? loanPartnerFetchedResultsController.performFetch()
        
        loanPartnerFetchedResultsController.delegate = self
    }
    
    func add(observer: AnyObject) {
        guard !observers.contains(where: { $0.observer === observer }) else { return }
        observers.append(WeakPersonRepositoryObserver(observer: observer))
    }
    
    func getLoanPartners() -> [LoanPartner] {
        loanPartnerFetchedResultsController.fetchedObjects ?? []
    }
    
    func createLoanPartner(with name: String) {
        let loanPartner = LoanPartner(usedContext: context)
        loanPartner.name = name
        try? context.save()
    }
    
    func deleteLoanPartner(_ loanPartner: LoanPartner) {
        context.delete(loanPartner)
        try? context.save()
    }
}

extension LoanPartnerRepository: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        observers = observers.filter { $0.observer.isNotNil }
        for weakObserver in observers {
            if let loanPartnerObserver = weakObserver.observer as? LoanPartnerObserver {
                loanPartnerObserver.notifyAfterLoanPartnerUpdate()
            }
        }
    }
}

protocol LoanPartnerObserver: AnyObject {
    func notifyAfterLoanPartnerUpdate()
}

class WeakPersonRepositoryObserver {
    weak var observer: AnyObject?
    init(observer: AnyObject?) {
        self.observer = observer
    }
}
