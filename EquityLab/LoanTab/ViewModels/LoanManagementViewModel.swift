import os
import CoreData

@Observable
class LoanManagementViewModel {
    @ObservationIgnored private static let logger = Logger(subsystem: .loanManagementTab, component: .loanManagementViewModel)
    
    @ObservationIgnored private let assetRepository: AssetRepository
    @ObservationIgnored private let liabilityRepository: LiabilityRepository
    @ObservationIgnored private let receivableAnalyzer: ReceivableAnalyzer
    @ObservationIgnored private let liabilityAnalyzer: LiabilityAnalyzer
    
    var liabilities = [Liability]()
    var receivables = [Receivable]()
    var activeLoanCreateSheet: LoanCreateSheet?
    var selectedLoanType: LoanType?
    var showLoanUpdatePickerSheet = false
    var hasNoLoans: Bool {
        liabilities.isEmpty && receivables.isEmpty
    }
    
    init(assetRepository: AssetRepository = .production, liabilityRepository: LiabilityRepository = .production) {
        Self.logger.debug("LoanManagementViewModel()")
    
        self.assetRepository = assetRepository
        self.liabilityRepository = liabilityRepository
        self.receivableAnalyzer = ReceivableAnalyzer(repository: assetRepository)
        self.liabilityAnalyzer = LiabilityAnalyzer(repository: liabilityRepository)
        
        let unsortedReceivables = assetRepository.getReceivables()
        receivables = unsortedReceivables.sorted(by: receivableSortingPredicate)
        let unsortedLiabilities = liabilityRepository.getLiabilities()
        liabilities = unsortedLiabilities.sorted(by: liabilitySortingPredicate)
        
        assetRepository.add(observer: self)
        liabilityRepository.add(observer: self)
    }
    
    private func receivableSortingPredicate(first: Receivable, second: Receivable) -> Bool {
        let firstTransactions = assetRepository.getTransactions().filter{ $0.receivable == first }
        let firstInitialTransactionDate = firstTransactions.map{ $0.date }.min()
        let secondTransactions = assetRepository.getTransactions().filter{ $0.receivable == second }
        let secondInitialTransactionDate = secondTransactions.map{ $0.date }.min()
        
        return firstInitialTransactionDate ?? .distantPast <= secondInitialTransactionDate ?? .distantPast
    }
    
    private func liabilitySortingPredicate(first: Liability, second: Liability) -> Bool {
        let firstTransactions = liabilityRepository.getTransactions().filter{ $0.liability == first }
        let firstInitialTransactionDate = firstTransactions.map{ $0.date }.min()
        let secondTransactions = liabilityRepository.getTransactions().filter{ $0.liability == second }
        let secondInitialTransactionDate = secondTransactions.map{ $0.date }.min()
        
        return firstInitialTransactionDate ?? .distantPast <= secondInitialTransactionDate ?? .distantPast
    }
    
    func deleteReceivables(for indexSet: IndexSet) {
        Self.logger.debug("deleteReceivables(for indexSet:)")
        indexSet.map{receivables[$0]}.forEach{assetRepository.delete(receivable: $0)}
    }
    
    func deleteLiabilities(for indexSet: IndexSet) {
        Self.logger.debug("deleteLiabilities(for indexSet:)")
        indexSet.map{liabilities[$0]}.forEach{liabilityRepository.delete(liability: $0)}
    }
    
    func getDisbursedAmountString(for receivable: Receivable) -> String? {
        let disbursedAmount = receivableAnalyzer.calculateDisbursedAmount(for: receivable)
        return LocalizedCurrencyFormatter.shared.string(from: disbursedAmount.nsDecimalNumberValue)
    }
    
    func getDisbursedAmountString(for liability: Liability) -> String? {
        let disbursedAmount = liabilityAnalyzer.calculateDisbursedAmount(for: liability)
        return LocalizedCurrencyFormatter.shared.string(from: disbursedAmount.nsDecimalNumberValue)
    }
    
    func getRepaymentPercentage(for receivable: Receivable) -> Decimal {
        receivableAnalyzer.calculateRepaymentPercentage(for: receivable)
    }
    
    func getRepaymentPercentage(for liability: Liability) -> Decimal {
        liabilityAnalyzer.calculateRepaymentPercentage(for: liability)
    }
}

extension LoanManagementViewModel: LiabilityObserver {
    func notifyAfterLiabilityUpdate() {
        liabilities = liabilityRepository.getLiabilities().sorted(by: liabilitySortingPredicate)
    }
    
    func notifyAfterLiabilityTransactionUpdate() {
        liabilities = liabilities /// triggers re-rendering of view and therefore recalling of functions calculating stats over transactions
    }
}

extension LoanManagementViewModel: ReceivableObserver, ReceivableTransactionObserver {
    func notifyAfterReceivableUpdate() {
        receivables = assetRepository.getReceivables().sorted(by: receivableSortingPredicate)
    }
    
    func notifyAfterReceivableTransactionUpdate() {
        receivables = receivables /// triggers re-rendering of view and therefore recalling of functions calculating stats over transactions
    }
}

enum LoanCreateSheet: Identifiable {
    case receivableCreateSheet
    case liabilityCreateSheet
    var id: String {
        switch self {
        case .receivableCreateSheet: return "receivableCreateSheet"
        case .liabilityCreateSheet: return "liabilityCreateSheet"
        }
    }
}

enum LoanType {
    case receivable
    case liability
}

