import os
import CoreData

@Observable
class AssetLedgerViewModel {
    @ObservationIgnored private static let logger = Logger(subsystem: .assetTab, component: .assetLedgerViewModel)
    
    @ObservationIgnored private let repository: AssetRepository
    @ObservationIgnored private var poolToAssetsDictionary = [AssetPool:[Asset]]()
    var pools = [AssetPool]()
    var poolName = ""
    var alertPool: AssetPool? = nil
    var showCreatePoolAlert = false
    var showEditPoolAlert = false
    var activeSheet: AssetLedgerSheetType? = nil
    
    init(repository: AssetRepository = AssetRepository.production) {
        Self.logger.debug("AssetLedgerViewModel")
        self.repository = repository
        self.pools = repository.fetchAssetPools()
        self.repository.add(observer: self)
        for pool in pools {
            poolToAssetsDictionary[pool] = repository.fetchAssets(for: pool)
        }
    }
    
    func assets(for pool: AssetPool) -> [Asset] {
        Self.logger.debug("assetsForPool")
        return poolToAssetsDictionary[pool] ?? []
    }
    
    func assets() -> [Asset] {
        Self.logger.debug("assets")
        return Array(poolToAssetsDictionary.values.flatMap { $0 })
    }
    
    func deleteAssets(in pool: AssetPool, forIndexSet indexSet: IndexSet) {
        Self.logger.debug("deleteAssets")
        guard let sectionAssets = poolToAssetsDictionary[pool] else { return }
        indexSet.map{sectionAssets[$0]}.forEach{ repository.delete(asset: $0) }
    }
    
    func createAssetPool() {
        Self.logger.debug("createAssetPool")
        repository.createAssetPool(named: poolName)
    }
    
    func deleteAssetPool() {
        Self.logger.debug("deleteAssetPool")
        guard let alertPool else { return }
        repository.delete(assetPool: alertPool)
    }
    
    func updateAssetPool() {
        Self.logger.debug("updateAssetPool")
        guard let alertPool else { return }
        repository.update(assetPool: alertPool, newName: poolName)
    }
    
    func resetPoolVariables() {
        Self.logger.debug("resetPoolVariables")
        alertPool = nil
        poolName = ""
    }
}

extension AssetLedgerViewModel: AssetObserver {
    func notifyAfterAssetUpdate() {
        Self.logger.debug("notifyAfterAssetUpdate")
        pools = repository.fetchAssetPools()
        for pool in pools {
            poolToAssetsDictionary[pool] = repository.fetchAssets(for: pool)
        }
    }
}

enum AssetLedgerSheetType: Identifiable {
    case addSheetAsset(pool: AssetPool)
    case updateSheetAsset(asset: Asset)
    var id: String {
        switch self {
        case .addSheetAsset(let pool):
            return "addSheetAsset-\(pool.id)"
        case .updateSheetAsset(let asset):
            return "updateSheet-\(asset.id)"
        }
    }
}
