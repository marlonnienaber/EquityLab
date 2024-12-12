@testable import EquityLab
import CoreData

struct LiabilityFormViewModelTestDataProvider {
    func createAndPersistTestObjects_getLiabilityPools_1(using context: NSManagedObjectContext) -> [LiabilityPool] {
        let liability1 = DataFactory.createLiability(name: "Auto",
                                                     date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
                                                     creditor: "Papa",
                                                     initialAmount: 1000.0,
                                                     repaidAmount: 100.0,
                                                     context: context)
        let liability2 = DataFactory.createLiability(name: "Booth",
                                                     date: DateParser.shared.date(from: "2024-09-15T00:00:00")!,
                                                     creditor: "Mama",
                                                     initialAmount: 300.0,
                                                     repaidAmount: 50.0,
                                                     context: context)
        let liability3 = DataFactory.createLiability(name: "Studium",
                                                     date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
                                                     creditor: "Bayerische Landesregierung",
                                                     initialAmount: 5000.0,
                                                     repaidAmount: 1300.0,
                                                     context: context)
        
        let liabilityPoolName1 = "Privat"
        let liabilityPoolName2 = "Staatlich"
        let liabilityPool1 = DataFactory.createLiabilityPool(named: liabilityPoolName1, liabilities: [liability1,liability2], in: context)
        let liabilityPool2 = DataFactory.createLiabilityPool(named: liabilityPoolName2, liabilities: [liability3], in: context)

        
        return [liabilityPool1,liabilityPool2]
    }
    
    func createAndPersistTestObjects_createLiability_1(context: NSManagedObjectContext) -> LiabilityPool {
        DataFactory.createLiabilityPool(named: "Privat", liabilities: [], in: context)
    }
    
    func createAndPersistTestObjects_updateLiability_1(context: NSManagedObjectContext) -> Liability {
        let initialName = "Auto"
        let initialDate = DateParser.shared.date(from: "2024-04-15T00:00:00")!
        let initialCreditor = "Papa"
        let initialInitialAmount: Decimal = 1000.0
        let initialRepaidAmount: Decimal = 200.0
        
        let liability = DataFactory.createLiability(name: initialName,
                                    date: initialDate,
                                    creditor: initialCreditor,
                                    initialAmount: initialInitialAmount,
                                    repaidAmount: initialRepaidAmount,
                                    context: context)
        
        let _ = DataFactory.createLiabilityPool(named: "Privat", liabilities: [liability], in: context)
        
        return liability
    }
    
    func createAndPersistTestObjects_deleteLiabilities_1(using context: NSManagedObjectContext) -> (Liability,[Liability]) {
        let liability1 = DataFactory.createLiability(name: "Auto",
                                                     date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
                                                     creditor: "Papa",
                                                     initialAmount: 1000.0,
                                                     repaidAmount: 100.0,
                                                     context: context)
        let liability2 = DataFactory.createLiability(name: "Booth",
                                                     date: DateParser.shared.date(from: "2024-09-15T00:00:00")!,
                                                     creditor: "Mama",
                                                     initialAmount: 300.0,
                                                     repaidAmount: 50.0,
                                                     context: context)
        let liability3 = DataFactory.createLiability(name: "Studium",
                                                     date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
                                                     creditor: "Bayerische Landesregierung",
                                                     initialAmount: 5000.0,
                                                     repaidAmount: 1300.0,
                                                     context: context)
        
        let expectedLiabilities = [liability2,liability3]
        return (liability1,expectedLiabilities)
    }
}
