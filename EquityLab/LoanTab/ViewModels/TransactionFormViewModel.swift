import Observation
import Foundation
import os

@Observable
class TransactionFormViewModel {
    private static let logger = Logger(subsystem: .loanManagementTab, component: .transactionFormViewModel)
    
    private let assetRepository: AssetRepository
    private let liabilityRepository: LiabilityRepository
    
    let transaction: LoanTransaction?
    let loanPartner: LoanPartner
    let transactionAssociate: TransactionAssociate
    
    var value: Decimal
    var note: String
    var date: Date
    var selectedIssuer: LoanPartner?
    
    var issuerOptionsOpen = false
    let dismissSheet: () -> ()
    
    init(
        assetRepository: AssetRepository = .production,
        liabilityRepository: LiabilityRepository = .production,
        transaction: LoanTransaction? = nil,
        loanPartner: LoanPartner,
        transactionAssociate: TransactionAssociate,
        dismissSheet: @escaping () -> ()
    ) {
        self.assetRepository = assetRepository
        self.liabilityRepository = liabilityRepository
        self.transaction = transaction
        self.loanPartner = loanPartner
        self.transactionAssociate = transactionAssociate
        self.dismissSheet = dismissSheet
        
        self.value = transaction?.amount.decimalValue ?? 0
        self.note = transaction?.note ?? ""
        self.date = transaction?.date ?? .now
        self.selectedIssuer = transaction?.issuer
    }
    
    private func updateLoanTransaction(transaction: LoanTransaction) {
        switch transactionAssociate {
        case .receivable(let receivable):
            assetRepository.updateReceivableTransaction(
                transaction: transaction,
                amount: value,
                date: date,
                note: note,
                issuer: selectedIssuer
            )
        case .liability(let liability):
            liabilityRepository.updateLiabilityTransaction(
                transaction: transaction,
                amount: value,
                date: date,
                note: note,
                issuer: selectedIssuer
            )
        }
        
    }
    
    private func createLoanTransaction() {
        switch transactionAssociate {
        case .receivable(let receivable):
            assetRepository.createReceivableTransaction(
                amount: value,
                date: date,
                note: note,
                issuer: selectedIssuer,
                receivable: receivable
            )
        case .liability(let liability):
            liabilityRepository.createLiabilityTransaction(
                amount: value,
                date: date,
                note: note,
                issuer: selectedIssuer,
                liability: liability
            )
        }
    }
    
    func saveLoanTransaction() {
        if let transaction {
            updateLoanTransaction(transaction: transaction)
        } else {
            createLoanTransaction()
        }
    }
}

enum TransactionAssociate {
    case receivable(Receivable)
    case liability(Liability)
}

