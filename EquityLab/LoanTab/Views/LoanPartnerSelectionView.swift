import SwiftUI

struct LoanPartnerSelectionView: View {
    @State var viewModel: LoanPartnerSelectionViewModel

    var body: some View {
        List {
            ForEach(viewModel.loanPartners, id: \.name) { loanPartner in
                Button {
                    viewModel.selectedLoanPartner = loanPartner
                } label: {
                    HStack {
                        Text(loanPartner.name)
                        Spacer()
                        if loanPartner == viewModel.selectedLoanPartner {
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
        .alert("What should the name of the new person be?", isPresented: $viewModel.showCreateLoanPartnerAlert) {
            TextField("Value", text: $viewModel.newLoanPartnerName)
            Button("Cancel") {
                viewModel.showCreateLoanPartnerAlert = false
                viewModel.newLoanPartnerName = ""
            }
            Button("Save") {
                do {
                    try viewModel.createLoanPartner()
                    viewModel.newLoanPartnerName = ""
                } catch let error as LoanPartnerValidationError {
                    viewModel.loanPartnerValidationError = error
                    viewModel.showLoanPartnerValidationErrorAlert = true
                } catch {}
            }
        }
        .alert(isPresented: $viewModel.showLoanPartnerValidationErrorAlert, error: viewModel.loanPartnerValidationError) { _ in
            Button("OK", role: .cancel) {
                viewModel.loanPartnerValidationError = nil
                viewModel.showCreateLoanPartnerAlert = true
            }
        } message: { _ in }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                EditButton()
                    .disabled(viewModel.loanPartners.isEmpty)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.showCreateLoanPartnerAlert = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .onDisappear() {
            viewModel.setInParentViewModel(viewModel.selectedLoanPartner)
        }
    }
}
