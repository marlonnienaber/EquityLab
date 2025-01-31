@testable import EquityLab
import CoreData

struct LoanPartnerSelectionViewModelTestDataProvider {
    
    func createAndPersistTestObjects_createLoanPartnerOccupiedName(context: NSManagedObjectContext) -> String {
        let occupiedName = "Marlon"
        let _ = DataFactory.createLoanPartner(name: occupiedName, context: context)
        return occupiedName
    }
    
    func createAndPersistTestObjects_deleteLoanPartner(context: NSManagedObjectContext) {
        let _ = DataFactory.createLoanPartner(name: "Marlon", context: context)
    }
    
    func createAndPersistTestObjects_deleteUndeletableLoanPartner(context: NSManagedObjectContext) {
        let person1 = DataFactory.createLoanPartner(name: "Lenni", context: context)
        let receivable1FirstTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
            amount: 100,
            note: "disbursed amount",
            emoji: "📤",
            context: context
        )
        let receivable1SecondTransaction = DataFactory.createLoanTransaction(
            issuer: person1,
            date: DateParser.shared.date(from: "2024-04-17T00:00:00")!,
            amount: 20,
            note: "repayment",
            emoji: "💶",
            context: context
        )
        let asset1 = DataFactory.createReceivable(
            name: "Lenni",
            debtor: person1,
            transactions: [receivable1FirstTransaction,receivable1SecondTransaction],
            context: context
        )
    }
    
}
