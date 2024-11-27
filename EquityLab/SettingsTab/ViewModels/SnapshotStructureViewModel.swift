import os
import SwiftUI

@Observable
class SnapshotStructureViewModel {
    @ObservationIgnored private static let logger = Logger(subsystem: .settingsTab, component: .snapshotStructureViewModel)
    
    @ObservationIgnored private let assetRepository: AssetRepository
    @ObservationIgnored private let liabilityRepository: LiabilityRepository
    @ObservationIgnored private var assetPoolToAssetsDictionary: [AssetPool:[SnapshotStructureItem]]
    @ObservationIgnored private var liabilityPoolToLiabilitiesDictionary: [LiabilityPool:[Liability]]
    var assetPools = [AssetPool]()
    var liabilityPools = [LiabilityPool]()
    
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
        
        self.assetPoolToAssetsDictionary = [:]
        self.liabilityPoolToLiabilitiesDictionary = [:]
        
        assetRepository.$assetPools.registerObserver(self, keyPath: \.assetPools)
        assetRepository.$assetPools.onSetDo { [weak self] newAssetPools in
            guard let self else { return }
            assetPoolToAssetsDictionary = [:]
            for pool in newAssetPools {
                assetPoolToAssetsDictionary[pool] = Self.fetchSnapshotStructureItems(for: pool, using: assetRepository)
            }
        }
        
        liabilityRepository.$liabilityPools.registerObserver(self, keyPath: \.liabilityPools)
        liabilityRepository.$liabilityPools.onSetDo { [weak self] newLiabilityPools in
            guard let self else { return }
            liabilityPoolToLiabilitiesDictionary = [:]
            for pool in liabilityPools {
                liabilityPoolToLiabilitiesDictionary[pool] = liabilityRepository.liabilities.filter{ $0.pool == pool }
            }
        }
        
        for pool in assetPools {
            assetPoolToAssetsDictionary[pool] = Self.fetchSnapshotStructureItems(for: pool, using: assetRepository)
        }
        for pool in liabilityPools {
            liabilityPoolToLiabilitiesDictionary[pool] = liabilityRepository.liabilities.filter{ $0.pool == pool }
        }
    }
    
    private static func fetchSnapshotStructureItems(for assetPool: AssetPool, using assetRepository: AssetRepository) -> [SnapshotStructureItem] {
        let receivables = assetRepository.receivables.filter{ $0.pool == assetPool } as [SnapshotStructureItem]
        let possessions = assetRepository.possessions.filter{ $0.pool == assetPool } as [SnapshotStructureItem]
        return receivables + possessions
    }
    
    private var assetPoolWithSameNameExists: Bool {
        let assetPools = assetRepository.assetPools
        return assetPools.contains(where: { $0.name == alertPoolName && $0 != assetPoolToEdit })
    }
    
    private var liabilityPoolWithSameNameExists: Bool {
        let liabilityPools = liabilityRepository.liabilityPools
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
        assetRepository.updateAssetPool(assetPool: assetPoolToEdit, newName: alertPoolName)
    }
    
    func delete(assetPool: AssetPool) {
        Self.logger.debug("delete(assetPool)")
        assetRepository.deleteAssetPool(assetPool: assetPool)
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
        liabilityRepository.updateLiabilityPool(liabilityPool: liabilityPoolToEdit, newName: alertPoolName)
    }
    
    func delete(liabilityPool: LiabilityPool) {
        Self.logger.debug("delete(liabilityPool)")
        liabilityRepository.deleteLiabilityPool(liabilityPool: liabilityPool)
    }
    
    func getAssetsForAssetPool(_ pool: AssetPool) -> [SnapshotStructureItem] {
        Self.logger.debug("getAssetsForAssetPool(_ pool)")
        return assetPoolToAssetsDictionary[pool] ?? []
    }
    
    func getLiabilitiesForLiabilityPool(_ pool: LiabilityPool) -> [Liability] {
        Self.logger.debug("getliabilitiesForLiabilityPool(_ pool)")
        return liabilityPoolToLiabilitiesDictionary[pool] ?? []
    }
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
        viewModel.showEditAssetPoolAlert = true
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
