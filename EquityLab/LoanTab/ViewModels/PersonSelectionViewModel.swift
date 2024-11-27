import os
import SwiftUI
import CoreData

@Observable
class PersonSelectionViewModel {
    @ObservationIgnored private static let logger = Logger(subsystem: .loanManagementTab, component: .personSelectionViewModel)
    
    @ObservationIgnored private var personRepository: PersonRepository
    var persons = [Person]()
    var selectedPerson: Person?
    var personValidationError: PersonValidationError?
    var showCreatePersonAlert = false
    var showPersonValidationErrorAlert = false
    var name = ""
    let setInParentViewModel: (Person?) -> ()
    
    init(
        personRepository: PersonRepository = .production,
        selectedPerson: Person?,
        onDismiss: @escaping (Person?) -> ()
    ) {
        Self.logger.debug("PersonSelectionViewModel()")
        self.personRepository = personRepository
        self.selectedPerson = selectedPerson
        self.setInParentViewModel = onDismiss
        self.personRepository.$persons.registerObserver(self, keyPath: \.persons)
    }
    
    private var nameIsEmpty: Bool {
        name.isEmpty
    }
    
    private var personWithSameNameDoesExist: Bool {
        personRepository.persons.contains(where: { $0.name == name })
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

enum PersonValidationError: String, LocalizedError {
    case emptyName = "No name was chosen!"
    case personWithSameNameAlreadyExists = "A person with the same name already exists!"
    var errorDescription: String? {
        return self.rawValue
    }
}
