import Foundation
import CoreData


extension Receivable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Receivable> {
        return NSFetchRequest<Receivable>(entityName: "Receivable")
    }

    @NSManaged public var debtor: String
    @NSManaged public var grantDate: Date
    @NSManaged public var initialAmount: Double
    @NSManaged public var repaidAmount: Double
    @NSManaged public var name: String
    @NSManaged public var pool: AssetPool?

}

extension Receivable : Identifiable {

}
