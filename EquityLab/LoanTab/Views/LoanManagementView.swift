import SwiftUI

struct LoanManagementView: View {
    @State var viewModel = LoanManagementViewModel()
    
    var body: some View {
        NavigationView {
            List {
                if viewModel.receivables.isNotEmpty {
                    Section("Receivables") {
                        ForEach(viewModel.receivables) { receivable in
                            Button {
                                viewModel.activeLoanUpdateSheet = .receivableUpdateSheet(receivable)
                            } label: {
                                receivableCell(for: receivable)
                            }
                        }
                        .onDelete{ indexSet in
                            viewModel.deleteReceivables(for: indexSet)
                        }
                    }
                }
                if viewModel.liabilities.isNotEmpty {
                    Section("Liabilities") {
                        ForEach(viewModel.liabilities) { liability in
                            Button {
                                viewModel.activeLoanUpdateSheet = .liabilityUpdateSheet(liability)
                            } label: {
                                liabilityCell(for: liability)
                            }
                        }
                        .onDelete{ indexSet in
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
            .sheet(item: $viewModel.activeLoanUpdateSheet) { activeSheet in
                updateSheetContent(for: activeSheet)
            }
            .sheet(isPresented: $viewModel.showLoanUpdatePickerSheet) {
                loanUpdatePickerMenu
                    .presentationDetents([.fraction(0.25)])
            }
        }
    }
    
    func receivableCell(for receivable: Receivable) -> some View {
        HStack {
            if let initialAmountStringRepresentation = LocalizedCurrencyFormatter.shared.string(from: NSNumber(value: receivable.initialAmount)) {
                VStack(alignment: .leading) {
                    Text(receivable.name)
                        .foregroundColor(Color.primary)
                    Text(receivable.debtor)
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                    Text(initialAmountStringRepresentation)
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                }
                Spacer()
                CircularProgressView(progress: receivable.repaymentPercentage)
                    .frame(width: 37, height: 37)
            }
        }
    }
    
    private func liabilityCell(for liability: Liability) -> some View {
        HStack {
            if let initialAmountStringRepresentation = LocalizedCurrencyFormatter.shared.string(from: NSNumber(value: liability.initialAmount)) {
                VStack(alignment: .leading) {
                    Text(liability.name)
                        .foregroundColor(Color.primary)
                    Text(liability.creditor)
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                    Text(initialAmountStringRepresentation)
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                }
                Spacer()
                CircularProgressView(progress: liability.repaymentPercentage)
                    .frame(width: 37, height: 37)
            }
        }
    }
    
    @ViewBuilder
    private func updateSheetContent(for sheetType: LoanUpdateSheet) -> some View {
        switch sheetType {
        case .receivableCreateSheet: ReceivableForm(viewModel: AssetFormViewModel{ viewModel.activeLoanUpdateSheet = nil } )
        case .liabilityCreateSheet: LiabilityForm(viewModel: LiabilityFormViewModel{ viewModel.activeLoanUpdateSheet = nil } )
        case .liabilityUpdateSheet(let liability): LiabilityForm(viewModel: LiabilityFormViewModel(liability: liability){ viewModel.activeLoanUpdateSheet = nil } )
        case .receivableUpdateSheet(let receivable): ReceivableForm(viewModel: AssetFormViewModel(asset: receivable){ viewModel.activeLoanUpdateSheet = nil } )
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
                    Button("Cancel"){
                        viewModel.activeLoanUpdateSheet = nil
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("OK") {
                        viewModel.showLoanUpdatePickerSheet = false
                        guard let selectedLoanType = viewModel.selectedLoanType else { return }
                        switch selectedLoanType {
                        case .receivable: viewModel.activeLoanUpdateSheet = .receivableCreateSheet
                        case .liability: viewModel.activeLoanUpdateSheet = .liabilityCreateSheet
                        }
                    }
                    .disabled(viewModel.selectedLoanType.isNil)
                }
            }
        }
    }
}
