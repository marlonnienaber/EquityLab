import Foundation
import CoreData


extension Liability {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Liability> {
        return NSFetchRequest<Liability>(entityName: "Liability")
    }

    @NSManaged public var creditor: String
    @NSManaged public var grantDate: Date
    @NSManaged public var initialAmount: NSDecimalNumber
    @NSManaged public var name: String
    @NSManaged public var repaidAmount: NSDecimalNumber
    @NSManaged public var pool: LiabilityPool?

}

extension Liability : Identifiable {

}
