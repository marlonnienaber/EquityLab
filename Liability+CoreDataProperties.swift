import Foundation
import CoreData


extension Liability {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Liability> {
        return NSFetchRequest<Liability>(entityName: "Liability")
    }

    @NSManaged public var grantDate: Date
    @NSManaged public var initialAmount: Double
    @NSManaged public var name: String
    @NSManaged public var repaidAmount: Double
    @NSManaged public var pool: LiabilityPool?
    @NSManaged public var creditor: Person?

}

extension Liability : Identifiable {

}
