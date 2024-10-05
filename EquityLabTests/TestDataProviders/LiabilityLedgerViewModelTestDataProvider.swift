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

        
        let expectedLiabilityPools = [liabilityPool1,liabilityPool2]
        var poolToLiabilitiesDictionary = [LiabilityPool:[Liability]]()
        poolToLiabilitiesDictionary[liabilityPool1] = [liability1, liability2]
        poolToLiabilitiesDictionary[liabilityPool2] = [liability3]
        let expectedLiabilities = [liability1,liability2,liability3]
        return (expectedLiabilityPools,poolToLiabilitiesDictionary,expectedLiabilities)
    }
    
    func createAndPersistTestObjects_liabilitiesAndPools_2(using context: NSManagedObjectContext) -> ([LiabilityPool], [LiabilityPool: [Liability]], [Liability]) {
        let liabilityPoolName1 = "Privat"
        let liabilityPool1 = DataFactory.createLiabilityPool(named: liabilityPoolName1, liabilities: [], in: context)

        let expectedLiabilityPools = [liabilityPool1]
        var poolToLiabilityDictionary = [LiabilityPool: [Liability]]()
        poolToLiabilityDictionary[liabilityPool1] = []
        let expectedLiabilities = [Liability]()
        
        return (expectedLiabilityPools, poolToLiabilityDictionary, expectedLiabilities)
    }
    
    func createAndPersistTestObjects_deleteLiabilities_1(using context: NSManagedObjectContext) -> (LiabilityPool,[LiabilityPool],[LiabilityPool:[Liability]],[Liability]) {
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

        
        let expectedLiabilityPools = [liabilityPool1,liabilityPool2]
        var poolToLiabilitiesDictionary = [LiabilityPool:[Liability]]()
        poolToLiabilitiesDictionary[liabilityPool1] = [liability1]
        poolToLiabilitiesDictionary[liabilityPool2] = [liability3]
        let expectedLiabilities = [liability1,liability3]
        return (liabilityPool1,expectedLiabilityPools,poolToLiabilitiesDictionary,expectedLiabilities)
    }
    
    func createAndPersistTestObjects_deleteLiabilityPool_1(using context: NSManagedObjectContext) -> (LiabilityPool,[LiabilityPool],[LiabilityPool:[Liability]],[Liability]) {
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

        
        let expectedLiabilityPools = [liabilityPool2]
        var poolToLiabilitiesDictionary = [LiabilityPool:[Liability]]()
        poolToLiabilitiesDictionary[liabilityPool2] = [liability3]
        let expectedLiabilities = [liability3]
        return (liabilityPool1,expectedLiabilityPools,poolToLiabilitiesDictionary,expectedLiabilities)
    }
    
    func createAndPersistTestObjects_updateLiabilityPool_1(using context: NSManagedObjectContext) -> (LiabilityPool,[String],[String:[Liability]],[Liability]) {
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
        
        let expectedLiabilityPoolNames = ["Familie",liabilityPoolName2]
        var poolToLiabilityDictionary = [String:[Liability]]()
        poolToLiabilityDictionary["Familie"] = [liability1,liability2]
        poolToLiabilityDictionary[liabilityPoolName2] = [liability3]
        let expectedLiabilities = [liability1,liability2,liability3]
        return (liabilityPool1,expectedLiabilityPoolNames,poolToLiabilityDictionary,expectedLiabilities)
    }
}
