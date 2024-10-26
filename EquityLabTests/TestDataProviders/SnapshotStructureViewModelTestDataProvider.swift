@testable import EquityLab
import CoreData

struct SnapshotStructureViewModelTestDataProvider {
    func createAndPersistTestObjects_assetsAndPools_1(using context: NSManagedObjectContext) -> ([AssetPool],[AssetPool:[Asset]],[Asset]) {
        let asset1 = DataFactory.createReceivable(name: "Blitz",
                                                  date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
                                                  debtor: "Lenni",
                                                  initialAmount: 20.0,
                                                  repaidAmount: 0.0,
                                                  context: context)
        let asset2 = DataFactory.createPossession(name: "Geldbeutel", volatile: true, context: context)
        let asset3 = DataFactory.createPossession(name: "Konto Sparkasse", volatile: true, context: context)
        let asset4 = DataFactory.createPossession(name: "Konto Commerzbank", volatile: true, context: context)
        let asset5 = DataFactory.createPossession(name: "Depot FNZ", volatile: true, context: context)
        
        let assetPoolName1 = "Bargeld"
        let assetPoolName2 = "Bank"
        let assetPoolName3 = "Wertpapiere"
        let assetPoolName4 = "Geliehen"
        let assetPool1 = DataFactory.createAssetPool(named: assetPoolName1, assets: [asset2], in: context)
        let assetPool2 = DataFactory.createAssetPool(named: assetPoolName2, assets: [asset3, asset4], in: context)
        let assetPool3 = DataFactory.createAssetPool(named: assetPoolName3, assets: [asset5], in: context)
        let assetPool4 = DataFactory.createAssetPool(named: assetPoolName4, assets: [asset1], in: context)
        
        let expectedAssetPools = [assetPool1,assetPool2,assetPool3,assetPool4]
        var poolToAssetDictionary = [AssetPool:[Asset]]()
        poolToAssetDictionary[assetPool1] = [asset2]
        poolToAssetDictionary[assetPool2] = [asset3,asset4]
        poolToAssetDictionary[assetPool3] = [asset5]
        poolToAssetDictionary[assetPool4] = [asset1]
        let expectedAssets = [asset1,asset2,asset3,asset4,asset5]
        return (expectedAssetPools,poolToAssetDictionary,expectedAssets)
    }
    
    func createAndPersistTestObjects_assetsAndPools_2(using context: NSManagedObjectContext) -> ([AssetPool],[AssetPool:[Asset]],[Asset]) {
        let assetPoolName1 = "Bargeld"
        let assetPool1 = DataFactory.createAssetPool(named: assetPoolName1, assets: [], in: context)

        
        let expectedAssetPools = [assetPool1]
        var poolToAssetDictionary = [AssetPool:[Asset]]()
        poolToAssetDictionary[assetPool1] = []
        let expectedAssets = [Asset]()
        return (expectedAssetPools,poolToAssetDictionary,expectedAssets)
    }
    
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
    
    func createAndPersistTestObjects_deleteAssetPool_1(using context: NSManagedObjectContext) -> (AssetPool,[AssetPool],[AssetPool:[Asset]],[Asset]) {
        let asset1 = DataFactory.createReceivable(name: "Blitz",
                                                  date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
                                                  debtor: "Lenni",
                                                  initialAmount: 20.0,
                                                  repaidAmount: 0.0,
                                                  context: context)
        let asset2 = DataFactory.createPossession(name: "Geldbeutel", volatile: true, context: context)
        let asset3 = DataFactory.createPossession(name: "Konto Sparkasse", volatile: true, context: context)
        let asset4 = DataFactory.createPossession(name: "Konto Commerzbank", volatile: true, context: context)
        let asset5 = DataFactory.createPossession(name: "Depot FNZ", volatile: true, context: context)
        
        let assetPoolName1 = "Bargeld"
        let assetPoolName2 = "Bank"
        let assetPoolName3 = "Wertpapiere"
        let assetPoolName4 = "Geliehen"
        let assetPool1 = DataFactory.createAssetPool(named: assetPoolName1, assets: [asset2], in: context)
        let assetPool2 = DataFactory.createAssetPool(named: assetPoolName2, assets: [asset3, asset4], in: context)
        let assetPool3 = DataFactory.createAssetPool(named: assetPoolName3, assets: [asset5], in: context)
        let assetPool4 = DataFactory.createAssetPool(named: assetPoolName4, assets: [asset1], in: context)
        
        let expectedAssetPools = [assetPool1,assetPool3,assetPool4]
        var poolToAssetDictionary = [AssetPool:[Asset]]()
        poolToAssetDictionary[assetPool1] = [asset2]
        poolToAssetDictionary[assetPool3] = [asset5]
        poolToAssetDictionary[assetPool4] = [asset1]
        let expectedAssets = [asset1,asset2,asset5]
        return (assetPool2,expectedAssetPools,poolToAssetDictionary,expectedAssets)
    }
    
