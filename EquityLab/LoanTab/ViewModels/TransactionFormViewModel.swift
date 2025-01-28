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
    
    var transactionValidationError: TransactionValidationError?
    var showValidationErrorAlert = false
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

    
    private func getTransactionsOfAssociate() -> [LoanTransaction] {
        switch transactionAssociate {
        case .receivable(let receivable):
            return assetRepository.getTransactions().filter{ $0.receivable == receivable }
        case .liability(let liability):
            return liabilityRepository.getTransactions().filter{ $0.liability == liability }
        }
    }
    
    private var isRepayment: Bool {
        switch transactionAssociate {
        case .receivable(_): selectedIssuer.isNotNil
        case .liability(_): selectedIssuer.isNil
        }
    }
    
    private var repaymenBeforeOrConcurrentToFirstDisbursement: Bool {
        guard isRepayment else { return false }
        guard let firstTransaction = getTransactionsOfAssociate().min(by: { $0.date < $1.date} ) else { return true }
        return date <= firstTransaction.date
    }
    
    private var wouldMakeBalanceNegative: Bool {
        let otherTransactionsConnectedToAssociate = getTransactionsOfAssociate().filter{ $0 != transaction }
        switch transactionAssociate {
        case .receivable(_):
            let debtorTransactions = otherTransactionsConnectedToAssociate.filter{ $0.issuer.isNotNil }
            let ownTransactions: [LoanTransaction] = Array(Set(otherTransactionsConnectedToAssociate).subtracting(debtorTransactions))
            var disbursedAmount = ownTransactions.map{ $0.amount.decimalValue }.reduce(0, +)
            var repayedAmount = debtorTransactions.map{ $0.amount.decimalValue }.reduce(0, +)
            if selectedIssuer.isNotNil {
                repayedAmount += value
            } else {
                disbursedAmount += value
            }
            return (disbursedAmount - repayedAmount) < 0
        case .liability(_):
            let creditorTransactions = otherTransactionsConnectedToAssociate.filter{ $0.issuer.isNotNil }
            let ownTransactions = Array(Set(otherTransactionsConnectedToAssociate).subtracting(creditorTransactions))
            var disbursedAmount = creditorTransactions.map{ $0.amount.decimalValue }.reduce(0, +)
            var repayedAmount = ownTransactions.map{ $0.amount.decimalValue }.reduce(0, +)
            if selectedIssuer.isNil {
                repayedAmount += value
            } else {
                disbursedAmount += value
            }
            return (disbursedAmount - repayedAmount) < 0
        }
    }
    
    private var valueIsNotStrictlyPositive: Bool {
        value <= 0
    }
    
    private func validateTransaction() throws {
        if valueIsNotStrictlyPositive {
            throw TransactionValidationError.valueNotStrictlyPositive
        }
        if repaymenBeforeOrConcurrentToFirstDisbursement {
            throw TransactionValidationError.repaymentBeforeOrConcurrentToFirstDisbursement
        }
        if wouldMakeBalanceNegative {
            throw TransactionValidationError.negativeBalance
        }
    }
    
    private func updateLoanTransaction(transaction: LoanTransaction) throws {
        try validateTransaction()
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
    
    private func createLoanTransaction() throws {
        try validateTransaction()
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
    
    func saveLoanTransaction() throws {
        if let transaction {
            try updateLoanTransaction(transaction: transaction)
        } else {
            try createLoanTransaction()
        }
    }
}

enum TransactionAssociate {
    case receivable(Receivable)
    case liability(Liability)
}

enum TransactionValidationError: String, LocalizedError {
    case valueNotStrictlyPositive = "A transaction must have a value greater than zero!"
    case repaymentBeforeOrConcurrentToFirstDisbursement = "Repayments must take place after the first disbursement!"
    case negativeBalance = "This transaction is not supported. It would make the balance of the associated loan negative!"
    var errorDescription: String? {
        self.rawValue
    }
}

