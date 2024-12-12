@testable import EquityLab
import CoreData

struct ReceivableFormViewModelTestDataProvider {
    func createAndPersitsTestObjects_getAssetPools_1(using context: NSManagedObjectContext) -> [AssetPool] {
        let person1 = "Lenni"
        let asset1 = DataFactory.createReceivable(name: "Blitz",
                                                  date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
                                                  debtor: person1,
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
        let assetPool1 = DataFactory.createAssetPool(named: assetPoolName1, possessions: [asset2], receivables: [], in: context)
        let assetPool2 = DataFactory.createAssetPool(named: assetPoolName2, possessions: [asset3,asset4], receivables: [], in: context)
        let assetPool3 = DataFactory.createAssetPool(named: assetPoolName3, possessions: [asset5], receivables: [], in: context)
        let assetPool4 = DataFactory.createAssetPool(named: assetPoolName4,  possessions: [], receivables: [asset1], in: context)
        
        return [assetPool1,assetPool2,assetPool3,assetPool4]
    }
    
    func createAndPersistTestObjects_updateReceivable_multipurpose(context: NSManagedObjectContext) -> Receivable {
        let person1 = "Lenni"
        let receivable = DataFactory.createReceivable(name: "Lenni",
                                                      date: .now,
                                                      debtor: person1,
                                                      initialAmount: 100.0,
                                                      repaidAmount: 20.0,
                                                      context: context)
        let _ = DataFactory.createAssetPool(named: "Darlehen", possessions: [], receivables: [receivable], in: context)
        return receivable
    }
    
    func createAndPersistTestObjects_createReceivable_multipurpose(context: NSManagedObjectContext) -> AssetPool {
        DataFactory.createAssetPool(named: "Privat", possessions: [], receivables: [], in: context)
    }
    
    func createAndPersistTestObjects_createReceivablesWithSameName_2(context: NSManagedObjectContext) -> (Possession,AssetPool) {
        let possession = DataFactory.createPossession(
            name: "Commerzbank Konto",
            volatile: true,
            context: context)
        let assetPool = DataFactory.createAssetPool(named: "Privat", possessions: [possession], receivables: [], in: context)
        return (possession,assetPool)
    }
    
    func createAndPersistTestObjects_deleteReceivable_1(using context: NSManagedObjectContext) -> (Receivable,[Receivable]) {
        let person1 = "Lenni"
        let person2 = "Haze"
        let asset1 = DataFactory.createReceivable(name: "Blitz",
                                                  date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
                                                  debtor: person1,
                                                  initialAmount: 20.0,
                                                  repaidAmount: 0.0,
                                                  context: context)
        let asset2 = DataFactory.createReceivable(name: "Baumarkt",
                                                  date: DateParser.shared.date(from: "2024-04-16T00:00:00")!,
                                                  debtor: person2,
                                                  initialAmount: 30.0,
                                                  repaidAmount: 5.0,
                                                  context: context)
        let expectedAssets = [asset2]
        return (asset1,expectedAssets)
    }
}

