import Foundation
import CoreData

@Observable
class AssetFormViewModel {
    private let context: NSManagedObjectContext
    private let assets: [Asset]
    public var assetPool: AssetPool?
    public var asset: Asset?
    public var selectedAssetType: String
    public var assetName: String
    public var receivableGrantDate: Date
    public var receivableDebtor: String
    public var receivableInitialAmount: Double
    public var receivableRepaidAmount: Double
    public var possessionIsVolatile: Bool
    
    init(asset: Asset? = nil, pool: AssetPool? = nil, allAssets: [Asset]) {
        self.context = ProductionCoreDataStack.shared.context
        self.assets = allAssets
        self.assetPool = pool
        self.asset = asset
        self.selectedAssetType = "possession"
        self.assetName = asset?.name ?? ""
        if let receivable = asset as? Receivable {
            self.receivableGrantDate = receivable.grantDate
            self.receivableDebtor = receivable.debtor
            self.receivableInitialAmount = receivable.initialAmount
            self.receivableRepaidAmount = receivable.repaidAmount
        } else {
            self.receivableGrantDate = Date.now
            self.receivableDebtor = ""
            self.receivableInitialAmount = 0.0
            self.receivableRepaidAmount = 0.0
        }
        if let possession = asset as? Possession {
            self.possessionIsVolatile = possession.volatile
        } else {
            self.possessionIsVolatile = true
        }
    }
    
    func saveAsset() {
        if let receivable = asset as? Receivable {
            updateReceivable(receivable: receivable)
        } else if let possession = asset as? Possession {
            updatePossession(possession: possession)
        } else if !assets.contains(where: {$0.name == assetName}) {
            if selectedAssetType == "receivable" {
                createReceivable()
            } else {
                createPossession()
            }
        }
    }
    
    func updateReceivable(receivable: Receivable) {
        receivable.name = assetName
        receivable.debtor = receivableDebtor
        receivable.initialAmount = receivableInitialAmount
        receivable.repaidAmount = receivableRepaidAmount
        receivable.grantDate = receivableGrantDate
        try? context.save()
    }
    
    func updatePossession(possession: Possession) {
        possession.name = assetName
        possession.volatile = possessionIsVolatile
        try? context.save()
    }
    
    func createReceivable() {
        let receivable = Receivable(context: context)
        receivable.name = assetName
        receivable.pool = assetPool
        receivable.debtor = receivableDebtor
        receivable.initialAmount = receivableInitialAmount
        receivable.repaidAmount = receivableRepaidAmount
        receivable.grantDate = receivableGrantDate
        try? context.save()
    }
    
    func createPossession() {
        let possession = Possession(context: context)
        possession.name = assetName
        possession.volatile = possessionIsVolatile
        possession.pool = assetPool
        try? context.save()
    }
}
