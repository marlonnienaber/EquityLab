import os
import SwiftUI

@Observable
class SnapshotStructureViewModel {
    @ObservationIgnored private static let logger = Logger(subsystem: .settingsTab, component: .snapshotStructureViewModel)
    
    @ObservationIgnored private let assetRepository: AssetRepository
    @ObservationIgnored private let liabilityRepository: LiabilityRepository
    @ObservationIgnored private var assetPoolToAssetsDictionary: [AssetPool:[SnapshotStructureItem]] /* TODO: rename */
    @ObservationIgnored private var liabilityPoolToLiabilitiesDictionary: [LiabilityPool:[SnapshotStructureItem]] /* TODO: rename */
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
    
    var assetPoolValidationError: AssetPoolValidationError?
    var showAssetPoolValidationErrorAlert = false
    
    var liabilityPoolValidationError: LiabilityPoolValidationError?
    var showLiabilityPoolValidationErrorAlert = false
    
    init(assetRepository: AssetRepository = .production, liabilityRepository: LiabilityRepository = .production) {
        Self.logger.debug("SnapshotStructureViewModel()")
        
        self.assetRepository = assetRepository
        self.liabilityRepository = liabilityRepository
        
        self.assetPools = assetRepository.getAssetPools()
        self.assetPoolToAssetsDictionary = [:]
        
        self.liabilityPools = liabilityRepository.fetchLiabilityPools()
        self.liabilityPoolToLiabilitiesDictionary = [:]
        
        for pool in assetPools {
            let receivables = assetRepository.getReceivables().filter{ $0.pool == pool }
            let possessions = assetRepository.getPossessions().filter{ $0.pool == pool }
            assetPoolToAssetsDictionary[pool] = receivables + possessions
        }
        for pool in liabilityPools {
            liabilityPoolToLiabilitiesDictionary[pool] = liabilityRepository.fetchSnapshotStructureItems(for: pool)
        }
        
        self.assetRepository.add(observer: self)
        self.liabilityRepository.add(observer: self)
    }
    
    private var assetPoolWithSameNameExists: Bool {
        let assetPools = assetRepository.getAssetPools()
        return assetPools.contains(where: { $0.name == alertPoolName && $0 != assetPoolToEdit })
    }
    
    private var liabilityPoolWithSameNameExists: Bool {
        let liabilityPools = liabilityRepository.fetchLiabilityPools()
        return liabilityPools.contains(where: { $0.name == alertPoolName && $0 != liabilityPoolToEdit })
    }
    
    private func validateAssetPool() throws {
        /* TODO: add empty name validation case */
        if assetPoolWithSameNameExists {
            throw AssetPoolValidationError.poolWithSameNameAlreadyExists
        }
    }
    
    private func validateLiabilityPool() throws {
        /* TODO: add empty name validation case */
        if liabilityPoolWithSameNameExists {
            throw LiabilityPoolValidationError.poolWithSameNameAlreadyExists
        }
    }
    
    func createAssetPool() throws {
        Self.logger.debug("createAssetPool()")
        try validateAssetPool()
        assetRepository.createAssetPool(named: alertPoolName)
    }
    
    func updateAssetPool() throws {
        Self.logger.debug("updateAssetPool()")
        guard let assetPoolToEdit else { return }
        try validateAssetPool()
        assetRepository.update(assetPool: assetPoolToEdit, newName: alertPoolName)
    }
    
    func delete(assetPool: AssetPool) {
        Self.logger.debug("delete(assetPool)")
        assetRepository.delete(assetPool: assetPool)
    }
    
    func createLiabilityPool() throws {
        Self.logger.debug("createLiabilityPool()")
        try validateLiabilityPool()
        liabilityRepository.createLiabilityPool(named: alertPoolName)
    }
    
    func updateLiabilityPool() throws {
        Self.logger.debug("updateLiabilityPool()")
        guard let liabilityPoolToEdit else { return }
        try validateLiabilityPool()
        liabilityRepository.update(liabilityPool: liabilityPoolToEdit, newName: alertPoolName)
    }
    
    func delete(liabilityPool: LiabilityPool) {
        Self.logger.debug("delete()liabilityPool")
        liabilityRepository.delete(liabilityPool: liabilityPool)
    }
    
    func getAssetsForAssetPool(_ pool: AssetPool) -> [SnapshotStructureItem] {
        Self.logger.debug("getAssetsForAssetPool(_ pool)")
        return assetPoolToAssetsDictionary[pool] ?? []
    }
    
