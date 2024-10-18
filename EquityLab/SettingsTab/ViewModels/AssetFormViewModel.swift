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
        self.assetPool = asset?.pool
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
    
    func updateReceivable() {
        Self.logger.debug("updateReceivable(receivable)")
        guard let receivable = asset as? Receivable else { return }
        repository.updateReceivable(receivable: receivable,
                                    newName: assetName,
                                    newDebtor: receivableDebtor,
                                    newInitialAmount: receivableInitialAmount,
                                    newRepaidAmount: receivableRepaidAmount,
                                    newGrantDate: receivableGrantDate)
    }
    
    func updatePossession() {
        Self.logger.debug("updatePossession(possession)")
        guard let possession = asset as? Possession else { return }
        repository.updatePossession(possession: possession, newName: assetName, newIsVolatile: possessionIsVolatile)
    }
    
    func createReceivable() {
        Self.logger.debug("createReceivable()")
        if let assetPool, assetWithSameNameDoesNotExist() {
            repository.createReceivable(name: assetName,
                                        pool: assetPool,
                                        debtor: receivableDebtor,
                                        initialAmount: receivableInitialAmount,
                                        repaidAmount: receivableRepaidAmount,
                                        grantDate: receivableGrantDate)
        }
        /* TODO: give some feedback to the user in case an asset with the same name does exist */
    }
    
    func createPossession() {
        Self.logger.debug("createPossession()")
        if let assetPool, assetWithSameNameDoesNotExist() {
            repository.createPossession(name: assetName, pool: assetPool, isVolatile: possessionIsVolatile)
        }
        /* TODO: give some feedback to the user in case an asset with the same name does exist */
    }
    
    func saveAsset() {
        Self.logger.debug("saveAsset()")
        if let receivable = asset as? Receivable {
            updateReceivable()
        } else if let possession = asset as? Possession {
            updatePossession()
        } else if assetWithSameNameDoesNotExist() {
            switch selectedAssetType {
                case .receivable: createReceivable()
                case .possession: createPossession()
            }
        } else {
            print("error")
        }
    }
    
    func deleteAsset() {
        Self.logger.debug("deleteAsset()")
        guard let asset else { return }
        repository.delete(asset: asset)
    }
    
    func getAssetPools() -> [AssetPool] {
        repository.fetchAssetPools()
    }
}
