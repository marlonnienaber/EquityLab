import Foundation
import CoreData


extension Share {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Share> {
        return NSFetchRequest<Share>(entityName: "Share")
    }

    @NSManaged public var amount: NSDecimalNumber
    @NSManaged public var transaction: Transaction?
    @NSManaged public var shareHolder: Person?

}

extension Share : Identifiable {

}
