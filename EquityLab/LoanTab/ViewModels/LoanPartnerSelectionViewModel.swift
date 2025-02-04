import os
import SwiftUI
import CoreData

@Observable
class LoanPartnerSelectionViewModel {
    @ObservationIgnored private static let logger = Logger(subsystem: .loanManagementTab, component: .personSelectionViewModel)
    
    @ObservationIgnored private var loanPartnerRepository: LoanPartnerRepository
    @ObservationIgnored private var assetRepository: AssetRepository
    @ObservationIgnored private var liabilityRepository: LiabilityRepository
    var loanPartners = [LoanPartner]()
    var selectedLoanPartner: LoanPartner?
    var newLoanPartnerName = ""
    let setInParentViewModel: (LoanPartner?) -> ()
    var loanPartnerValidationError: LoanPartnerValidationError?
    var showCreateLoanPartnerAlert = false
    var showLoanPartnerValidationErrorAlert = false
    
    init(
        loanPartnerRepository: LoanPartnerRepository = .production,
        assetRepository: AssetRepository = .production,
        liabilityRepository: LiabilityRepository = .production,
        selectedLoanPartner: LoanPartner?,
        onDismiss: @escaping (LoanPartner?) -> ()
    ) {
        Self.logger.debug("PersonSelectionViewModel()")
        self.loanPartnerRepository = loanPartnerRepository
        self.assetRepository = assetRepository
        self.liabilityRepository = liabilityRepository
        self.selectedLoanPartner = selectedLoanPartner
        self.setInParentViewModel = onDismiss
        self.loanPartners = loanPartnerRepository.getLoanPartners()
        loanPartnerRepository.add(observer: self)
    }
    
    private var nameIsEmpty: Bool {
        newLoanPartnerName.isEmpty
    }
    
    private var loanPartnerWithSameNameDoesExist: Bool {
        loanPartnerRepository.getLoanPartners().contains(where: { $0.name == newLoanPartnerName })
    }
    
    private func validateLoanPartner() throws {
        if nameIsEmpty {
            throw LoanPartnerValidationError.emptyName
        }
        if loanPartnerWithSameNameDoesExist {
            throw LoanPartnerValidationError.loanPartnerWithSameNameAlreadyExists
        }
    }
    
    func createLoanPartner() throws {
        Self.logger.debug("createLoanPartner()")
        try validateLoanPartner()
        loanPartnerRepository.createLoanPartner(with: newLoanPartnerName)
    }
    
    func deleteLoanPartners(withIndices indexSet: IndexSet) throws {
        Self.logger.debug("deleteLoanPartners(withIndices indexSet)")
        guard indexSet.count == 1, let index = indexSet.first else { return }
        let loanParnter = loanPartners[index]
        let associatedReceivables = assetRepository.getReceivables().filter{ $0.debtor == loanParnter }
        let associatedLiabilities = liabilityRepository.getLiabilities().filter{ $0.creditor == loanParnter }
        if associatedReceivables.isNotEmpty || associatedLiabilities.isNotEmpty {
            throw LoanPartnerValidationError.canNotBeDeleted
        }
        if loanParnter == selectedLoanPartner {
            selectedLoanPartner = nil
        }
        loanPartnerRepository.deleteLoanPartner(loanParnter)
    }
}

extension LoanPartnerSelectionViewModel: LoanPartnerObserver {
    func notifyAfterLoanPartnerUpdate() {
        Self.logger.debug("notifyAfterLoanPartnerUpdate")
        loanPartners = loanPartnerRepository.getLoanPartners()
    }
}

enum LoanPartnerValidationError: String, LocalizedError {
    case emptyName = "No name was chosen!"
    case loanPartnerWithSameNameAlreadyExists = "A person with the same name already exists!"
    case canNotBeDeleted = "The person is associated to at least one receivable or liability and can therefore not be deleted!"
    var errorDescription: String? {
        return self.rawValue
    }
}
