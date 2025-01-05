import os
import CoreData
import Observation

@Observable
class LiabilityDetailViewModel {
    private static let logger = Logger(subsystem: .settingsTab, component: .liabilityDetailViewModel)
    
    private let liabilityRepository: LiabilityRepository
    
    @ObservationIgnored private var monthYearToTransactionsDictionary: [MonthYear:[LoanTransaction]] = [:]
    @ObservationIgnored let liability: Liability
    @ObservationIgnored let creditor: LoanPartner
    var monthYears: [MonthYear] = []
    var activeLiabilityDetailSheet: LiabilityDetailSheetType? = nil
    
    init(
        liabilityRepository: LiabilityRepository = .production,
        liability: Liability,
        creditor: LoanPartner
    ) {
        Self.logger.debug("LiabilityDetailViewModel()")
        self.liabilityRepository = liabilityRepository
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
        monthYearToTransactionsDictionary[monthYear] ?? []
    }
    
    func deleteTransactions(at indexSet: IndexSet, for monthYear: MonthYear) {
        guard let monthYearTransactions = monthYearToTransactionsDictionary[monthYear] else { return }
        indexSet.forEach{ liabilityRepository.delete(transaction: monthYearTransactions[$0]) }
    }
    
    func getDayString(for transaction: LoanTransaction) -> String { /* TODO: repetitive code */
        let date = transaction.date
        let calendar = Calendar.current
        let dayComponent = calendar.component(.day, from: date)
        return String(dayComponent)
    }
    
    func getMonthString(for transaction: LoanTransaction) -> String { /* TODO: repetitive code */
        let date = transaction.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: date)
    }
    
    func getAmountString(for transaction: LoanTransaction) -> String? { /* TODO: repetitive code */
        LocalizedCurrencyFormatter.shared.string(from: transaction.amount as NSNumber)
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
        populateMonthYearsAndTransactions()
    }
}
