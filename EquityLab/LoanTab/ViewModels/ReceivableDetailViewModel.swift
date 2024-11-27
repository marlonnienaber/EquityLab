import os
import CoreData
import Observation

@Observable
class ReceivableDetailViewModel {
    private static let logger = Logger(subsystem: .settingsTab, component: .receivableDetailViewModel)
    
    private let assetRepository: AssetRepository
    
    @ObservationIgnored private var transactionToSharesDictionary: [Transaction:[Share]] = [:]
    @ObservationIgnored private var monthYearToTransactionsDictionary: [MonthYear:[Transaction]] = [:]
    @ObservationIgnored let receivable: Receivable
    var monthYears: [MonthYear] = []
    
    init(
        assetRepository: AssetRepository = .production,
        receivable: Receivable
    ) {
        Self.logger.debug("ReceivableDetailViewModel()")
        self.assetRepository = assetRepository
        self.receivable = receivable
        
        assetRepository.$receivableTransactions.registerObserver(self, keyPath: \.monthYearToTransactionsDictionary) { newTransactions in
            let filteredTransactions = newTransactions.filter{ $0.receivable == receivable }
            var monthYearToTransactionsDictionary: [MonthYear:[Transaction]] = [:]
            for transaction in filteredTransactions {
                guard let monthYear = MonthYear(date: transaction.date) else { continue }
                if var monthYearTransactions = monthYearToTransactionsDictionary[monthYear] {
                    monthYearTransactions.append(transaction)
                    monthYearToTransactionsDictionary[monthYear] = monthYearTransactions
                } else {
                    monthYearToTransactionsDictionary[monthYear] = [transaction]
                }
            }
            return monthYearToTransactionsDictionary
        }
        
        assetRepository.$receivableTransactions.registerObserver(self, keyPath: \.monthYears) { newTransactions in
            let filteredTransactions = newTransactions.filter{ $0.receivable == receivable }
            var monthYears = [MonthYear]()
            for transaction in filteredTransactions {
                guard let monthYear = MonthYear(date: transaction.date) else { continue }
                if !monthYears.contains(monthYear) {
                    monthYears.append(monthYear)
                }
            }
            return monthYears.sorted { first,second in
                if first.year == second.year {
                    return first.month < second.month
                }
                return first.year < second.year
            }
        }
        
        assetRepository.$receivableTransactionShares.registerObserver(self, keyPath: \.transactionToSharesDictionary){ newShares in
            var transactionToSharesDictionary: [Transaction:[Share]] = [:]
            for share in newShares {
                guard let transaction = share.transaction else { continue }
                if let transactionShares = transactionToSharesDictionary[transaction] {
                    transactionToSharesDictionary[transaction] = transactionShares + [share]
                } else {
                    transactionToSharesDictionary[transaction] = [share]
                }
            }
            return transactionToSharesDictionary
        }
        
        assetRepository.$receivableTransactionShares.onSetDo { [weak self] _ in
            guard let self else { return }
            monthYears = monthYears /// invalidate monthYears so that the UI is updated after shares change
        }
    }
    
    func getTransactions(fallingInto monthYear: MonthYear) -> [Transaction] {
        monthYearToTransactionsDictionary[monthYear] ?? []
    }
    
    func getDayString(for transaction: Transaction) -> String {
        let date = transaction.date
        let calendar = Calendar.current
        let dayComponent = calendar.component(.day, from: date)
        return String(dayComponent)
    }
    
    func getMonthString(for transaction: Transaction) -> String {
        let date = transaction.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: date)
    }
    
    func getTotalAmountString(for transaction: Transaction) -> String? {
        LocalizedCurrencyFormatter.shared.string(from: transaction.amount as NSNumber)
    }
    
    func getUserAmountString(for transaction: Transaction) -> String? {
        guard let shares = transactionToSharesDictionary[transaction] else { return nil }
        guard let ownerShare = (shares.first{ $0.shareHolder.isNil }) else { return nil }
        return LocalizedCurrencyFormatter.shared.string(from: ownerShare.amount as NSNumber)
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
