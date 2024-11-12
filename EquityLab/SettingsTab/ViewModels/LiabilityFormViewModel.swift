import os
import CoreData

@Observable
class LiabilityFormViewModel {
    @ObservationIgnored private static let logger = Logger(subsystem: .settingsTab, component: .liabilityFormViewModel)
    
    @ObservationIgnored private let liabilityRepository: LiabilityRepository
    var liability: Liability?
    
    var liabilityPool: LiabilityPool?
    var name: String
    var grantDate: Date
    var initialAmount: Double
    var repaidAmount: Double
    var creditor: Person?
    var liabilityValidationError: LiabilityValidationError?
    var showValidationErrorAlert = false
    let dismissSheet: () -> ()
    
    
    init(
        liability: Liability? = nil,
        liabilityRepository: LiabilityRepository = .production,
        personRepository: PersonRepository = .production,
        dismissSheet: @escaping () -> ()
    ) {
        Self.logger.debug("LiabilityFormViewModel()")
        self.liabilityRepository = liabilityRepository
        self.liability = liability
        self.liabilityPool = liability?.pool
        self.name = liability?.name ?? ""
        self.grantDate = liability?.grantDate ?? .now
        self.initialAmount = liability?.initialAmount ?? 0.0
        self.repaidAmount = liability?.repaidAmount ?? 0.0
        self.creditor = liability?.creditor
        self.dismissSheet = dismissSheet
    }
    
    
    private var liabilityWithSameNameDoesExist: Bool {
        Self.logger.debug("liabilityWithSameNameDoesExist")
        let liabilities = liabilityRepository.fetchLiabilities()
        return liabilities.contains(where: {$0.name == name && $0 != liability})
    }
    
    private var repaidSurpassesInitialAmount: Bool {
        Self.logger.debug("repaidSurpassesInitialAmount")
        return repaidAmount > initialAmount
    }
    
    private var initialAmountNotStrictlyPositive: Bool {
        Self.logger.debug("initialAmountNegative")
        return initialAmount <= .zero
    }
    
    private var nameIsEmpty: Bool {
        Self.logger.debug("nameIsEmpty")
        return name.isEmpty
    }
    
    private func validateLiability() throws -> (LiabilityPool,Person) {
        Self.logger.debug("validateReceivable()")
        if liabilityWithSameNameDoesExist {
            throw LiabilityValidationError.sameNameAlreadyExists
        }
        if repaidSurpassesInitialAmount {
            throw LiabilityValidationError.repaidSurpassesInitialAmount
        }
        if initialAmountNotStrictlyPositive {
            throw LiabilityValidationError.initialAmountNotStrictlyPositive
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
        liabilityRepository.createLiability(name: name,
                                   pool: liabilityPool,
                                   creditor: creditor,
                                   initialAmount: initialAmount,
                                   repaidAmount: repaidAmount,
                                   grantDate: grantDate)
    }
    
    private func updateLiability() throws {
        Self.logger.debug("updateLiability()")
        guard let liability else { return }
        let (liabilityPool,creditor) = try validateLiability()
        liabilityRepository.updateLiability(liability: liability,
                                   newName: name,
                                   newCreditor: creditor,
                                   newInitialAmount: initialAmount,
                                   newRepaidAmount: repaidAmount,
                                   newGrantDate: grantDate,
                                   newPool: liabilityPool)
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
        liabilityRepository.delete(liability: liability)
    }
    
    func getLiabilityPools() -> [LiabilityPool] {
        Self.logger.debug("getLiabilityPools()")
        return liabilityRepository.fetchLiabilityPools()
    }
}

enum LiabilityValidationError: String, LocalizedError {
    case initialAmountNotStrictlyPositive = "The initial amount must be strictly positive!"
    case repaidSurpassesInitialAmount = "The initial amount must be bigger or equal to the repaid amount"
    case emptyName = "No name was chosen!"
    case noLiabilityPoolSelected = "No liability pool was chosen!"
    case noCreditorSelected = "No creditor was chosen!"
    case sameNameAlreadyExists = "A liability with the same name already exists!"
    var errorDescription: String? {
        return self.rawValue
    }
}
