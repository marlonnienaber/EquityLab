
import CoreData


extension LiabilityPosition {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LiabilityPosition> {
        return NSFetchRequest<LiabilityPosition>(entityName: "LiabilityPosition")
    }

    @NSManaged public var snapshot: Snapshot?

}
