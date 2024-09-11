
import CoreData


extension AssetPosition {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AssetPosition> {
        return NSFetchRequest<AssetPosition>(entityName: "AssetPosition")
    }

    @NSManaged public var snapshot: Snapshot?

}
