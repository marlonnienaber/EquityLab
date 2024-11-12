import CoreData
import ObservableProperties

class PersonRepository: NSObject {
    public static let production = PersonRepository(context: ProductionCoreDataStack.shared.context)
    private let fetchedResultsController: NSFetchedResultsController<Person>
    @Publisher var persons: [Person]
    
    init(context: NSManagedObjectContext) {
        let request = NSFetchRequest<Person>(entityName: "Person")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \AssetPool.name, ascending: true)]
        fetchedResultsController = .init(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        try? fetchedResultsController.performFetch()
        self.persons = fetchedResultsController.fetchedObjects ?? []
        super.init()
        fetchedResultsController.delegate = self
    }
    
    func createPerson(with name: String) {
        let context = fetchedResultsController.managedObjectContext
        let person = Person(usedContext: context)
        person.name = name
        try? context.save()
    }
    
    func delete(person: Person) {
        let context = fetchedResultsController.managedObjectContext
        context.delete(person)
        try? context.save()
    }
}

extension PersonRepository: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        persons = fetchedResultsController.fetchedObjects ?? []
    }
}
