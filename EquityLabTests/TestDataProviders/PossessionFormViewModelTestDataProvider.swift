@testable import EquityLab
import CoreData

struct PossessionFormViewModelTestDataProvider {
    func createAndPersitsTestObjects_getAssetPools_1(using context: NSManagedObjectContext) -> [AssetPool] {
        let person1 = DataFactory.createPerson(name: "Lenni", using: context)
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
    
    func createAndPersistTestObjects_updatePossession_multipurpose(context: NSManagedObjectContext) -> Possession {
        let possession = DataFactory.createPossession(name: "Sparkasse Konto", volatile: true, context: context)
        let _ = DataFactory.createAssetPool(named: "Darlehen", possessions: [], receivables: [], in: context)
        return possession
    }
    
    func createAndPersistTestObjects_createPossessions_multipurpose(context: NSManagedObjectContext) -> AssetPool {
        DataFactory.createAssetPool(named: "Privat", possessions: [], receivables: [], in: context)
    }
    
    func createAndPersistTestObjects_createPossessionsWithSameName_2(context: NSManagedObjectContext) -> (Receivable,AssetPool) {
        let person2 = DataFactory.createPerson(name: "Philipp", using: context)
        let receivable = DataFactory.createReceivable(
            name: "Rote Sonne",
            date: DateParser.shared.date(from: "2024-07-23T00:00:00")!,
            debtor: person2,
            initialAmount: 200.0,
            repaidAmount: 40.0,
            context: context
        )
        let assetPool = DataFactory.createAssetPool(named: "Privat", possessions: [], receivables: [receivable], in: context)
        return (receivable,assetPool)
    }
    
    func createAndPersistTestObjects_deletePossession_1(using context: NSManagedObjectContext) -> (Possession,[Possession]) {
        let asset1 = DataFactory.createPossession(name: "Geldbeutel", volatile: true, context: context)
        let asset2 = DataFactory.createPossession(name: "Konto Sparkasse", volatile: true, context: context)
        let asset3 = DataFactory.createPossession(name: "Konto Commerzbank", volatile: true, context: context)
        let asset4 = DataFactory.createPossession(name: "Depot FNZ", volatile: true, context: context)
        
        let expectedAssets = [asset2,asset3,asset4]
        return (asset1,expectedAssets)
    }
}
