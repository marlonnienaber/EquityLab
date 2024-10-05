@testable import EquityLab
import CoreData

struct LiabilityFormViewModelTestDataProvider {
    func createAndPersistTestObjects_createLiability_1(context: NSManagedObjectContext) -> LiabilityPool {
        DataFactory.createLiabilityPool(named: "Privat", liabilities: [], in: context)
    }
    
    func createAndPersistTestObjects_updateLiability_1(context: NSManagedObjectContext) -> Liability {
        let initialName = "Auto"
        let initialDate = DateParser.shared.date(from: "2024-04-15T00:00:00")!
        let initialCreditor = "Papa"
        let initialInitialAmount = 1000.0
        let initialRepaidAmount = 200.0
        
        let liability = DataFactory.createLiability(name: initialName,
                                    date: initialDate,
                                    creditor: initialCreditor,
                                    initialAmount: initialInitialAmount,
                                    repaidAmount: initialRepaidAmount,
                                    context: context)
        
        
        return liability
    }
}
