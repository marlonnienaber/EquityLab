@testable import EquityLab
import CoreData

struct LoanPartnerSelectionViewModelTestDataProvider {
    
    func createAndPersistTestObjects_createLoanPartnerOccupiedName(context: NSManagedObjectContext) -> String {
        let occupiedName = "Marlon"
        let partner = LoanPartner(usedContext: context)
        partner.name = occupiedName
        try? context.save()
        return occupiedName
    }
    
}
