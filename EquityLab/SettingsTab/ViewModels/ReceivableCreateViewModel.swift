import os
import CoreData

@Observable
class ReceivableCreateViewModel {
    @ObservationIgnored private static let logger = Logger(subsystem: .settingsTab, component: .receivableFormViewModel)
    
    @ObservationIgnored private let assetRepository: AssetRepository
    
    var assetPool: AssetPool?
    var name =  ""
    var grantDate = Date.now
    var debtor: Person?
    var disbursedAmount: Decimal = 0.0
    var receivableValidationError: ReceivableValidationError?
    var showValidationErrorAlert = false
    let dismissSheet: () -> ()
    
    
    init(
        assetRepository: AssetRepository = .production,
        dismissSheet: @escaping () -> ()
    ) {
        Self.logger.debug("ReceivableFormViewModel()")
        self.assetRepository = assetRepository
        self.dismissSheet = dismissSheet
    }
    
    
    private var assetWithSameNameDoesExist: Bool {
        Self.logger.debug("assetWithSameNameDoesExist")
        let possessions = assetRepository.possessions
        let receivables = assetRepository.receivables
        let sameNamedReceivableExists = receivables.contains(where: {$0.name == name })
        let sameNamedPossessionExists = possessions.contains(where: {$0.name == name})
        return sameNamedReceivableExists || sameNamedPossessionExists
    }
    
    private var disbursedAmountNotStrictlyPositive: Bool {
        Self.logger.debug("disbursedAmountNotStrictlyPositive")
        return disbursedAmount <= .zero
    }
    
    private var nameIsEmpty: Bool {
        Self.logger.debug("nameIsEmpty")
        return name.isEmpty
    }
    
    private func validateReceivable() throws -> (AssetPool,Person) {
        Self.logger.debug("validateReceivable()")
        if assetWithSameNameDoesExist {
            throw ReceivableValidationError.sameNameAlreadyExists
        }
        if disbursedAmountNotStrictlyPositive {
            throw ReceivableValidationError.disbursedAmountNotStrictlyPositive
        }
        if nameIsEmpty {
            throw ReceivableValidationError.emptyName
        }
        guard let assetPool else { throw ReceivableValidationError.noAssetPoolSelected }
        guard let debtor else { throw ReceivableValidationError.noDebtorSelected }
        return (assetPool,debtor)
    }
    
    func createReceivable() throws {
        Self.logger.debug("createReceivable()")
        let (assetPool,debtor) = try validateReceivable()
        assetRepository.createReceivable(name: name,
                                         pool: assetPool,
                                         debtor: debtor,
                                         disbursedAmount: disbursedAmount,
                                         grantDate: grantDate)
    }
    
    func getAssetPools() -> [AssetPool] {
        Self.logger.debug("getAssetPools()")
        return assetRepository.assetPools
    }
}

enum ReceivableValidationError: String, LocalizedError {
    case disbursedAmountNotStrictlyPositive = "The disbursed amount must be strictly positive!"
    case emptyName = "No name was chosen!"
    case noAssetPoolSelected = "No asset pool was chosen!"
    case noDebtorSelected = "No debtor was chosen!"
    case sameNameAlreadyExists = "An asset with the same name already exists!"
    var errorDescription: String? {
        return self.rawValue
    }
}
