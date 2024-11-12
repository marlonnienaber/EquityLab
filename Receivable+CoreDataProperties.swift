import Foundation
import CoreData


extension Receivable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Receivable> {
        return NSFetchRequest<Receivable>(entityName: "Receivable")
    }

    @NSManaged public var grantDate: Date
    @NSManaged public var initialAmount: Double
    @NSManaged public var name: String
    @NSManaged public var repaidAmount: Double
    @NSManaged public var pool: AssetPool?
    @NSManaged public var debtor: Person?

}

extension Receivable : Identifiable {

}
