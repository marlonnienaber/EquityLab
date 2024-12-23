//import os
//import CoreData
//
//@Observable
//class ReceivableFormViewModel {
//    @ObservationIgnored private static let logger = Logger(subsystem: .settingsTab, component: .receivableFormViewModel)
//    
//    @ObservationIgnored private let repository: AssetRepository
//    var assetPool: AssetPool?
//    var receivable: Receivable?
//    var name: String
//    var grantDate: Date
//    var debtor: String
//    var initialAmount: Decimal
//    var repaidAmount: Decimal
//    
//    var showPopover: Bool = false
//    var receivableValidationError: ReceivableValidationError?
//    var showValidationErrorAlert = false
//    let dismissSheet: () -> ()
//    
//    
//    init(receivable: Receivable? = nil, repository: AssetRepository = .production, dismissSheet: @escaping () -> ()) {
//        Self.logger.debug("AssetFormViewModel()")
//        self.repository = repository
//        self.receivable = receivable
//        self.name = receivable?.name ?? ""
//        self.assetPool = receivable?.pool
//        self.grantDate = receivable?.grantDate ?? .now
//        self.debtor = receivable?.debtor ?? ""
//        self.initialAmount = receivable?.initialAmount.decimalValue ?? 0
//        self.repaidAmount = receivable?.repaidAmount.decimalValue ?? 0
//        self.dismissSheet = dismissSheet
//    }
//    
//    
//    private var assetWithSameNameDoesExist: Bool {
//        Self.logger.debug("assetWithSameNameDoesExist")
//        let possessions = repository.getPossessions()
//        let receivables = repository.getReceivables()
//        let sameNamedPossessionExists = possessions.contains(where: {$0.name == name})
//        let otherSameNamedReceivableExists = receivables.contains(where: {$0.name == name && $0 != receivable})
//        return otherSameNamedReceivableExists || sameNamedPossessionExists
//    }
//    
//    private var repaidSurpassesInitialAmount: Bool {
//        Self.logger.debug("repaidSurpassesInitialAmount")
//        return repaidAmount > initialAmount
//    }
//    
//    private var initialAmountNotStrictlyPositive: Bool {
//        Self.logger.debug("initialAmountNegative")
//        return initialAmount <= .zero
//    }
//    
//    private var nameIsEmpty: Bool {
//        Self.logger.debug("nameIsEmpty")
//        return name.isEmpty
//    }
//    
//    private var debtorIsEmpty: Bool {
//        Self.logger.debug("debtorIsEmpty")
//        return debtor.isEmpty
//    }
//    
//    private func validateReceivable() throws -> AssetPool {
//        Self.logger.debug("validateReceivable()")
//        if assetWithSameNameDoesExist {
//            throw ReceivableValidationError.sameNameAlreadyExists
//        }
//        if repaidSurpassesInitialAmount {
//            throw ReceivableValidationError.repaidSurpassesInitialAmount
//        }
//        if initialAmountNotStrictlyPositive {
//            throw ReceivableValidationError.initialAmountNotStrictlyPositive
//        }
//        if nameIsEmpty {
//            throw ReceivableValidationError.emptyName
//        }
//        if debtorIsEmpty {
//            throw ReceivableValidationError.emptyDebtor
//        }
//        guard let assetPool else { throw ReceivableValidationError.noAssetPoolSelected }
//        return assetPool
//    }
//    
//    private func createReceivable() throws {
//        Self.logger.debug("createReceivable()")
//        let assetPool = try validateReceivable()
//        repository.createReceivable(name: name,
//                                    pool: assetPool,
//                                    debtor: debtor,
//                                    initialAmount: initialAmount,
//                                    repaidAmount: repaidAmount,
//                                    grantDate: grantDate)
//    }
//    
//    private func updateReceivable() throws {
//        Self.logger.debug("updateReceivable()")
//        guard let receivable else { return }
//        let assetPool = try validateReceivable()
//        repository.updateReceivable(receivable: receivable,
//                                    newName: name,
//                                    newDebtor: debtor,
//                                    newInitialAmount: initialAmount,
//                                    newRepaidAmount: repaidAmount,
//                                    newGrantDate: grantDate,
//                                    newPool: assetPool)
//    }
//    
//    func saveReceivable() throws {
//        if receivable.isNil {
//            try createReceivable()
//        } else {
//            try updateReceivable()
//        }
//    }
//    
//    func deleteReceivable() {
//        Self.logger.debug("deleteAsset()")
//        guard let receivable else { return }
//        repository.delete(receivable: receivable)
//    }
//    
//    func getAssetPools() -> [AssetPool] {
//        Self.logger.debug("getAssetPools()")
//        return repository.getAssetPools()
//    }
//}

