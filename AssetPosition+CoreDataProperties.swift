import Foundation
import CoreData


extension AssetPosition {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AssetPosition> {
        return NSFetchRequest<AssetPosition>(entityName: "AssetPosition")
    }

    @NSManaged public var name: String
    @NSManaged public var poolName: String
    @NSManaged public var value: Double
    @NSManaged public var snapshot: Snapshot?

}

extension AssetPosition : Identifiable {

}
