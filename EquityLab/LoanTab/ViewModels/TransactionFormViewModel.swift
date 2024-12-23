import Observation
import Foundation
import os

@Observable
class TransactionFormViewModel {
    private static let logger = Logger(subsystem: .loanManagementTab, component: .transactionFormViewModel)
    
    private let assetRepository: AssetRepository
    
    let transaction: LoanTransaction?
    let debtor: LoanPartner
    let receivable: Receivable
    
    var value: Decimal
    var note: String
    var date: Date
    var selectedIssuer: LoanPartner?
    
    var issuerOptionsOpen = false
    let dismissSheet: () -> ()
    
    init(
        transaction: LoanTransaction? = nil,
        debtor: LoanPartner,
        receivable: Receivable,
        assetRepository: AssetRepository = .production,
        dismissSheet: @escaping () -> ()
    ) {
        self.assetRepository = assetRepository
        self.transaction = transaction
        self.debtor = debtor
        self.receivable = receivable
        self.dismissSheet = dismissSheet
        
        self.value = transaction?.amount.decimalValue ?? 0
        self.note = transaction?.note ?? ""
        self.date = transaction?.date ?? .now
        self.selectedIssuer = transaction?.issuer
    }
    
    private func updateLoanTransaction(transaction: LoanTransaction) {
        assetRepository.updateReceivableTransaction(
            transaction: transaction,
            amount: value,
            date: date,
            note: note,
            issuer: selectedIssuer,
            receivable: receivable
        )
    }
    
    private func createLoanTransaction() {
        assetRepository.createReceivableTransaction(
            amount: value,
            date: date,
            note: note,
            issuer: selectedIssuer,
            receivable: receivable
        )
    }
    
    func saveLoanTransaction() {
        if let transaction {
            updateLoanTransaction(transaction: transaction)
        } else {
            createLoanTransaction()
        }
    }
}

