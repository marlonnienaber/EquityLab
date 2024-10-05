@testable import EquityLab
import CoreData

struct LiabilityLedgerViewModelTestDataProvider {
    func createAndPersistTestObjects_liabilitiesAndPools_1(using context: NSManagedObjectContext) -> ([LiabilityPool],[LiabilityPool:[Liability]],[Liability]) {
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

        
        let expectedAssetPools = [liabilityPool1,liabilityPool2]
        var poolToLiabilitiesDictionary = [LiabilityPool:[Liability]]()
        poolToLiabilitiesDictionary[liabilityPool1] = [liability1, liability2]
        poolToLiabilitiesDictionary[liabilityPool2] = [liability3]
        let expectedLiabilities = [liability1,liability2,liability3]
        return (expectedAssetPools,poolToLiabilitiesDictionary,expectedLiabilities)
    }
}
