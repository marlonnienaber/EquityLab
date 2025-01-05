import CoreData

extension NSFetchedResultsController {
    @objc convenience init(request: NSFetchRequest<ResultType>, context: NSManagedObjectContext) {
        self.init(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }
}
