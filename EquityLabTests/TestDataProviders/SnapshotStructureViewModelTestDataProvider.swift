@testable import EquityLab
import CoreData

struct SnapshotStructureViewModelTestDataProvider {
    func createAndPersistTestObjects_assetsAndPools_1(using context: NSManagedObjectContext) -> ([AssetPool],[AssetPool:[SnapshotStructureItem]]) {
        let name1 = "Blitz"
        let person1 = DataFactory.createLoanPartner(name: "Lenni", context: context)
        let receivable1FirstTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
            amount: 20,
            note: "disbursed amount",
            emoji: "📤",
            context: context
        )
        let asset1 = DataFactory.createReceivable(
            name: name1,
            debtor: person1,
            transactions: [receivable1FirstTransaction],
            context: context
        )
        let asset2 = DataFactory.createPossession(name: "Geldbeutel", volatile: true, context: context)
        let asset3 = DataFactory.createPossession(name: "Konto Sparkasse", volatile: true, context: context)
        let asset4 = DataFactory.createPossession(name: "Konto Commerzbank", volatile: true, context: context)
        let asset5 = DataFactory.createPossession(name: "Depot FNZ", volatile: true, context: context)
        
        let assetPoolName1 = "Bargeld"
        let assetPoolName2 = "Bank"
        let assetPoolName3 = "Wertpapiere"
        let assetPoolName4 = "Geliehen"
        let assetPool1 = DataFactory.createAssetPool(named: assetPoolName1, possessions: [asset2], receivables: [], in: context)
        let assetPool2 = DataFactory.createAssetPool(named: assetPoolName2, possessions: [asset3,asset4], receivables: [], in: context)
        let assetPool3 = DataFactory.createAssetPool(named: assetPoolName3, possessions: [asset5], receivables: [], in: context)
        let assetPool4 = DataFactory.createAssetPool(named: assetPoolName4,  possessions: [], receivables: [asset1], in: context)
        
