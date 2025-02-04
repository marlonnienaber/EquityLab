import CoreData

/// necessary for working with CoreData
public extension NSManagedObject {
    convenience init(usedContext: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: usedContext)!
        self.init(entity: entity, insertInto: usedContext)
    }
    
    static func retrieveInstances<EntityType: NSManagedObject>(via context: NSManagedObjectContext) -> [EntityType] {
        let request = NSFetchRequest<EntityType>(entityName: String(describing: self))
        
        do {
            return try context.fetch(request)
        } catch {
            return []
        }
    }
}
