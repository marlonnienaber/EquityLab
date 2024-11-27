import SwiftUI

struct ReceivableDetailView: View {
    @State var viewModel: ReceivableDetailViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            headerOptions
                .padding(.horizontal)
            transactionList
        }
        .navigationTitle(viewModel.receivable.name)
        .background(Color(.secondarySystemBackground))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    /* TODO: implement */
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
    
    private var headerOptions: some View {
        HStack {
            Button {
                /* TODO: implement*/
            } label: {
                Text("outstanding amounts")
                    .padding(.horizontal, 9)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Color.primary))
                    .foregroundColor(.primaryInverted)
            }
            Button {
                /* TODO: implement*/
            } label: {
                Text("debtor")
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
        .navigationDestination(for: TransactionDebtorPair.self) { pair in
            TransactionDetailView(viewModel: TransactionDetailViewModel(transaction: pair.transaction, debtor: pair.debtor))
        }
    }
    
    @ViewBuilder
    private func section(for monthYear: MonthYear) -> some View {
        Text(monthYear.month.rawValue + " " + String(monthYear.year))
        ForEach(viewModel.getTransactions(fallingInto: monthYear)) { transaction in
            if let debtor = transaction.receivable?.debtor {
                NavigationLink(value: TransactionDebtorPair(transaction: transaction, debtor: debtor)) {
                    listEntry(for: transaction)
                }
                .listRowSeparator(.hidden)
            }
        }
    }
    
    private var addButton: some View {
        Button {
            /* TODO: implement*/
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
    private func listEntry(for transaction: Transaction) -> some View {
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
            
            VStack(alignment: .leading) {
                Text(transaction.note)
                    .font(.footnote)
                if let totalAmountString = viewModel.getTotalAmountString(for: transaction) {
                    if let issuer = transaction.issuer {
                        Text("\(issuer.name) zahlte")
                            .font(.caption2)
                    } else {
                        Text("Du zahltest")
                            .font(.caption2)
                    }
                    Text(totalAmountString)
                        .font(.caption2)
                }
            }
            Spacer()
            
            if let userAmountString = viewModel.getUserAmountString(for: transaction) {
                VStack(alignment: .trailing) {
                    Text(transaction.issuer.isNil ? "Du leihst" : "Du schuldest")
                        .font(.footnote)
                    Text(userAmountString)
                        .font(.footnote)
                }
                .foregroundStyle(transaction.issuer.isNil ? .green : .red)
            }
        }
    }
    
    struct TransactionDebtorPair: Hashable {
        let transaction: Transaction
        let debtor: Person
    }
}

//#Preview {
//    ReceivableDetailView(viewModel: ReceivableDetailViewModel(receivable: nil) {})
//}


//Text("Februar")
//transaction(day: "15", month: "Feb", icon: "⛽", note: "Diesel", totalAmountText: "134.18€", yourAmountText: "34.52€", userIsIssuer: false, issuerName: "Philipp Heise")
//transaction(day: "12", month: "Feb", icon: "🍻", note: "Laurent Garnier", totalAmountText: "22.95€", yourAmountText: "34.52€", userIsIssuer: true)
//    .listRowSeparator(.hidden)
//Text("Januar")
//transaction(day: "13", month: "Jan", icon: "🛒", note: "Einkauf", totalAmountText: "10.11€", yourAmountText: "3.76€", userIsIssuer: true)

//private func transaction(day: String, month: String, icon: String, note: String, totalAmountText: String, yourAmountText: String, userIsIssuer: Bool, issuerName: String = "Du") -> some View {
//    HStack {
//        VStack(spacing: 0) {
//            Text(day)
//                .font(.footnote)
//            Text(month)
//                .font(.footnote)
//        }
//        .frame(width: 45, height: 45)
//        .background(.gray.secondary)
//        .cornerRadius(8)
//        .foregroundColor(.white)
//        Spacer()
//            .frame(width: 10.0)
//        Text(icon)
//        Spacer()
//            .frame(width: 10.0)
//        VStack(alignment: .leading) {
//            Text(note)
//            Text(issuerName + (userIsIssuer ? " zahltest " : " zahlte "))
//                .font(.footnote)
//            Text(totalAmountText)
//                .font(.footnote)
//        }
//        Spacer()
//        VStack(alignment: .trailing) {
//            Text(userIsIssuer ? "Du leihst" : "Du schuldest")
//                .font(.footnote)
//            Text(yourAmountText)
//        }
//    }
//}
