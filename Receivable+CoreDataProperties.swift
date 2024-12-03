import Foundation
import CoreData


extension Receivable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Receivable> {
        return NSFetchRequest<Receivable>(entityName: "Receivable")
    }

    @NSManaged public var debtor: String
    @NSManaged public var grantDate: Date
    @NSManaged public var initialAmount: NSDecimalNumber
    @NSManaged public var repaidAmount: NSDecimalNumber

}