        let expectedAssetPools = [assetPool1,assetPool2,assetPool3,assetPool4]
        var poolToAssetDictionary = [AssetPool:[SnapshotStructureItem]]()
        poolToAssetDictionary[assetPool1] = [asset2]
        poolToAssetDictionary[assetPool2] = [asset3,asset4]
        poolToAssetDictionary[assetPool3] = [asset5]
        poolToAssetDictionary[assetPool4] = [asset1]
        let expectedAssets: [SnapshotStructureItem] = [asset1,asset2,asset3,asset4,asset5]
        return (expectedAssetPools,poolToAssetDictionary)
    }
    
    func createAndPersistTestObjects_assetsAndPools_2(using context: NSManagedObjectContext) -> ([AssetPool],[AssetPool:[SnapshotStructureItem]]) {
        let assetPoolName1 = "Bargeld"
        let assetPool1 = DataFactory.createAssetPool(named: assetPoolName1, possessions: [], receivables: [], in: context)
 

        
        let expectedAssetPools = [assetPool1]
        var poolToAssetDictionary = [AssetPool:[SnapshotStructureItem]]()
        poolToAssetDictionary[assetPool1] = []
        let expectedAssets = [SnapshotStructureItem]()
        return (expectedAssetPools,poolToAssetDictionary)
    }
    
    func createAndPersistTestObjects_liabilitiesAndPools_1(using context: NSManagedObjectContext) -> ([LiabilityPool],[LiabilityPool:[Liability]]) {
        let person1 = DataFactory.createLoanPartner(name: "Papa", context: context)
        let liability1FirstTransaction = DataFactory.createLoanTransaction(
            issuer: person1,
            date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
            amount: 1000,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liability1SecondTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-04-17T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liability1 = DataFactory.createLiability(
            name: "Auto",
            creditor: person1,
            transactions: [liability1FirstTransaction, liability1SecondTransaction],
            context: context
        )
        
        let person2 = DataFactory.createLoanPartner(name: "Mama", context: context)
        let liability2FirstTransaction = DataFactory.createLoanTransaction(
            issuer: person2,
            date: DateParser.shared.date(from: "2024-09-15T00:00:00")!,
            amount: 300,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liability2SecondTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-09-17T00:00:00")!,
            amount: 50,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liability2 = DataFactory.createLiability(
            name: "Booth",
            creditor: person2,
            transactions: [liability2FirstTransaction, liability2SecondTransaction],
            context: context
        )
        
        let person3 = DataFactory.createLoanPartner(name: "Mama", context: context)
        let liability3FirstTransaction = DataFactory.createLoanTransaction(
            issuer: person3,
            date: DateParser.shared.date(from: "2024-05-15T00:00:00")!,
            amount: 5000,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liability3SecondTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-05-17T00:00:00")!,
            amount: 1300,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liability3 = DataFactory.createLiability(
            name: "Studium",
            creditor: person3,
            transactions: [liability3FirstTransaction, liability3SecondTransaction],
            context: context
        )
        
        let liabilityPoolName1 = "Privat"
        let liabilityPoolName2 = "Staatlich"
        let liabilityPool1 = DataFactory.createLiabilityPool(named: liabilityPoolName1, liabilities: [liability1,liability2], in: context)
        let liabilityPool2 = DataFactory.createLiabilityPool(named: liabilityPoolName2, liabilities: [liability3], in: context)

        
        let expectedLiabilityPools = [liabilityPool1,liabilityPool2]
        var poolToLiabilitiesDictionary = [LiabilityPool:[Liability]]()
        poolToLiabilitiesDictionary[liabilityPool1] = [liability1, liability2]
        poolToLiabilitiesDictionary[liabilityPool2] = [liability3]
        let expectedLiabilities = [liability1,liability2,liability3]
        return (expectedLiabilityPools,poolToLiabilitiesDictionary)
    }
    
    func createAndPersistTestObjects_liabilitiesAndPools_2(using context: NSManagedObjectContext) -> ([LiabilityPool], [LiabilityPool: [Liability]]) {
        let liabilityPoolName1 = "Privat"
        let liabilityPool1 = DataFactory.createLiabilityPool(named: liabilityPoolName1, liabilities: [], in: context)

        let expectedLiabilityPools = [liabilityPool1]
        var poolToLiabilityDictionary = [LiabilityPool: [Liability]]()
        poolToLiabilityDictionary[liabilityPool1] = []
        let expectedLiabilities = [Liability]()
        
        return (expectedLiabilityPools, poolToLiabilityDictionary)
    }
    
    
    
    func createAndPersistTestObjects_createAssetPool_2(using context: NSManagedObjectContext) -> String {
        let occupiedName = "Private"
        let _ = DataFactory.createAssetPool(named: occupiedName, possessions: [], receivables: [], in: context)
        return occupiedName
    }
    
    func createAndPersistTestObjects_updateAssetPool_1(using context: NSManagedObjectContext) -> (AssetPool,[String],[String:[SnapshotStructureItem]]) {
        let name1 = "Blitz"
        let person1 = DataFactory.createLoanPartner(name: "Lenni", context: context)
        let receivable1FirstTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
            amount: 20,
            note: "disbursed amount",
            emoji: "📤",
            context: context
        )
        let asset1 = DataFactory.createReceivable(
            name: name1,
            debtor: person1,
            transactions: [receivable1FirstTransaction],
            context: context
        )
        let asset2 = DataFactory.createPossession(name: "Geldbeutel", volatile: true, context: context)
        let asset3 = DataFactory.createPossession(name: "Konto Sparkasse", volatile: true, context: context)
        let asset4 = DataFactory.createPossession(name: "Konto Commerzbank", volatile: true, context: context)
        let asset5 = DataFactory.createPossession(name: "Depot FNZ", volatile: true, context: context)
        
        let assetPoolName1 = "Bargeld"
        let assetPoolName2 = "Bank"
        let assetPoolName3 = "Wertpapiere"
        let assetPoolName4 = "Geliehen"
        let assetPool1 = DataFactory.createAssetPool(named: assetPoolName1, possessions: [asset2], receivables: [], in: context)
        let assetPool2 = DataFactory.createAssetPool(named: assetPoolName2, possessions: [asset3,asset4], receivables: [], in: context)
        let assetPool3 = DataFactory.createAssetPool(named: assetPoolName3, possessions: [asset5], receivables: [], in: context)
        let assetPool4 = DataFactory.createAssetPool(named: assetPoolName4,  possessions: [], receivables: [asset1], in: context)
        
        let expectedAssetPoolNames = ["Cash",assetPoolName2,assetPoolName3,assetPoolName4]
        var poolToAssetDictionary = [String:[SnapshotStructureItem]]()
        poolToAssetDictionary["Cash"] = [asset2]
        poolToAssetDictionary[assetPoolName2] = [asset3,asset4]
        poolToAssetDictionary[assetPoolName3] = [asset5]
        poolToAssetDictionary[assetPoolName4] = [asset1]
        return (assetPool1,expectedAssetPoolNames,poolToAssetDictionary)
    }
    
    func createAndPersistTestObjects_updateAssetPool_2(using context: NSManagedObjectContext) -> (AssetPool,String) {
        let occupiedName = "Private"
        let _ = DataFactory.createAssetPool(named: occupiedName, possessions: [], receivables: [], in: context)
        let otherName = "Staatlich"
        let assetPoolToUpdate = DataFactory.createAssetPool(named: otherName, possessions: [], receivables: [], in: context)
        return (assetPoolToUpdate,occupiedName)
    }
    
    func createAndPersistTestObjects_updateAssetPool_3(using context: NSManagedObjectContext) -> AssetPool {
        DataFactory.createAssetPool(named: "Private", possessions: [], receivables: [], in: context)
    }
    
    func createAndPersistTestObjects_deleteAssetPool_1(using context: NSManagedObjectContext) -> (AssetPool,[AssetPool],[AssetPool:[SnapshotStructureItem]]) {
        let name1 = "Blitz"
        let person1 = DataFactory.createLoanPartner(name: "Lenni", context: context)
        let receivable1FirstTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
            amount: 20,
            note: "disbursed amount",
            emoji: "📤",
            context: context
        )
        let asset1 = DataFactory.createReceivable(
            name: name1,
            debtor: person1,
            transactions: [receivable1FirstTransaction],
            context: context
        )
        let asset2 = DataFactory.createPossession(name: "Geldbeutel", volatile: true, context: context)
        let asset3 = DataFactory.createPossession(name: "Konto Sparkasse", volatile: true, context: context)
        let asset4 = DataFactory.createPossession(name: "Konto Commerzbank", volatile: true, context: context)
        let asset5 = DataFactory.createPossession(name: "Depot FNZ", volatile: true, context: context)
        
        let assetPoolName1 = "Bargeld"
        let assetPoolName2 = "Bank"
        let assetPoolName3 = "Wertpapiere"
        let assetPoolName4 = "Geliehen"
        let assetPool1 = DataFactory.createAssetPool(named: assetPoolName1, possessions: [asset2], receivables: [], in: context)
        let assetPool2 = DataFactory.createAssetPool(named: assetPoolName2, possessions: [asset3,asset4], receivables: [], in: context)
        let assetPool3 = DataFactory.createAssetPool(named: assetPoolName3, possessions: [asset5], receivables: [], in: context)
        let assetPool4 = DataFactory.createAssetPool(named: assetPoolName4,  possessions: [], receivables: [asset1], in: context)
        
        let expectedAssetPools = [assetPool1,assetPool3,assetPool4]
        var poolToAssetDictionary = [AssetPool:[SnapshotStructureItem]]()
        poolToAssetDictionary[assetPool1] = [asset2]
        poolToAssetDictionary[assetPool3] = [asset5]
        poolToAssetDictionary[assetPool4] = [asset1]
        return (assetPool2,expectedAssetPools,poolToAssetDictionary)
    }
    
    
    
    func createAndPersistTestObjects_createLiabilityPool_2(using context: NSManagedObjectContext) -> String {
        let occupiedName = "Private"
        let _ = DataFactory.createLiabilityPool(named: occupiedName, liabilities: [], in: context)
        return occupiedName
    }
    
    func createAndPersistTestObjects_updateLiabilityPool_1(using context: NSManagedObjectContext) -> (LiabilityPool,[String],[String:[Liability]]) {
        let person1 = DataFactory.createLoanPartner(name: "Papa", context: context)
        let liability1FirstTransaction = DataFactory.createLoanTransaction(
            issuer: person1,
            date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
            amount: 1000,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liability1SecondTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-04-17T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liability1 = DataFactory.createLiability(
            name: "Auto",
            creditor: person1,
            transactions: [liability1FirstTransaction, liability1SecondTransaction],
            context: context
        )
        
        let person2 = DataFactory.createLoanPartner(name: "Mama", context: context)
        let liability2FirstTransaction = DataFactory.createLoanTransaction(
            issuer: person1,
            date: DateParser.shared.date(from: "2024-09-15T00:00:00")!,
            amount: 300,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liability2SecondTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-09-17T00:00:00")!,
            amount: 50,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liability2 = DataFactory.createLiability(
            name: "Booth",
            creditor: person1,
            transactions: [liability2FirstTransaction, liability2SecondTransaction],
            context: context
        )
        
        let person3 = DataFactory.createLoanPartner(name: "Bayerische Landesregierung", context: context)
        let liability3FirstTransaction = DataFactory.createLoanTransaction(
            issuer: person3,
            date: DateParser.shared.date(from: "2024-05-15T00:00:00")!,
            amount: 5000,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liability3SecondTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-05-19T00:00:00")!,
            amount: 1300,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liability3 = DataFactory.createLiability(
            name: "Booth",
            creditor: person3,
            transactions: [liability3FirstTransaction, liability3SecondTransaction],
            context: context
        )
        
        let liabilityPoolName1 = "Privat"
        let liabilityPoolName2 = "Staatlich"
        let liabilityPool1 = DataFactory.createLiabilityPool(named: liabilityPoolName1, liabilities: [liability1,liability2], in: context)
        let liabilityPool2 = DataFactory.createLiabilityPool(named: liabilityPoolName2, liabilities: [liability3], in: context)
        
        let expectedLiabilityPoolNames = ["Familie",liabilityPoolName2]
        var poolToLiabilityDictionary = [String:[Liability]]()
        poolToLiabilityDictionary["Familie"] = [liability1,liability2]
        poolToLiabilityDictionary[liabilityPoolName2] = [liability3]
        let expectedLiabilities = [liability1,liability2,liability3]
        return (liabilityPool1,expectedLiabilityPoolNames,poolToLiabilityDictionary)
    }
    
    func createAndPersistTestObjects_updateLiabilityPool_2(using context: NSManagedObjectContext) -> (LiabilityPool,String) {
        let occupiedName = "Private"
        let _ = DataFactory.createLiabilityPool(named: occupiedName, liabilities: [], in: context)
        let otherName = "Staatlich"
        let assetPoolToUpdate = DataFactory.createLiabilityPool(named: otherName, liabilities: [], in: context)
        return (assetPoolToUpdate,occupiedName)
    }
    
    func createAndPersistTestObjects_updateLiabilityPool_3(using context: NSManagedObjectContext) -> LiabilityPool {
        DataFactory.createLiabilityPool(named: "Private", liabilities: [], in: context)
    }
    
    func createAndPersistTestObjects_deleteLiabilityPool_1(using context: NSManagedObjectContext) -> (LiabilityPool,[LiabilityPool],[LiabilityPool:[Liability]]) {
        let person1 = DataFactory.createLoanPartner(name: "Papa", context: context)
        let liability1FirstTransaction = DataFactory.createLoanTransaction(
            issuer: person1,
            date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
            amount: 1000,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liability1SecondTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-04-17T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liability1 = DataFactory.createLiability(
            name: "Auto",
            creditor: person1,
            transactions: [liability1FirstTransaction, liability1SecondTransaction],
            context: context
        )
        
        let person2 = DataFactory.createLoanPartner(name: "Mama", context: context)
        let liability2FirstTransaction = DataFactory.createLoanTransaction(
            issuer: person1,
            date: DateParser.shared.date(from: "2024-09-15T00:00:00")!,
            amount: 300,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liability2SecondTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-09-17T00:00:00")!,
            amount: 50,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liability2 = DataFactory.createLiability(
            name: "Booth",
            creditor: person1,
            transactions: [liability2FirstTransaction, liability2SecondTransaction],
            context: context
        )
        
        let person3 = DataFactory.createLoanPartner(name: "Bayerische Landesregierung", context: context)
        let liability3FirstTransaction = DataFactory.createLoanTransaction(
            issuer: person3,
            date: DateParser.shared.date(from: "2024-05-15T00:00:00")!,
            amount: 5000,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liability3SecondTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-05-19T00:00:00")!,
            amount: 1300,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liability3 = DataFactory.createLiability(
            name: "Booth",
            creditor: person3,
            transactions: [liability3FirstTransaction, liability3SecondTransaction],
            context: context
        )
        
        let liabilityPoolName1 = "Privat"
        let liabilityPoolName2 = "Staatlich"
        let liabilityPool1 = DataFactory.createLiabilityPool(named: liabilityPoolName1, liabilities: [liability1,liability2], in: context)
        let liabilityPool2 = DataFactory.createLiabilityPool(named: liabilityPoolName2, liabilities: [liability3], in: context)
        
        let expectedLiabilityPools = [liabilityPool2]
        var poolToLiabilitiesDictionary = [LiabilityPool:[Liability]]()
        poolToLiabilitiesDictionary[liabilityPool2] = [liability3]
        return (liabilityPool1,expectedLiabilityPools,poolToLiabilitiesDictionary)
    }
}

