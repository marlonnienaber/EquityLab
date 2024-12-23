import CoreData
import ObservableProperties

class PersonRepository: NSObject {
    public static let production = PersonRepository(context: ProductionCoreDataStack.shared.context)
    private let fetchedResultsController: NSFetchedResultsController<LoanPartner>
    private var observers: [WeakPersonObserver]
    
    init(context: NSManagedObjectContext) {
        let request = NSFetchRequest<LoanPartner>(entityName: "LoanPartner")
        request.sortDescriptors = []
        fetchedResultsController = .init(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        try? fetchedResultsController.performFetch()
        observers = []
        super.init()
        fetchedResultsController.delegate = self
    }
    
    func add(observer: PersonObserver) {
        guard !observers.contains(where: { $0.observer === observer }) else { return }
        observers.append(WeakPersonObserver(observer: observer))
    }
    
    func fetchPersons() -> [LoanPartner] {
        fetchedResultsController.fetchedObjects ?? []
    }
    
    func createPerson(with name: String) {
        let context = fetchedResultsController.managedObjectContext
        let person = LoanPartner(usedContext: context)
        person.name = name
        try? context.save()
    }
    
    /* TODO: ensure consistency of models -> only delete if all relationships allow for it! */
//    func deletePerson(person: Person) {
//        let context = fetchedResultsController.managedObjectContext
//        context.delete(person)
//        try? context.save()
//    }
}

extension PersonRepository: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        observers = observers.filter { $0.observer.isNotNil }
        observers.forEach{ $0.observer?.notifyAfterPersonUpdate()}
    }
}

protocol PersonObserver: AnyObject {
    /* TODO: will this create a retain cycle or other memory problems */
    func notifyAfterPersonUpdate()
}

class WeakPersonObserver {
    weak var observer: PersonObserver?
    init(observer: PersonObserver?) {
        self.observer = observer
    }
}
