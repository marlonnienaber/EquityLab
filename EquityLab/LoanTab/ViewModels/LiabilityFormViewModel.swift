import os
import CoreData

@Observable
class LiabilityFormViewModel {
    @ObservationIgnored private static let logger = Logger(subsystem: .settingsTab, component: .liabilityFormViewModel)
    
    @ObservationIgnored private let liabilityRepository: LiabilityRepository
    
    var liabilityPool: LiabilityPool?
    var liability: Liability?
    var name: String
    var creditor: LoanPartner?
    var grantDate: Date
    var disbursedAmount: Decimal
    var liabilityValidationError: LiabilityValidationError?
    var showValidationErrorAlert = false
    let dismissSheet: () -> ()
    
    
    init(
        liabilityRepository: LiabilityRepository = .production,
        liability: Liability? = nil,
        dismissSheet: @escaping () -> ()
    ) {
        Self.logger.debug("LiabilityFormViewModel()")
        self.liabilityRepository = liabilityRepository
        self.liability = liability
        self.liabilityPool = liability?.pool
        self.name = liability?.name ?? ""
        self.creditor = liability?.creditor
        self.grantDate = .now
        self.disbursedAmount = 0.0
        self.dismissSheet = dismissSheet
    }
    
    
    private var liabilityWithSameNameDoesExist: Bool {
        Self.logger.debug("liabilityWithSameNameDoesExist")
        return liabilityRepository.getLiabilities().contains(where: {$0.name == name && $0 != liability})
    }
    
    private var disbursedAmountNotStrictlyPositive: Bool {
        Self.logger.debug("initialAmountNegative")
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
        if liability.isNil && disbursedAmountNotStrictlyPositive {
            throw LiabilityValidationError.disbursedAmountNotStrictlyPositive
        }
        if nameIsEmpty {
            throw LiabilityValidationError.emptyName
        }
        guard let liabilityPool else { throw LiabilityValidationError.noLiabilityPoolSelected }
        guard let creditor else { throw LiabilityValidationError.noCreditorSelected }
        return (liabilityPool,creditor)
    }
    
    private func createLiability() throws {
        Self.logger.debug("createLiability()")
        let (liabilityPool,creditor) = try validateLiability()
        liabilityRepository.createLiability(
            name: name,
            pool: liabilityPool,
            creditor: creditor,
            initialAmount: disbursedAmount,
            grantDate: grantDate
        )
    }
    
    private func updateLiability() throws {
        Self.logger.debug("updateLiability()")
        guard let liability else { return }
        let (liabilityPool,creditor) = try validateLiability()
        liabilityRepository.updateLiability(
            liability: liability,
            newName: name,
            newPool: liabilityPool,
            newCreditor: creditor
        )
    }
    
    func saveLiability() throws {
        Self.logger.debug("saveLiability()")
        if liability.isNil {
            try createLiability()
        } else {
            try updateLiability()
        }
    }
    
    func getLiabilityPools() -> [LiabilityPool] {
        Self.logger.debug("getLiabilityPools()")
        return liabilityRepository.getLiabilityPools()
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
