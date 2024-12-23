import SwiftUI

struct LoanManagementView: View {
    @State var viewModel = LoanManagementViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                if viewModel.receivables.isNotEmpty {
                    Section("Receivables") {
                        ForEach(viewModel.receivables) { receivable in
                            if let debtor = viewModel.getDebtor(of: receivable) {
                                NavigationLink(value: Pair(receivable,debtor)) {
                                    receivableCell(for: receivable)
                                }
                            }
                        }
                        .onDelete { indexSet in
                            viewModel.deleteReceivables(for: indexSet)
                        }
                    }
                }
                if viewModel.liabilities.isNotEmpty {
                    Section("Liabilities") {
                        ForEach(viewModel.liabilities) { liability in
                            Button {
                                
                            } label: {
                                liabilityCell(for: liability)
                            }
                        }
                        .onDelete { indexSet in
                            viewModel.deleteLiabilities(for: indexSet)
                        }
                    }
                }
            }
            .navigationTitle("Loans")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                        .disabled(viewModel.hasNoLoans)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.showLoanUpdatePickerSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(item: $viewModel.activeLoanCreateSheet) { activeSheet in
                updateSheetContent(for: activeSheet)
            }
            .sheet(isPresented: $viewModel.showLoanUpdatePickerSheet) {
                loanUpdatePickerMenu
                    .presentationDetents([.fraction(0.25)])
            }
            .navigationDestination(for: Pair<Receivable,LoanPartner>.self) { pair in
                ReceivableDetailView(viewModel: ReceivableDetailViewModel(receivable: pair.first, debtor: pair.second))
            }
        }
    }
    
    func receivableCell(for receivable: Receivable) -> some View {
        HStack {
            if let disbursedAmountString = viewModel.getDisbursedAmountString(for: receivable) {
                VStack(alignment: .leading) {
                    Text(receivable.name)
                        .foregroundColor(Color.primary)
                    Text(viewModel.getDebtorName(of: receivable))
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                    Text(disbursedAmountString)
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                }
                Spacer()
                CircularProgressView(progress: viewModel.getRepaymentPercentage(for: receivable))
                    .frame(width: 37, height: 37)
            }
        }
    }
    
    private func liabilityCell(for liability: Liability) -> some View {
        HStack {
            if let initialAmountString = viewModel.getDisbursedAmountString(for: liability) {
                VStack(alignment: .leading) {
                    Text(liability.name)
                        .foregroundColor(Color.primary)
                    Text(viewModel.getCreditorName(of: liability))
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                    Text(initialAmountString)
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                }
                Spacer()
                CircularProgressView(progress: viewModel.getRepaymentPercentage(for: liability))
                    .frame(width: 37, height: 37)
            }
        }
    }
    
    @ViewBuilder
    private func updateSheetContent(for sheetType: LoanCreateSheet) -> some View {
        switch sheetType {
        case .receivableCreateSheet: ReceivableForm(viewModel: ReceivableFormViewModel { viewModel.activeLoanCreateSheet = nil })
        case .liabilityCreateSheet: EmptyView()
        }
    }
    
    private var loanUpdatePickerMenu: some View {
        NavigationView {
            VStack {
                Text("Which kind of loan would you like to add?")
                Picker("", selection: $viewModel.selectedLoanType) {
                    Text("Receivable").tag(LoanType.receivable)
                    Text("Liability").tag(LoanType.liability)
                    Text("none selected").tag(LoanType?.none)
                }
                .pickerStyle(MenuPickerStyle())
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        viewModel.showLoanUpdatePickerSheet = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("OK") {
                        viewModel.showLoanUpdatePickerSheet = false
                        guard let selectedLoanType = viewModel.selectedLoanType else { return }
                        switch selectedLoanType {
                        case .receivable: viewModel.activeLoanCreateSheet = .receivableCreateSheet
                        case .liability: viewModel.activeLoanCreateSheet = .liabilityCreateSheet
                        }
                    }
                    .disabled(viewModel.selectedLoanType.isNil)
                }
            }
        }
    }
}

