import os
import CoreData
import Observation

@Observable
class LiabilityDetailViewModel {
    private static let logger = Logger(subsystem: .settingsTab, component: .liabilityDetailViewModel)
    
    private let liabilityRepository: LiabilityRepository
    
    @ObservationIgnored private var monthYearToTransactionsDictionary: [MonthYear:[LoanTransaction]] = [:]
    @ObservationIgnored private var loanTransactionAnalyzer: LoanTransactionAnalyzer
    @ObservationIgnored let liability: Liability
    @ObservationIgnored let creditor: LoanPartner
    var monthYears: [MonthYear] = []
    var showTransactionValidationErrorAlert = false
    var transactionValidationError: TransactionValidationError?
    var activeLiabilityDetailSheet: LiabilityDetailSheetType? = nil
    
    init(
        liabilityRepository: LiabilityRepository = .production,
        liability: Liability,
        creditor: LoanPartner
    ) {
        Self.logger.debug("LiabilityDetailViewModel()")
        self.liabilityRepository = liabilityRepository
        self.loanTransactionAnalyzer = LoanTransactionAnalyzer()
        self.liability = liability
        self.creditor = creditor
        populateMonthYearsAndTransactions()
        liabilityRepository.add(observer: self)
    }
    
    private func populateMonthYearsAndTransactions() {
        let filteredTransactions = liabilityRepository.getTransactions().filter{ $0.liability == liability }
        let sortedTransactions = filteredTransactions.sorted{ $0.date > $1.date }
        var monthYearToTransactionsDictionary: [MonthYear:[LoanTransaction]] = [:]
        var monthYears = [MonthYear]()
        for transaction in sortedTransactions {
            guard let monthYear = MonthYear(date: transaction.date) else { continue }
            if !monthYears.contains(monthYear) {
                monthYears.append(monthYear)
            }
            if var monthYearTransactions = monthYearToTransactionsDictionary[monthYear] {
                monthYearTransactions.append(transaction)
                monthYearToTransactionsDictionary[monthYear] = monthYearTransactions
            } else {
                monthYearToTransactionsDictionary[monthYear] = [transaction]
            }
        }
        self.monthYears = monthYears.sorted { first,second in
            if first.year == second.year {
                return first.month > second.month
            }
            return first.year > second.year
        }
        self.monthYearToTransactionsDictionary = monthYearToTransactionsDictionary
    }
    
    func getTransactions(fallingInto monthYear: MonthYear) -> [LoanTransaction] {
        Self.logger.debug("getTransactions(fallingInto monthYear)")
        return monthYearToTransactionsDictionary[monthYear] ?? []
    }
    
    func deleteTransactions(at indexSet: IndexSet, for monthYear: MonthYear) throws {
        Self.logger.debug("deleteTransactions(at indexSet, for monthYear)")
        guard indexSet.count == 1, let index = indexSet.first, let monthYearTransactions = monthYearToTransactionsDictionary[monthYear] else { return }
        let transactionToDelete = monthYearTransactions[index]
        
        /// a transaction can only be removed if after its removal it is still guaranteed that at no point in time during the loan there was a negative balance
        /// ->  get transactions in displayed order and remove the transactionToDelete
        /// ->  reverse the ordering (display order is newest transaction first)
        /// ->  check if the validation criterion is met. Throw error if not
        var transactions = liabilityRepository.getTransactions().filter{ $0.liability == liability }.sorted{ $0.date > $1.date }
        if let removeIndex = transactions.firstIndex(of: transactionToDelete) {
            transactions.remove(at: removeIndex)
        }
        transactions.reverse()
        var balance: Decimal = 0
        for transaction in transactions {
            if transaction.issuer.isNil {
                balance -= transaction.amount.decimalValue
            } else {
                balance += transaction.amount.decimalValue
            }
            if balance < 0 {
                throw TransactionValidationError.negativeBalanceThroughDeletion
            }
        }
        
        liabilityRepository.delete(transaction: transactionToDelete)
    }
    
    func getDayString(for transaction: LoanTransaction) -> String {
        Self.logger.debug("getDayString(for transaction)")
        return loanTransactionAnalyzer.getDayString(for: transaction)
    }
    
    func getMonthString(for transaction: LoanTransaction) -> String {
        Self.logger.debug("getMonthString(for transaction)")
        return loanTransactionAnalyzer.getMonthString(for: transaction)
    }
    
    func getAmountString(for transaction: LoanTransaction) -> String? {
        Self.logger.debug("getAmountString(for transaction)")
        return loanTransactionAnalyzer.getAmountString(for: transaction)
    }
}

enum LiabilityDetailSheetType: Identifiable {
    case editLiabilitySheet(Liability)
    case addTransactionFormSheet
    case editTransactionFormSheet(LoanTransaction)

    var id: String {
        switch self {
        case .editLiabilitySheet:
            return "editLiabilitySheet"
        case .addTransactionFormSheet:
            return "addTransactionFormSheet"
        case .editTransactionFormSheet(let transaction):
            return "editTransactionFormSheet-\(transaction.id)"
        }
    }
}

extension LiabilityDetailViewModel: LiabilityTransactionObserver {
    func notifyAfterLiabilityTransactionUpdate() {
        Self.logger.debug("notifyAfterLiabilityTransactionUpdate()")
        populateMonthYearsAndTransactions()
    }
}
