import Foundation
import CoreData


extension LoanTransaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LoanTransaction> {
        return NSFetchRequest<LoanTransaction>(entityName: "LoanTransaction")
    }

    @NSManaged public var amount: NSDecimalNumber
    @NSManaged public var date: Date
    @NSManaged public var emoji: String
    @NSManaged public var note: String
    @NSManaged public var issuer: LoanPartner?
    @NSManaged public var liability: Liability?
    @NSManaged public var receivable: Receivable?

}

extension LoanTransaction : Identifiable {

}
