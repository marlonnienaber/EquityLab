import os
import CoreData
import Observation

@Observable
class ReceivableDetailViewModel {
    private static let logger = Logger(subsystem: .settingsTab, component: .receivableDetailViewModel)
    
    private let assetRepository: AssetRepository
    
    @ObservationIgnored private var monthYearToTransactionsDictionary: [MonthYear:[LoanTransaction]] = [:]
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
        self.receivable = receivable
        self.debtor = debtor
        
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
        
        assetRepository.add(observer: self)
    }
    
    func getTransactions(fallingInto monthYear: MonthYear) -> [LoanTransaction] {
        monthYearToTransactionsDictionary[monthYear] ?? []
    }
    
    func deleteTransactions(at indexSet: IndexSet, for monthYear: MonthYear) {
        guard let monthYearTransactions = monthYearToTransactionsDictionary[monthYear] else { return }
        indexSet.forEach{ assetRepository.delete(transaction: monthYearTransactions[$0]) }
    }
    
    func getDayString(for transaction: LoanTransaction) -> String {
        let date = transaction.date
        let calendar = Calendar.current
        let dayComponent = calendar.component(.day, from: date)
        return String(dayComponent)
    }
    
    func getMonthString(for transaction: LoanTransaction) -> String {
        let date = transaction.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: date)
    }
    
    func getAmountString(for transaction: LoanTransaction) -> String? {
        LocalizedCurrencyFormatter.shared.string(from: transaction.amount as NSNumber)
    }
}

struct MonthYear: Hashable {
    let month: Date.Month
    let year: Int
    
    init?(date: Date) {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "en_US")
        let components = calendar.dateComponents([.month, .year], from: date)
        guard let monthInt = components.month, let year = components.year else { return nil }
        guard let month = Date.Month(rawValue: calendar.monthSymbols[monthInt - 1].lowercased()) else { return nil }
        self.month = month
        self.year = year
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
                return first.month < second.month
            }
            return first.year < second.year
        }
        self.monthYearToTransactionsDictionary = monthYearToTransactionsDictionary
    }
}

