import os
import CoreData

@Observable
class AssetFormViewModel {
    @ObservationIgnored private static let logger = Logger(subsystem: .settingsTab, component: .assetFormViewModel)
    
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
    var receivableValidationError: ReceivableValidationError?
    var possessionValidationError: PossessionValidationError?
    var showValidationErrorAlert = false
    let dismissSheet: () -> ()
    
    
    init(asset: Asset? = nil, repository: AssetRepository = .production, dismissSheet: @escaping () -> ()) {
        Self.logger.debug("AssetFormViewModel()")
        self.repository = repository
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
        Self.logger.debug("assetWithSameNameDoesNotExist")
        let assets = repository.fetchAssets()
        return !assets.contains(where: {$0.name == assetName})
    }
    
    private var assetWithSameNameDoesExist: Bool {
        Self.logger.debug("assetWithSameNameDoesExist")
        let assets = repository.fetchAssets()
        return assets.contains(where: {$0.name == assetName})
    }
    
    private var repaidSurpassesInitialAmount: Bool {
        Self.logger.debug("repaidSurpassesInitialAmount")
        return receivableRepaidAmount > receivableInitialAmount
    }
    
    private var repaidAmountNegative: Bool {
        Self.logger.debug("repaidAmountNegative")
        return receivableRepaidAmount < .zero
    }
    
    private var initialAmountNegative: Bool {
        Self.logger.debug("initialAmountNegative")
        return receivableInitialAmount < .zero
    }
    
    private var nameIsEmpty: Bool {
        Self.logger.debug("nameIsEmpty")
        return assetName.isEmpty
    }
    
    private var debtorIsEmpty: Bool {
        Self.logger.debug("debtorIsEmpty")
        return receivableDebtor.isEmpty
    }
    
    private func validateReceivable(for useCase: ValidationUseCase) throws -> AssetPool {
        Self.logger.debug("validateReceivable()")
        if useCase == .create && assetWithSameNameDoesExist {
            throw ReceivableValidationError.sameNameAlreadyExists
        }
        if repaidSurpassesInitialAmount {
            throw ReceivableValidationError.repaidSurpassesInitialAmount
        }
        if initialAmountNegative {
            throw ReceivableValidationError.initialAmountNegative
        }
        if repaidAmountNegative {
            throw ReceivableValidationError.repaidAmountNegative
        }
        if nameIsEmpty {
            throw ReceivableValidationError.emptyName
        }
        if debtorIsEmpty {
            throw ReceivableValidationError.emptyDebtor
        }
        guard let assetPool else { throw ReceivableValidationError.noAssetPoolSelected }
        return assetPool
    }
    
    private func validatePossession(for useCase: ValidationUseCase) throws -> AssetPool {
        if useCase == .create && assetWithSameNameDoesExist {
            throw PossessionValidationError.sameNameAlreadyExists
        }
        if nameIsEmpty {
            throw PossessionValidationError.emptyName
        }
        guard let assetPool else { throw PossessionValidationError.noAssetPoolSelected }
        return assetPool
    }
    
    private func createReceivable() throws {
        Self.logger.debug("createReceivable()")
        let assetPool = try validateReceivable(for: ValidationUseCase.create)
        repository.createReceivable(name: assetName,
                                    pool: assetPool,
                                    debtor: receivableDebtor,
                                    initialAmount: receivableInitialAmount,
                                    repaidAmount: receivableRepaidAmount,
                                    grantDate: receivableGrantDate)
    }
    
    private func updateReceivable() throws {
        Self.logger.debug("updateReceivable()")
        guard let receivable = asset as? Receivable else { return }
        let _ = try validateReceivable(for: ValidationUseCase.update) /* TODO: use return value to make assetPool update possible */
        repository.updateReceivable(receivable: receivable,
                                    newName: assetName,
                                    newDebtor: receivableDebtor,
                                    newInitialAmount: receivableInitialAmount,
                                    newRepaidAmount: receivableRepaidAmount,
                                    newGrantDate: receivableGrantDate)
    }
    
    private func createPossession() throws {
        Self.logger.debug("createPossession()")
        let assetPool = try validatePossession(for: ValidationUseCase.create)
        repository.createPossession(name: assetName, pool: assetPool, isVolatile: possessionIsVolatile)
    }
    
    private func updatePossession() throws {
        Self.logger.debug("updatePossession(possession)")
        guard let possession = asset as? Possession else { return }
        let _ = try validatePossession(for: ValidationUseCase.update) /* TODO: use return value to make assetPool update possible */
        repository.updatePossession(possession: possession, newName: assetName, newIsVolatile: possessionIsVolatile)
    }
    
    func saveReceivable() throws {
        if asset.isNil {
            try createReceivable()
        } else {
            try updateReceivable()
        }
    }
    
    func savePossession() throws {
        if asset.isNil {
            try createPossession()
        } else {
            try updatePossession()
        }
    }
    
    func deleteAsset() {
        Self.logger.debug("deleteAsset()")
        guard let asset else { return }
        repository.delete(asset: asset)
    }
    
    func getAssetPools() -> [AssetPool] {
        Self.logger.debug("getAssetPools()")
        return repository.fetchAssetPools()
    }
}

enum ReceivableValidationError: String, LocalizedError {
    case initialAmountNegative = "The initial amount can not be negative!"
    case repaidAmountNegative = "The repaid amount can not be negative!"
    case repaidSurpassesInitialAmount = "The initial amount must be bigger or equal to the repaid amount"
    case emptyName = "No name was chosen!"
    case emptyDebtor = "No debor was chosen!"
    case noAssetPoolSelected = "No asset pool was chosen!"
    case sameNameAlreadyExists = "An asset with the same name already exists!"
    var errorDescription: String? {
        return self.rawValue
    }
}

enum PossessionValidationError: String, LocalizedError {
    case emptyName = "No name was chosen!"
    case noAssetPoolSelected = "No asset pool was chosen!"
    case sameNameAlreadyExists = "An asset with the same name already exists!"
    var errorDescription: String? {
        return self.rawValue
    }
}

enum ValidationUseCase {
    case update
    case create
}
