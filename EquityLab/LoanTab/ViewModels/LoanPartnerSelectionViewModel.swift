import os
import SwiftUI
import CoreData

@Observable
class LoanPartnerSelectionViewModel {
    @ObservationIgnored private static let logger = Logger(subsystem: .loanManagementTab, component: .personSelectionViewModel)
    
    @ObservationIgnored private var personRepository: LoanPartnerRepository
    var loanPartners = [LoanPartner]()
    var selectedPerson: LoanPartner?
    var personValidationError: PersonValidationError?
    var showCreatePersonAlert = false
    var showPersonValidationErrorAlert = false
    var name = ""
    let setInParentViewModel: (LoanPartner?) -> ()
    
    init(
        personRepository: LoanPartnerRepository = .production,
        selectedPerson: LoanPartner?,
        onDismiss: @escaping (LoanPartner?) -> ()
    ) {
        Self.logger.debug("PersonSelectionViewModel()")
        self.personRepository = personRepository
        self.selectedPerson = selectedPerson
        self.setInParentViewModel = onDismiss
        self.loanPartners = personRepository.fetchPersons()
        personRepository.add(observer: self)
    }
    
    private var nameIsEmpty: Bool {
        name.isEmpty
    }
    
    private var personWithSameNameDoesExist: Bool {
        personRepository.fetchPersons().contains(where: { $0.name == name })
    }
    
    private func validatePerson() throws {
        if nameIsEmpty {
            throw PersonValidationError.emptyName
        }
        if personWithSameNameDoesExist {
            throw PersonValidationError.personWithSameNameAlreadyExists
        }
    }
    
    func savePerson() throws {
        try validatePerson()
        personRepository.createPerson(with: name)
    }
    
    /* TODO: unly usable once function in PersonRepo implemented */
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
        Self.logger.debug("notifyAfterPersonUpdate")
        loanPartners = personRepository.fetchPersons()
    }
}

enum PersonValidationError: String, LocalizedError {
    case emptyName = "No name was chosen!"
    case personWithSameNameAlreadyExists = "A person with the same name already exists!"
    var errorDescription: String? {
        return self.rawValue
    }
}

