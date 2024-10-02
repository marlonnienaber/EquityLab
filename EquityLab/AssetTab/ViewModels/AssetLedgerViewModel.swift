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
        poolToAssetsDictionary[pool] ?? []
    }
    
    func assets() -> [Asset] {
        Array(poolToAssetsDictionary.values.flatMap { $0 })
    }
    
    func deleteAssets(in pool: AssetPool, forIndexSet indexSet: IndexSet) {
        guard let sectionAssets = poolToAssetsDictionary[pool] else { return }
        indexSet.map{sectionAssets[$0]}.forEach{ repository.delete(asset: $0) }
    }
    
    func createAssetPool() {
        repository.createAssetPool(named: poolName)
    }
    
    func deleteAssetPool() {
        guard let alertPool else { return }
        repository.delete(assetPool: alertPool)
    }
    
    func updateAssetPool() {
        guard let alertPool else { return }
        repository.update(assetPool: alertPool, newName: poolName)
    }
    
    func resetPoolVariables() {
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
    var id: UUID { UUID() }
    case addSheetAsset(pool: AssetPool)
    case updateSheetAsset(asset: Asset)
}
