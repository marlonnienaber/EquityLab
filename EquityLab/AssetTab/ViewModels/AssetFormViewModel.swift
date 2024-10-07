import os
import CoreData

@Observable
class AssetFormViewModel {
    @ObservationIgnored private static let logger = Logger(subsystem: .assetTab, component: .assetFormViewModel)
    
    @ObservationIgnored private let repository: AssetRepository
    var assetPool: AssetPool?
    var asset: Asset?
    var assetName: String
    var receivableGrantDate: Date
    var receivableDebtor: String
    var receivableInitialAmount: Double
    var receivableRepaidAmount: Double
    var possessionIsVolatile: Bool
    var showPopover: Bool = false
    var selectedAssetType: Asset.SubType
    let dismissSheet: () -> ()
    
    init(asset: Asset? = nil, pool: AssetPool? = nil, repository: AssetRepository = .production, dismissSheet: @escaping () -> ()) {
        Self.logger.debug("AssetFormViewModel()")
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
        Self.logger.debug("assetWithSameNameDoesNotExist()")
        let assets = repository.fetchAssets()
        return !assets.contains(where: {$0.name == assetName})
    }
    
    private func updateReceivable(receivable: Receivable) {
        Self.logger.debug("updateReceivable(receivable)")
        repository.updateReceivable(receivable: receivable,
                                    newName: assetName,
                                    newDebtor: receivableDebtor,
                                    newInitialAmount: receivableInitialAmount,
                                    newRepaidAmount: receivableRepaidAmount,
                                    newGrantDate: receivableGrantDate)
    }
    
    private func updatePossession(possession: Possession) {
        Self.logger.debug("updatePossession(possession)")
        repository.updatePossession(possession: possession, newName: assetName, newIsVolatile: possessionIsVolatile)
    }
    
    private func createReceivable() {
        Self.logger.debug("createReceivable()")
        guard let assetPool else { return }
        repository.createReceivable(name: assetName,
                                    pool: assetPool,
                                    debtor: receivableDebtor,
                                    initialAmount: receivableInitialAmount,
                                    repaidAmount: receivableRepaidAmount,
                                    grantDate: receivableGrantDate)
    }
    
    private func createPossession() {
        Self.logger.debug("createPossession()")
        guard let assetPool else { return }
        repository.createPossession(name: assetName, pool: assetPool, isVolatile: possessionIsVolatile)
    }
    
    func saveAsset() {
        Self.logger.debug("saveAsset()")
        if let receivable = asset as? Receivable {
            updateReceivable(receivable: receivable)
        } else if let possession = asset as? Possession {
            updatePossession(possession: possession)
        } else if assetWithSameNameDoesNotExist() {
            switch selectedAssetType {
                case .receivable: createReceivable()
                case .possession: createPossession()
            }
        } else {
            print("error")
        }
        /* TODO: give some feedback to the user in case an asset with the same name does exist */
    }
}