    func getLiabilitiesForLiabilityPool(_ pool: LiabilityPool) -> [SnapshotStructureItem] {
        Self.logger.debug("getliabilitiesForLiabilityPool(_ pool)")
        return liabilityPoolToLiabilitiesDictionary[pool] ?? []
    }
}

extension SnapshotStructureViewModel: LiabilityObserver {
    func notifyAfterLiabilityUpdate() {
        Self.logger.debug("notifyAfterLiabilityUpdate()")
        self.liabilityPools = liabilityRepository.fetchLiabilityPools()
        self.liabilityPoolToLiabilitiesDictionary = [:]
        for pool in liabilityPools {
            liabilityPoolToLiabilitiesDictionary[pool] = liabilityRepository.fetchSnapshotStructureItems(for: pool)
        }
    }
}

extension SnapshotStructureViewModel: AssetPoolObserver, ReceivableObserver, PossessionObserver {
    func notifyAfterAssetPoolUpdate() {
        assetPools = assetRepository.getAssetPools()
    }
    
    func notifyAfterReceivableUpdate() {
        assetPools = assetRepository.getAssetPools()
        self.assetPoolToAssetsDictionary = [:]
        for pool in assetPools {
            let receivables = assetRepository.getReceivables().filter{ $0.pool == pool }
            let possessions = assetRepository.getPossessions().filter{ $0.pool == pool }
            assetPoolToAssetsDictionary[pool] = receivables + possessions
        }
    }
    
    func notifyAfterPossessionUpdate() {
        assetPools = assetRepository.getAssetPools()
        self.assetPoolToAssetsDictionary = [:]
        for pool in assetPools {
            let receivables = assetRepository.getReceivables().filter{ $0.pool == pool }
            let possessions = assetRepository.getPossessions().filter{ $0.pool == pool }
            assetPoolToAssetsDictionary[pool] = receivables + possessions
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
    case updateSheetPossession(possession: Possession)
    case updateSheetReceivable(receivable: Receivable)
    case updateSheetLiability(liability: Liability)
    var id: String {
        switch self {
        case .createSheetPossession:
            return "addSheetPossession"
        case .createSheetReceivable:
            return "addSheetReceivable"
        case .createSheetLiability:
            return "addSheetLiability"
        case .updateSheetPossession(let possession):
            return "updateSheetPossession-\(possession.id)"
        case .updateSheetReceivable(let receivable):
            return "updateSheetReceivable-\(receivable.id)"
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

enum AssetPoolValidationError: String, LocalizedError {
    case poolWithSameNameAlreadyExists = "A pool with the same name already exists!"
    var errorDescription: String? {
        return self.rawValue
    }
}

enum LiabilityPoolValidationError: String, LocalizedError {
    case poolWithSameNameAlreadyExists = "A pool with the same name already exists!"
    var errorDescription: String? {
        return self.rawValue
    }
}



protocol SnapshotStructurePool {
    var name: String { get }
    func edit(via viewModel: SnapshotStructureViewModel)
    func retrieveItems(via viewModel: SnapshotStructureViewModel) -> [SnapshotStructureItem]
}

extension AssetPool: SnapshotStructurePool {
    func edit(via viewModel: SnapshotStructureViewModel) {
        viewModel.alertPoolName = name
        viewModel.assetPoolToEdit = self
        viewModel.showEditAssetPoolAlert = true
    }
    
    func retrieveItems(via viewModel: SnapshotStructureViewModel) -> [SnapshotStructureItem] {
        viewModel.getAssetsForAssetPool(self)
    }
}

extension LiabilityPool: SnapshotStructurePool {
    func edit(via viewModel: SnapshotStructureViewModel) {
        viewModel.alertPoolName = name
        viewModel.liabilityPoolToEdit = self
        viewModel.showEditLiabilityPoolAlert = true
    }
    
    func retrieveItems(via viewModel: SnapshotStructureViewModel) -> [SnapshotStructureItem] {
        viewModel.getLiabilitiesForLiabilityPool(self)
    }
}



protocol SnapshotStructureItem {
    var name: String { get }
    func edit(via viewModel: SnapshotStructureViewModel)
}

extension Receivable: SnapshotStructureItem {
    func edit(via viewModel: SnapshotStructureViewModel) {
        viewModel.activeBalanceItemSheet = .updateSheetReceivable(receivable: self)
    }
}

extension Possession: SnapshotStructureItem {
    func edit(via viewModel: SnapshotStructureViewModel) {
        viewModel.activeBalanceItemSheet = .updateSheetPossession(possession: self)
    }
}

extension Liability: SnapshotStructureItem {
    func edit(via viewModel: SnapshotStructureViewModel) {
        viewModel.activeBalanceItemSheet = .updateSheetLiability(liability: self)
    }
}
