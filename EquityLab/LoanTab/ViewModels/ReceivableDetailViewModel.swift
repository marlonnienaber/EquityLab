import os
import CoreData
import Observation

@Observable
class ReceivableDetailViewModel {
    private static let logger = Logger(subsystem: .settingsTab, component: .receivableDetailViewModel)
    
    private let assetRepository: AssetRepository
    
    @ObservationIgnored private var monthYearToTransactionsDictionary: [MonthYear:[LoanTransaction]] = [:]
    @ObservationIgnored private var loanTransactionAnalyzer: LoanTransactionAnalyzer
    @ObservationIgnored let receivable: Receivable
    @ObservationIgnored let debtor: LoanPartner
    var monthYears: [MonthYear] = []
    var activeReceivableDetailSheet: ReceivableDetailSheetType? = nil
    
    init(
        assetRepository: AssetRepository = .production,
        receivable: Receivable,
        debtor: LoanPartner
    ) {
        Self.logger.debug("ReceivableDetailViewModel()")
        self.assetRepository = assetRepository
        self.loanTransactionAnalyzer = LoanTransactionAnalyzer()
        self.receivable = receivable
        self.debtor = debtor
        populateMonthYearsAndTransactions()
        assetRepository.add(observer: self)
    }
    
    private func populateMonthYearsAndTransactions() {
        let filteredTransactions = assetRepository.getTransactions().filter{ $0.receivable == receivable }
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
        monthYearToTransactionsDictionary[monthYear] ?? []
    }
    
    func deleteTransactions(at indexSet: IndexSet, for monthYear: MonthYear) {
        guard let monthYearTransactions = monthYearToTransactionsDictionary[monthYear] else { return }
        indexSet.forEach{ assetRepository.delete(transaction: monthYearTransactions[$0]) }
    }
    
    func getDayString(for transaction: LoanTransaction) -> String {
        loanTransactionAnalyzer.getDayString(for: transaction)
    }
    
    func getMonthString(for transaction: LoanTransaction) -> String {
        loanTransactionAnalyzer.getMonthString(for: transaction)
    }
    
    func getAmountString(for transaction: LoanTransaction) -> String? {
        loanTransactionAnalyzer.getAmountString(for: transaction)
    }
}

enum ReceivableDetailSheetType: Identifiable {
    case editReceivableSheet(Receivable)
    case addTransactionFormSheet
    case editTransactionFormSheet(LoanTransaction)

    var id: String {
        switch self {
        case .editReceivableSheet:
            return "editReceivableSheet"
        case .addTransactionFormSheet:
            return "addTransactionFormSheet"
        case .editTransactionFormSheet(let transaction):
            return "editTransactionFormSheet-\(transaction.id)"
        }
    }
}

extension ReceivableDetailViewModel: ReceivableTransactionObserver {
    func notifyAfterReceivableTransactionUpdate() {
        populateMonthYearsAndTransactions()
    }
}

