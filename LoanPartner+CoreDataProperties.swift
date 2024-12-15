import Foundation
import CoreData


extension LoanPartner {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LoanPartner> {
        return NSFetchRequest<LoanPartner>(entityName: "LoanPartner")
    }

    @NSManaged public var name: String?
    @NSManaged public var transactions: LoanTransaction?
    @NSManaged public var liabilities: Liability?
    @NSManaged public var receivables: Receivable?

}

extension LoanPartner : Identifiable {

}
