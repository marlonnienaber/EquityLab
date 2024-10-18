import os
import SwiftUI

@Observable
class SnapshotStructureViewModel {
    @ObservationIgnored private static let logger = Logger(subsystem: .settingsTab, component: .snapshotStructureViewModel)
    
    @ObservationIgnored private let assetRepository: AssetRepository
    @ObservationIgnored private let liabilityRepository: LiabilityRepository
    @ObservationIgnored private var assetPoolToAssetsDictionary: [AssetPool:[Asset]]
    @ObservationIgnored private var liabilityPoolToLiabilitiesDictionary: [LiabilityPool:[Liability]]
    var assetPools: [AssetPool]
    var liabilityPools: [LiabilityPool]
    
    var alertPoolName = ""
    var showEditAssetPoolAlert = false
    var assetPoolToEdit: AssetPool?
    var showEditLiabilityPoolAlert = false
    var liabilityPoolToEdit: LiabilityPool?
    
    var activeBalanceItemSheet: BalanceItemSheet? = nil
    var showBalanceItemPickerSheet = false
    var selectedBalanceItem: BalanceItemType = .assetPool
    
    var showCreateAssetPoolAlert = false
    var showCreateLiabilityPoolAlert = false
    
    init(assetRepository: AssetRepository = .production, liabilityRepository: LiabilityRepository = .production) {
        Self.logger.debug("SnapshotStructureViewModel()")
        
        self.assetRepository = assetRepository
        self.liabilityRepository = liabilityRepository
        
        self.assetPools = assetRepository.fetchAssetPools()
        self.assetPoolToAssetsDictionary = [:]
        
        self.liabilityPools = liabilityRepository.fetchLiabilityPools()
        self.liabilityPoolToLiabilitiesDictionary = [:]
        
        for pool in assetPools {
            assetPoolToAssetsDictionary[pool] = assetRepository.fetchAssets(for: pool)
        }
        for pool in liabilityPools {
            liabilityPoolToLiabilitiesDictionary[pool] = liabilityRepository.fetchLiabilities(for: pool)
        }
        
        self.assetRepository.add(observer: self)
        self.liabilityRepository.add(observer: self)
    }
    
    func getAssetsForAssetPool(_ pool: AssetPool) -> [Asset] {
        Self.logger.debug("getAssetsForAssetPool(_ pool)")
        return assetPoolToAssetsDictionary[pool] ?? []
    }
    
    func getLiabilitiesForLiabilityPool(_ pool: LiabilityPool) -> [Liability] {
        Self.logger.debug("getliabilitiesForLiabilityPool(_ pool)")
        return liabilityPoolToLiabilitiesDictionary[pool] ?? []
    }
    
    func createAssetPool() {
        Self.logger.debug("createAssetPool()")
        assetRepository.createAssetPool(named: alertPoolName)
    }
    
    func delete(assetPool: AssetPool) {
        Self.logger.debug("delete(assetPool)")
        assetRepository.delete(assetPool: assetPool)
    }
    
    func updateAssetPool() {
        Self.logger.debug("updateAssetPool()")
        guard let assetPoolToEdit else { return }
        assetRepository.update(assetPool: assetPoolToEdit, newName: alertPoolName)
    }
    
    func createLiabilityPool() {
        Self.logger.debug("createLiabilityPool()")
        liabilityRepository.createLiabilityPool(named: alertPoolName)
    }
    
    func delete(liabilityPool: LiabilityPool) {
        Self.logger.debug("delete()liabilityPool")
        liabilityRepository.delete(liabilityPool: liabilityPool)
    }
    
    func updateLiabilityPool() {
        Self.logger.debug("updateLiabilityPool()")
        guard let liabilityPoolToEdit else { return }
        liabilityRepository.update(liabilityPool: liabilityPoolToEdit, newName: alertPoolName)
    }
}

extension SnapshotStructureViewModel: AssetObserver, LiabilityObserver {
    func notifyAfterLiabilityUpdate() {
        Self.logger.debug("notifyAfterLiabilityUpdate()")
        self.liabilityPools = liabilityRepository.fetchLiabilityPools()
        self.liabilityPoolToLiabilitiesDictionary = [:]
        for pool in liabilityPools {
            liabilityPoolToLiabilitiesDictionary[pool] = liabilityRepository.fetchLiabilities(for: pool)
        }
    }
    
    func notifyAfterAssetUpdate() {
        Self.logger.debug("notifyAfterAssetUpdate()")
        self.assetPools = assetRepository.fetchAssetPools()
        self.assetPoolToAssetsDictionary = [:]
        for pool in assetPools {
            assetPoolToAssetsDictionary[pool] = assetRepository.fetchAssets(for: pool)
        }
    }
}

protocol Named {
    var name: String { get }
}

enum BalanceItemSheet: Identifiable {
    case createSheetPossession
    case createSheetReceivable
    case createSheetLiability
    case updateSheetAsset(asset: Asset)
    case updateSheetLiability(liability: Liability)
    var id: String {
        switch self {
        case .createSheetPossession:
            return "addSheetPossession"
        case .createSheetReceivable:
            return "addSheetReceivable"
        case .createSheetLiability:
            return "addSheetLiability"
        case .updateSheetAsset(let asset):
            return "updateSheetAsset-\(asset.id)"
        case .updateSheetLiability(let liability):
            return "updateSheetLiability-\(liability.id)"
        }
    }
}

enum BalanceItemType {
    case assetPool
    case possession
    case receivable
    case liabilityPool
    case liability
}
