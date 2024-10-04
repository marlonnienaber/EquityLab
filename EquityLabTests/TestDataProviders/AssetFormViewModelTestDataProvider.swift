@testable import EquityLab
import CoreData

struct AssetFormViewModelTestDataProvider {
    func createAndPersistTestObjects_saveAsset_1(context: NSManagedObjectContext) -> Receivable {
        DataFactory.createReceivable(name: "Lenni", date: .now, debtor: "Lenni", initialAmount: 100.0, repaidAmount: 20.0, context: context)
    }
    
    func createAndPersistTestObjects_saveAsset_2(context: NSManagedObjectContext) -> Possession {
        DataFactory.createPossession(name: "Sparkasse Konto", volatile: true, context: context)
    }
    
    func createAndPersistTestObjects_multiPurpose_1(context: NSManagedObjectContext) -> AssetPool {
        DataFactory.createAssetPool(named: "Privat", assets: [], in: context)
    }
}
