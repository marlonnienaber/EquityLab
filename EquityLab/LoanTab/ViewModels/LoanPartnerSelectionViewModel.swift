import os
import SwiftUI
import CoreData

@Observable
class LoanPartnerSelectionViewModel {
    @ObservationIgnored private static let logger = Logger(subsystem: .loanManagementTab, component: .personSelectionViewModel)
    
    @ObservationIgnored private var loanPartnerRepository: LoanPartnerRepository
    var loanPartners = [LoanPartner]()
    var selectedLoanPartner: LoanPartner?
    var newLoanPartnerName = ""
    let setInParentViewModel: (LoanPartner?) -> ()
    var loanPartnerValidationError: LoanPartnerValidationError?
    var showCreateLoanPartnerAlert = false
    var showLoanPartnerValidationErrorAlert = false
    
    init(
        loanPartnerRepository: LoanPartnerRepository = .production,
        selectedLoanPartner: LoanPartner?,
        onDismiss: @escaping (LoanPartner?) -> ()
    ) {
        Self.logger.debug("PersonSelectionViewModel()")
        self.loanPartnerRepository = loanPartnerRepository
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
        try validateLoanPartner()
        loanPartnerRepository.createPerson(with: newLoanPartnerName)
    }
    
    /* TODO: implement (UI for resolving conflicts must be implemented because LoanPartners have relations to other entities which can not be nil) */
//    func deletePersons(withIndices indexSet: IndexSet) {
//        indexSet.map{persons[$0]}.forEach{
//            if selectedPerson == $0 {
//                selectedPerson = nil
//            }
//            personRepository.deletePerson(person: $0)
//        }
//    }
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
    var errorDescription: String? {
        return self.rawValue
    }
}
