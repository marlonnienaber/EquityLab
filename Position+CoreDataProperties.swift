
import CoreData


extension Position {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Position> {
        return NSFetchRequest<Position>(entityName: "Position")
    }

    @NSManaged public var name: String
    @NSManaged public var poolName: String
    @NSManaged public var value: Double

}

extension Position : Identifiable {

}
