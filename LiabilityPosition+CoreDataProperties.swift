import Foundation
import CoreData


extension LiabilityPosition {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LiabilityPosition> {
        return NSFetchRequest<LiabilityPosition>(entityName: "LiabilityPosition")
    }

    @NSManaged public var name: String
    @NSManaged public var poolName: String
    @NSManaged public var value: Double
    @NSManaged public var snapshot: Snapshot?

}

extension LiabilityPosition : Identifiable {

}
