import os
import CoreData

@Observable
class ReceivableFormViewModel {
    @ObservationIgnored private static let logger = Logger(subsystem: .settingsTab, component: .receivableFormViewModel)
    
    @ObservationIgnored private let assetRepository: AssetRepository
    
    var receivable: Receivable?
    var assetPool: AssetPool?
    var name: String
    var debtor: LoanPartner?
    var grantDate: Date
    var disbursedAmount: Decimal
    var receivableValidationError: ReceivableValidationError?
    var showValidationErrorAlert = false
    let deletionPossible: Bool
    let dismissSheet: () -> ()
    
    
    init(
        assetRepository: AssetRepository = .production,
        receivable: Receivable? = nil,
        deletionPossible: Bool = false,
        dismissSheet: @escaping () -> ()
    ) {
        Self.logger.debug("ReceivableCreateViewModel()")
        self.assetRepository = assetRepository
        self.receivable = receivable
        self.assetPool = receivable?.pool
        self.name = receivable?.name ?? ""
        self.debtor = receivable?.debtor
        self.grantDate = .now
        self.disbursedAmount = 0.0
        self.deletionPossible = deletionPossible
        self.dismissSheet = dismissSheet
    }
    
    
    private var assetWithSameNameDoesExist: Bool {
        let possessions = assetRepository.getPossessions()
        let receivables = assetRepository.getReceivables()
        let sameNamedReceivableExists = receivables.contains(where: {$0.name == name && $0 != receivable})
        let sameNamedPossessionExists = possessions.contains(where: {$0.name == name})
        return sameNamedReceivableExists || sameNamedPossessionExists
    }
    
    private var disbursedAmountNotStrictlyPositive: Bool {
        return disbursedAmount <= .zero
    }
    
    private var nameIsEmpty: Bool {
        return name.isEmpty
    }
    
    private func validateReceivable() throws -> (AssetPool,LoanPartner) {
        if assetWithSameNameDoesExist {
            throw ReceivableValidationError.sameNameAlreadyExists
        }
        if receivable.isNil && disbursedAmountNotStrictlyPositive {
            throw ReceivableValidationError.disbursedAmountNotStrictlyPositive
        }
        if nameIsEmpty {
            throw ReceivableValidationError.emptyName
        }
        guard let assetPool else { throw ReceivableValidationError.noAssetPoolSelected }
        guard let debtor else { throw ReceivableValidationError.noDebtorSelected }
        return (assetPool,debtor)
    }
    
    private func createReceivable() throws {
        let (assetPool,debtor) = try validateReceivable()
        assetRepository.createReceivable(name: name,
                                         debtor: debtor,
                                         pool: assetPool,
                                         disbursedAmount: disbursedAmount,
                                         grantDate: grantDate)
    }
    
    private func updateReceivable(receivable: Receivable) throws {
        let (assetPool,debtor) = try validateReceivable()
        assetRepository.updateReceivable(receivable: receivable, newName: name, newDebtor: debtor, newPool: assetPool)
    }
    
    func saveReceivable() throws {
        Self.logger.debug("saveReceivable()")
        if let receivable {
            try updateReceivable(receivable: receivable)
        } else {
            try createReceivable()
        }
    }
    
    func deleteReceivable() {
        Self.logger.debug("getAssetPools()")
        guard let receivable else { return }
        assetRepository.delete(receivable: receivable)
    }
    
    func getAssetPools() -> [AssetPool] {
        Self.logger.debug("getAssetPools()")
        return assetRepository.getAssetPools()
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

