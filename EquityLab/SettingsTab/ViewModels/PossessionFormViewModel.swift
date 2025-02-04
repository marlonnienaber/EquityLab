import os
import CoreData

@Observable
class PossessionFormViewModel {
    @ObservationIgnored private static let logger = Logger(subsystem: .settingsTab, component: .possessionFormViewModel)
    
    @ObservationIgnored private let repository: AssetRepository
    var assetPool: AssetPool?
    var possession: Possession?
    var name: String
    var isVolatile: Bool
    var showPopover: Bool = false
    var possessionValidationError: PossessionValidationError?
    var showValidationErrorAlert = false
    let dismissSheet: () -> ()
    
    
    init(possession: Possession? = nil, repository: AssetRepository = .production, dismissSheet: @escaping () -> ()) {
        Self.logger.debug("PossessionFormViewModel()")
        self.repository = repository
        self.possession = possession
        self.name = possession?.name ?? ""
        self.isVolatile = possession?.volatile ?? true
        self.assetPool = possession?.pool
        self.dismissSheet = dismissSheet
    }
    
    
    private var assetWithSameNameDoesExist: Bool {
        let possessions = repository.getPossessions()
        let receivables = repository.getReceivables()
        let sameNamedReceivableExists = receivables.contains(where: {$0.name == name})
        let otherSameNamedPossessionExists = possessions.contains(where: {$0.name == name && $0 != possession})
        return otherSameNamedPossessionExists || sameNamedReceivableExists
    }
    
    private var nameIsEmpty: Bool {
        name.isEmpty
    }
    
    private func validatePossession() throws -> AssetPool {
        if assetWithSameNameDoesExist {
            throw PossessionValidationError.sameNameAlreadyExists
        }
        if nameIsEmpty {
            throw PossessionValidationError.emptyName
        }
        guard let assetPool else { throw PossessionValidationError.noAssetPoolSelected }
        return assetPool
    }
    
    private func createPossession() throws {
        let assetPool = try validatePossession()
        repository.createPossession(name: name, pool: assetPool, isVolatile: isVolatile)
    }
    
    private func updatePossession() throws {
        guard let possession else { return }
        let assetPool = try validatePossession()
        repository.updatePossession(possession: possession, newName: name, newIsVolatile: isVolatile, newPool: assetPool)
    }
    
    func savePossession() throws {
        Self.logger.debug("savePossession()")
        if possession.isNil {
            try createPossession()
        } else {
            try updatePossession()
        }
    }
    
    func deletePossession() {
        Self.logger.debug("deletePossession()")
        guard let possession else { return }
        repository.delete(possession: possession)
    }
    
    func getAssetPools() -> [AssetPool] {
        Self.logger.debug("getAssetPools()")
        return repository.getAssetPools()
    }
}

enum PossessionValidationError: String, LocalizedError {
    case emptyName = "No name was chosen!"
    case noAssetPoolSelected = "No asset pool was chosen!"
    case sameNameAlreadyExists = "An asset with the same name already exists!"
    var errorDescription: String? {
        self.rawValue
    }
}
