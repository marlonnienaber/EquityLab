import os
import CoreData

@Observable
class LiabilityFormViewModel {
    @ObservationIgnored private static let logger = Logger(subsystem: .settingsTab, component: .liabilityFormViewModel)
    
    @ObservationIgnored private let repository: LiabilityRepository
    var liabilityPool: LiabilityPool?
    var liability: Liability?
    var liabilityName: String
    var liabilityGrantDate: Date
    var liabilityInitialAmount: Double
    var liabilityRepaidAmount: Double
    var liabilityCreditor: String
    var liabilityValidationError: LiabilityValidationError?
    var showValidationErrorAlert = false
    let dismissSheet: () -> ()
    
    
    init(liability: Liability? = nil, repository: LiabilityRepository = .production, dismissSheet: @escaping () -> ()) {
        Self.logger.debug("LiabilityFormViewModel()")
        self.repository = repository
        self.liability = liability
        self.liabilityPool = liability?.pool
        if let liability {
            self.liabilityName = liability.name
            self.liabilityGrantDate = liability.grantDate
            self.liabilityInitialAmount = liability.initialAmount
            self.liabilityRepaidAmount = liability.repaidAmount
            self.liabilityCreditor = liability.creditor
        } else {
            self.liabilityName = ""
            self.liabilityGrantDate = Date.now
            self.liabilityInitialAmount = 0.0
            self.liabilityRepaidAmount = 0.0
            self.liabilityCreditor = ""
        }
        self.dismissSheet = dismissSheet
    }
    
    
    private var liabilityWithSameNameDoesExist: Bool {
        Self.logger.debug("liabilityWithSameNameDoesExist")
        let liabilities = repository.fetchLiabilities()
        return liabilities.contains(where: {$0.name == liabilityName})
    }
    
    private var repaidSurpassesInitialAmount: Bool {
        Self.logger.debug("repaidSurpassesInitialAmount")
        return liabilityRepaidAmount > liabilityInitialAmount
    }
    
    private var repaidAmountNegative: Bool {
        Self.logger.debug("repaidAmountNegative")
        return liabilityRepaidAmount < .zero
    }
    
    private var initialAmountNegative: Bool {
        Self.logger.debug("initialAmountNegative")
        return liabilityInitialAmount < .zero
    }
    
    private var nameIsEmpty: Bool {
        Self.logger.debug("nameIsEmpty")
        return liabilityName.isEmpty
    }
    
    private var creditorIsEmpty: Bool {
        Self.logger.debug("creditorIsEmpty")
        return liabilityCreditor.isEmpty
    }
    
    private func validateLiability(for useCase: ValidationUseCase) throws -> LiabilityPool {
        Self.logger.debug("validateReceivable()")
        if useCase == .create && liabilityWithSameNameDoesExist {
            throw LiabilityValidationError.sameNameAlreadyExists
        }
        if repaidSurpassesInitialAmount {
            throw LiabilityValidationError.repaidSurpassesInitialAmount
        }
        if initialAmountNegative {
            throw LiabilityValidationError.initialAmountNegative
        }
        if repaidAmountNegative {
            throw LiabilityValidationError.repaidAmountNegative
        }
        if nameIsEmpty {
            throw LiabilityValidationError.emptyName
        }
        if creditorIsEmpty {
            throw LiabilityValidationError.emptyCreditor
        }
        guard let liabilityPool else { throw LiabilityValidationError.noLiabilityPoolSelected }
        return liabilityPool
    }
    
    private func createLiability() throws {
        Self.logger.debug("createLiability()")
        let liabilityPool = try validateLiability(for: ValidationUseCase.create)
        repository.createLiability(name: liabilityName,
                                   pool: liabilityPool,
                                   creditor: liabilityCreditor,
                                   initialAmount: liabilityInitialAmount,
                                   repaidAmount: liabilityRepaidAmount,
                                   grantDate: liabilityGrantDate)
    }
    
    private func updateLiability() throws {
        Self.logger.debug("updateLiability()")
        guard let liability else { return }
        let _ = try validateLiability(for: ValidationUseCase.update) /* TODO: use return value to make liabilityPool update possible */
        repository.updateLiability(liability: liability,
                                   newName: liabilityName,
                                   newCreditor: liabilityCreditor,
                                   newInitialAmount: liabilityInitialAmount,
                                   newRepaidAmount: liabilityRepaidAmount,
                                   newGrantDate: liabilityGrantDate)
    }
    
    func saveLiability() throws {
        Self.logger.debug("saveLiability()")
        if liability.isNil {
            try createLiability()
        } else {
            try updateLiability()
        }
    }
    
    func deleteLiability() {
        Self.logger.debug("deleteLiability()")
        guard let liability else { return }
        repository.delete(liability: liability)
    }
    
    func getLiabilityPools() -> [LiabilityPool] {
        Self.logger.debug("getLiabilityPools()")
        return repository.fetchLiabilityPools()
    }
}

enum LiabilityValidationError: String, LocalizedError {
    case initialAmountNegative = "The initial amount can not be negative!"
    case repaidAmountNegative = "The repaid amount can not be negative!"
    case repaidSurpassesInitialAmount = "The initial amount must be bigger or equal to the repaid amount"
    case emptyName = "No name was chosen!"
    case emptyCreditor = "No creditor was chosen!"
    case noLiabilityPoolSelected = "No liability pool was chosen!"
    case sameNameAlreadyExists = "A liability with the same name already exists!"
    var errorDescription: String? {
        return self.rawValue
    }
}
