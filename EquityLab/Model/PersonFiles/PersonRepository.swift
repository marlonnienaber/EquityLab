import CoreData
import ObservableProperties

class PersonRepository: NSObject {
    public static let production = PersonRepository(context: ProductionCoreDataStack.shared.context)
    private let fetchedResultsController: NSFetchedResultsController<Person>
    
    @Retriever var persons: [Person]
    
    init(context: NSManagedObjectContext) {
        let request = NSFetchRequest<Person>(entityName: "Person")
        request.sortDescriptors = []
        fetchedResultsController = .init(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        try? fetchedResultsController.performFetch()
        
        super.init()
        
        $persons.toRetrieveDo{ [unowned self] in
            fetchedResultsController.fetchedObjects ?? .defaultValue
        }
        
        fetchedResultsController.delegate = self
    }
    
    func createPerson(with name: String) {
        let context = fetchedResultsController.managedObjectContext
        let person = Person(usedContext: context)
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
        persons = fetchedResultsController.fetchedObjects ?? .defaultValue
    }
}
