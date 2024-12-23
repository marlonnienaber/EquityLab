import SwiftUI

struct PersonSelectionView: View {
    @State var viewModel: PersonSelectionViewModel

    var body: some View {
        List {
            ForEach(viewModel.persons, id: \.name) { person in
                Button {
                    viewModel.selectedPerson = person
                } label: {
                    HStack {
                        Text(person.name)
                        Spacer()
                        if person == viewModel.selectedPerson {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .foregroundStyle(.primary)
            }
            /* TODO: unly usable once function in PersonRepo implemented */
//            .onDelete { indexSet in
//                viewModel.deletePersons(withIndices: indexSet)
//            }
        }
        .navigationTitle("Select Debtor")
        .alert("What should the name of the new person be?", isPresented: $viewModel.showCreatePersonAlert) {
            TextField("Value", text: $viewModel.name)
            Button("Cancel") {
                viewModel.showCreatePersonAlert = false
                viewModel.name = ""
            }
            Button("Save") {
                do {
                    try viewModel.savePerson()
                    viewModel.name = ""
                } catch let error as PersonValidationError {
                    viewModel.personValidationError = error
                    viewModel.showPersonValidationErrorAlert = true
                } catch {}
            }
        }
        .alert(isPresented: $viewModel.showPersonValidationErrorAlert, error: viewModel.personValidationError) { _ in
            Button("OK", role: .cancel) {
                viewModel.personValidationError = nil
                viewModel.showCreatePersonAlert = true
            }
        } message: { _ in }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                EditButton()
                    .disabled(viewModel.persons.isEmpty)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.showCreatePersonAlert = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .onDisappear() {
            viewModel.setInParentViewModel(viewModel.selectedPerson)
        }
    }
}
