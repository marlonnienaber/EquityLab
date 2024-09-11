
import CoreData


extension Possession {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Possession> {
        return NSFetchRequest<Possession>(entityName: "Possession")
    }

    @NSManaged public var volatile: Bool

}