    func createAndPersistTestObjects_updateAssetPool_1(using context: NSManagedObjectContext) -> (AssetPool,[String],[String:[Asset]],[Asset]) {
        let asset1 = DataFactory.createReceivable(name: "Blitz",
                                                  date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
                                                  debtor: "Lenni",
                                                  initialAmount: 20.0,
                                                  repaidAmount: 0.0,
                                                  context: context)
        let asset2 = DataFactory.createPossession(name: "Geldbeutel", volatile: true, context: context)
        let asset3 = DataFactory.createPossession(name: "Konto Sparkasse", volatile: true, context: context)
        let asset4 = DataFactory.createPossession(name: "Konto Commerzbank", volatile: true, context: context)
        let asset5 = DataFactory.createPossession(name: "Depot FNZ", volatile: true, context: context)
        
        let assetPoolName1 = "Bargeld"
        let assetPoolName2 = "Bank"
        let assetPoolName3 = "Wertpapiere"
        let assetPoolName4 = "Geliehen"
        let assetPool1 = DataFactory.createAssetPool(named: assetPoolName1, assets: [asset2], in: context)
        let assetPool2 = DataFactory.createAssetPool(named: assetPoolName2, assets: [asset3, asset4], in: context)
        let assetPool3 = DataFactory.createAssetPool(named: assetPoolName3, assets: [asset5], in: context)
        let assetPool4 = DataFactory.createAssetPool(named: assetPoolName4, assets: [asset1], in: context)
        
        let expectedAssetPoolNames = ["Cash",assetPoolName2,assetPoolName3,assetPoolName4]
        var poolToAssetDictionary = [String:[Asset]]()
        poolToAssetDictionary["Cash"] = [asset2]
        poolToAssetDictionary[assetPoolName2] = [asset3,asset4]
        poolToAssetDictionary[assetPoolName3] = [asset5]
        poolToAssetDictionary[assetPoolName4] = [asset1]
        let expectedAssets = [asset1,asset2,asset3,asset4,asset5]
        return (assetPool1,expectedAssetPoolNames,poolToAssetDictionary,expectedAssets)
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
    
    func createAndPersistTestObjects_createLiabilityPool_1(using context: NSManagedObjectContext) -> String {
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
        let _ = DataFactory.createLiabilityPool(named: liabilityPoolName1, liabilities: [liability1,liability2,liability3], in: context)
        return liabilityPoolName1
    }
    
    func createAndPersistTestObjects_updateLiabilityPool_1(using context: NSManagedObjectContext) -> (LiabilityPool,String) {
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
        return (liabilityPool2,liabilityPoolName1)
    }
    
    func createAndPersistTestObjects_createAssetPool_1(using context: NSManagedObjectContext) -> String {
        let asset1 = DataFactory.createReceivable(name: "Blitz",
                                                  date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
                                                  debtor: "Lenni",
                                                  initialAmount: 20.0,
                                                  repaidAmount: 0.0,
                                                  context: context)
        let asset2 = DataFactory.createPossession(name: "Geldbeutel", volatile: true, context: context)
        let asset3 = DataFactory.createPossession(name: "Konto Sparkasse", volatile: true, context: context)
        let asset4 = DataFactory.createPossession(name: "Konto Commerzbank", volatile: true, context: context)
        let asset5 = DataFactory.createPossession(name: "Depot FNZ", volatile: true, context: context)
        
        let assetPoolName1 = "Bargeld"
        let _ = DataFactory.createAssetPool(named: assetPoolName1, assets: [asset1,asset2,asset3,asset4,asset5], in: context)
        return assetPoolName1
    }
    
    func createAndPersistTestObjects_updateAssetPool_1(using context: NSManagedObjectContext) -> (AssetPool,String) {
        let asset1 = DataFactory.createReceivable(name: "Blitz",
                                                  date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
                                                  debtor: "Lenni",
                                                  initialAmount: 20.0,
                                                  repaidAmount: 0.0,
                                                  context: context)
        let asset2 = DataFactory.createPossession(name: "Geldbeutel", volatile: true, context: context)
        let asset3 = DataFactory.createPossession(name: "Konto Sparkasse", volatile: true, context: context)
        let asset4 = DataFactory.createPossession(name: "Konto Commerzbank", volatile: true, context: context)
        let asset5 = DataFactory.createPossession(name: "Depot FNZ", volatile: true, context: context)
        
        let assetPoolName1 = "Bargeld"
        let assetPoolName2 = "Bank"
        let assetPool1 = DataFactory.createAssetPool(named: assetPoolName1, assets: [asset1,asset2], in: context)
        let assetPool2 = DataFactory.createAssetPool(named: assetPoolName2, assets: [asset3, asset4,asset5], in: context)

        return (assetPool2,assetPoolName1)
    }
}
