import SwiftUI

struct LiabilityDetailView: View {
    @State var viewModel: LiabilityDetailViewModel
    
    var body: some View {
        VStack {
            headerOptions
                .padding(.horizontal)
            transactionList
        }
        .navigationTitle(viewModel.liability.name)
        .background(Color(.secondarySystemBackground))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        .sheet(item: $viewModel.activeLiabilityDetailSheet) { activeSheet in
            switch activeSheet {
            case .addTransactionFormSheet:
                TransactionForm(viewModel: TransactionFormViewModel(loanPartner: viewModel.creditor, transactionAssociate: .liability(viewModel.liability)) { viewModel.activeLiabilityDetailSheet = nil })
            case .editTransactionFormSheet(let transaction):
                TransactionForm(viewModel: TransactionFormViewModel(transaction: transaction, loanPartner: viewModel.creditor, transactionAssociate: .liability(viewModel.liability)) { viewModel.activeLiabilityDetailSheet = nil })
            case .editLiabilitySheet(let liability):
                LiabilityForm(viewModel: LiabilityFormViewModel(liability: liability) { viewModel.activeLiabilityDetailSheet = nil })
            }
        }
        .alert(isPresented: $viewModel.showTransactionValidationErrorAlert, error: viewModel.transactionValidationError) { _ in
            Button("OK", role: .cancel) {
                viewModel.transactionValidationError = nil
            }
        } message: { _ in }
    }
    
    private var headerOptions: some View {
        HStack {
            Button {
                viewModel.activeLiabilityDetailSheet = .editLiabilitySheet(viewModel.liability)
            } label: {
                Text("edit liability")
                    .padding(.horizontal, 9)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Color.primary))
                    .foregroundColor(.primaryInverted)
            }
            Button {
                viewModel.activeLiabilityDetailSheet = .addTransactionFormSheet
            } label: {
                Text("add transaction")
                    .padding(.horizontal, 9)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Color.primary))
                    .foregroundColor(.primaryInverted)
            }
            Spacer()
        }
    }
    
    private var transactionList: some View {
        List {
            ForEach(viewModel.monthYears, id: \.self) { monthYear in
                section(for: monthYear)
            }
            .listRowBackground(Color(.tertiarySystemBackground))
        }
        .scrollContentBackground(.hidden)
        .background(Color(.secondarySystemBackground))
    }
    
    @ViewBuilder
    private func section(for monthYear: MonthYear) -> some View {
        Text(monthYear.month.rawValue + " " + String(monthYear.year))
        ForEach(viewModel.getTransactions(fallingInto: monthYear)) { transaction in
            Button {
                viewModel.activeLiabilityDetailSheet = .editTransactionFormSheet(transaction)
            } label: {
                listEntry(for: transaction)
            }
            .listRowSeparator(.hidden)
        }
        .onDelete { indices in
            do {
                try viewModel.deleteTransactions(at: indices, for: monthYear)
            } catch let error as TransactionValidationError {
                viewModel.transactionValidationError = error
                viewModel.showTransactionValidationErrorAlert = true
            } catch {}
        }
    }
    
    @ViewBuilder
    private func listEntry(for transaction: LoanTransaction) -> some View {
        HStack {
            VStack(spacing: 0) {
                Text(viewModel.getDayString(for: transaction))
                    .font(.footnote)
                Text(viewModel.getMonthString(for: transaction))
                    .font(.footnote)
            }
            .frame(width: 45, height: 45)
            .background(.gray.secondary)
            .cornerRadius(8)
            .foregroundColor(.white)
            Spacer()
                .frame(width: 10.0)
            
            Text(transaction.emoji)
            Spacer()
                .frame(width: 10.0)
            
            Text(transaction.note)
                .font(.footnote)
                .foregroundColor(.primary)
            Spacer()
            
            if let amountString = viewModel.getAmountString(for: transaction) {
                VStack(alignment: .trailing) {
                    Text(transaction.issuer.isNil ? "Du tilgst" : "Du leihst")
                        .font(.footnote)
                    Text(amountString)
                        .font(.footnote)
                }
                .foregroundStyle(transaction.issuer.isNil ? .green : .red)
            }
        }
    }
}

