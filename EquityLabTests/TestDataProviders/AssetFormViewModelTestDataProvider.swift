@testable import EquityLab
import CoreData

struct AssetFormViewModelTestDataProvider {
    func createAndPersitsTestObjects_getAssetPools_1(using context: NSManagedObjectContext) -> [AssetPool] {
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
        
        return [assetPool1,assetPool2,assetPool3,assetPool4]
    }
    
    func createAndPersistTestObjects_saveAsset_1(context: NSManagedObjectContext) -> Receivable {
        let receivable = DataFactory.createReceivable(name: "Lenni", date: .now, debtor: "Lenni", initialAmount: 100.0, repaidAmount: 20.0, context: context)
        let _ = DataFactory.createAssetPool(named: "Darlehen", assets: [receivable], in: context)
        return receivable
    }
    
    func createAndPersistTestObjects_saveAsset_2(context: NSManagedObjectContext) -> Possession {
        let possession = DataFactory.createPossession(name: "Sparkasse Konto", volatile: true, context: context)
        let _ = DataFactory.createAssetPool(named: "Darlehen", assets: [possession], in: context)
        return possession
    }
    
    func createAndPersistTestObjects_multiPurpose_1(context: NSManagedObjectContext) -> AssetPool {
        DataFactory.createAssetPool(named: "Privat", assets: [], in: context)
    }
    
    func createAndPersistTestObjects_multiPurpose_2(context: NSManagedObjectContext) -> (AssetPool,String) {
        let assetPool = DataFactory.createAssetPool(named: "Privat", assets: [], in: context)
        let existingAssetName = "Blitz"
        let asset = DataFactory.createPossession(name: existingAssetName, volatile: true, context: context)
        return (assetPool,existingAssetName)
    }
    
    func createAndPersistTestObjects_deleteAssets_1(using context: NSManagedObjectContext) -> (Asset,[Asset]) {
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
        
        let expectedAssets = [asset2,asset3,asset4,asset5]
        return (asset1,expectedAssets)
    }
}
