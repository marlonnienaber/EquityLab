import os
import CoreData

@Observable
class LiabilityFormViewModel {
    @ObservationIgnored private static let logger = Logger(subsystem: .settingsTab, component: .liabilityFormViewModel)
    
    @ObservationIgnored private let liabilityRepository: LiabilityRepository
    
    var liabilityPool: LiabilityPool?
    var name = ""
    var grantDate = Date.now
    var creditor: LoanPartner?
    var disbursedAmount: Decimal = 0
    var liabilityValidationError: LiabilityValidationError?
    var showValidationErrorAlert = false
    let dismissSheet: () -> ()
    
    
    init(
        liabilityRepository: LiabilityRepository = .production,
        dismissSheet: @escaping () -> ()
    ) {
        Self.logger.debug("LiabilityFormViewModel()")
        self.liabilityRepository = liabilityRepository
        self.dismissSheet = dismissSheet
    }
    
    
    private var liabilityWithSameNameDoesExist: Bool {
        Self.logger.debug("liabilityWithSameNameDoesExist")
        let liabilities = liabilityRepository.liabilities
        return liabilities.contains(where: {$0.name == name})
    }
    
    private var disbursedAmountNotStrictlyPositive: Bool {
        Self.logger.debug("disbursedAmountNotStrictlyPositive")
        return disbursedAmount <= .zero
    }
    
    private var nameIsEmpty: Bool {
        Self.logger.debug("nameIsEmpty")
        return name.isEmpty
    }
    
    private func validateLiability() throws -> (LiabilityPool,LoanPartner) {
        Self.logger.debug("validateReceivable()")
        if liabilityWithSameNameDoesExist {
            throw LiabilityValidationError.sameNameAlreadyExists
        }
        if disbursedAmountNotStrictlyPositive {
            throw LiabilityValidationError.disbursedAmountNotStrictlyPositive
        }
        if nameIsEmpty {
            throw LiabilityValidationError.emptyName
        }
        guard let liabilityPool else { throw LiabilityValidationError.noLiabilityPoolSelected }
        guard let creditor else { throw LiabilityValidationError.noCreditorSelected }
        return (liabilityPool,creditor)
    }
    
    func createLiability() throws {
        Self.logger.debug("createLiability()")
        let (liabilityPool,creditor) = try validateLiability()
        liabilityRepository.createLiability(name: name,
                                            pool: liabilityPool,
                                            creditor: creditor,
                                            disbursedAmount: disbursedAmount,
                                            grantDate: grantDate)
    }
    
    func getLiabilityPools() -> [LiabilityPool] {
        Self.logger.debug("getLiabilityPools()")
        return liabilityRepository.liabilityPools
    }
}

enum LiabilityValidationError: String, LocalizedError {
    case disbursedAmountNotStrictlyPositive = "The disbursed amount must be strictly positive!"
    case emptyName = "No name was chosen!"
    case noLiabilityPoolSelected = "No liability pool was chosen!"
    case noCreditorSelected = "No creditor was chosen!"
    case sameNameAlreadyExists = "A liability with the same name already exists!"
    var errorDescription: String? {
        return self.rawValue
    }
}
