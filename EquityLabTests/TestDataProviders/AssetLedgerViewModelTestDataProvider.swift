@testable import EquityLab
import CoreData

struct AssetLedgerViewModelTestDataProvider {
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
    
    func createAndPersistTestObjects_deleteAssets_1(using context: NSManagedObjectContext) -> ([AssetPool],[AssetPool:[Asset]],[Asset]) {
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
        poolToAssetDictionary[assetPool1] = []
        poolToAssetDictionary[assetPool2] = [asset3,asset4]
        poolToAssetDictionary[assetPool3] = [asset5]
        poolToAssetDictionary[assetPool4] = [asset1]
        let expectedAssets = [asset2,asset3,asset4,asset5]
        return (expectedAssetPools,poolToAssetDictionary,expectedAssets)
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
}
