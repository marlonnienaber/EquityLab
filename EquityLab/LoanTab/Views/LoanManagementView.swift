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
            }
            .sheet(item: $viewModel.activeLoanUpdateSheet) { activeSheet in
                sheetContent(for: activeSheet)
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
    
    func liabilityCell(for liability: Liability) -> some View {
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
    func sheetContent(for sheetType: LoanUpdateSheet) -> some View {
        switch sheetType {
        case .liabilityUpdateSheet(let liability): LiabilityForm(viewModel: LiabilityFormViewModel(liability: liability){ viewModel.activeLoanUpdateSheet = nil } )
        case .receivableUpdateSheet(let receivable): ReceivableForm(viewModel: AssetFormViewModel(asset: receivable){ viewModel.activeLoanUpdateSheet = nil } )
        }
    }
}
