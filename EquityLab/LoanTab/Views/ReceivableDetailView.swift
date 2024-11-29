import SwiftUI

struct ReceivableDetailView: View {
    @State var viewModel: ReceivableDetailViewModel
    
    var body: some View {
        VStack {
            headerOptions
                .padding(.horizontal)
            transactionList
            addButton
                .padding(.bottom)
        }
        .navigationTitle(viewModel.receivable.name)
        .background(Color(.secondarySystemBackground))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        .sheet(item: $viewModel.activeReceivableDetailSheet) { activeSheet in
            switch activeSheet {
            case .addTransactionFormSheet:
                TransactionForm(viewModel: TransactionFormViewModel(debtor: viewModel.debtor, receivable: viewModel.receivable) { viewModel.activeReceivableDetailSheet = nil })
            case .editTransactionFormSheet: EmptyView()
            case .editReceivableSheet: EmptyView()
            }
        }
    }
    
    private var headerOptions: some View {
        HStack {
            Button {
                /* TODO: implement*/
            } label: {
                Text("edit receivable")
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
        .navigationDestination(for: LoanTransaction.self) { transaction in
            TransactionForm(viewModel: TransactionFormViewModel(transaction: transaction, debtor: viewModel.debtor, receivable: viewModel.receivable) { viewModel.activeReceivableDetailSheet = nil })
        }
    }
    
    @ViewBuilder
    private func section(for monthYear: MonthYear) -> some View {
        Text(monthYear.month.rawValue + " " + String(monthYear.year))
        ForEach(viewModel.getTransactions(fallingInto: monthYear)) { transaction in
            NavigationLink(value: transaction) {
                listEntry(for: transaction)
            }
            .listRowSeparator(.hidden)
        }
    }
    
    private var addButton: some View {
        Button {
            viewModel.activeReceivableDetailSheet = .addTransactionFormSheet
        } label: {
            Text("add transaction")
                .foregroundStyle(.primaryInverted)
                .frame(width: 170, height: 10)
                .padding(.vertical)
                .background(
                    Capsule()
                        .foregroundStyle(Color.primary)
                )
                .cornerRadius(10)
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
            Spacer()
            
            if let amountString = viewModel.getAmountString(for: transaction) {
                VStack(alignment: .trailing) {
                    Text(transaction.issuer.isNil ? "Du leihst" : "Du bekommst")
                        .font(.footnote)
                    Text(amountString)
                        .font(.footnote)
                }
                .foregroundStyle(transaction.issuer.isNil ? .red : .green)
            }
        }
    }
}
