import CoreData

@Observable
class AssetFormViewModel {
    private let repository: AssetRepository
    var assetPool: AssetPool?
    var asset: Asset?
    var selectedAssetType: AssetType
    var assetName: String
    var receivableGrantDate: Date
    var receivableDebtor: String
    var receivableInitialAmount: Double
    var receivableRepaidAmount: Double
    var possessionIsVolatile: Bool
    let dismissSheet: () -> ()
    var showPopover: Bool = false
    
    init(asset: Asset? = nil, pool: AssetPool? = nil, repository: AssetRepository = .production, dismissSheet: @escaping () -> ()) {
        self.repository = repository
        self.assetPool = pool
        self.asset = asset
        self.selectedAssetType = .possession
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
        self.dismissSheet = dismissSheet
    }
    
    private func assetWithSameNameDoesNotExist() -> Bool {
        let assets = repository.fetchAssets()
        return !assets.contains(where: {$0.name == assetName})
    }
    
    func saveAsset() {
        if let receivable = asset as? Receivable {
            updateReceivable(receivable: receivable)
        } else if let possession = asset as? Possession {
            updatePossession(possession: possession)
        } else if assetWithSameNameDoesNotExist() {
            switch selectedAssetType {
                case .receivable: createReceivable()
                case .possession: createPossession()
            }
        }
    }
    
    func updateReceivable(receivable: Receivable) {
        repository.updateReceivable(receivable: receivable,
                                    newName: assetName,
                                    newDebtor: receivableDebtor,
                                    newInitialAmount: receivableInitialAmount,
                                    newRepaidAmount: receivableRepaidAmount,
                                    newGrantDate: receivableGrantDate)
    }
    
    func updatePossession(possession: Possession) {
        repository.updatePossession(possession: possession, newName: assetName, newIsVolatile: possessionIsVolatile)
    }
    
    func createReceivable() {
        guard let assetPool else { return }
        repository.createReceivable(name: assetName,
                                    pool: assetPool,
                                    debtor: receivableDebtor,
                                    initialAmount: receivableInitialAmount,
                                    repaidAmount: receivableRepaidAmount,
                                    grantDate: receivableGrantDate)
    }
    
    func createPossession() {
        guard let assetPool else { return }
        repository.createPossession(name: assetName, pool: assetPool, isVolatile: possessionIsVolatile)
    }
}

enum AssetType: Hashable {
    case receivable
    case possession
}
