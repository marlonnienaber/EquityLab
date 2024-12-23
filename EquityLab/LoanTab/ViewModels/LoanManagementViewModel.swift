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
        let sortedReceivables = unsortedReceivables.sorted(by: receivableSortingPredicate)
        receivables = sortedReceivables
        
        let unsortedLiabilities = liabilityRepository.fetchLiabilities()
        
        liabilities = unsortedLiabilities.sorted(by: liabilitySortingPredicate)
        assetRepository.add(observer: self)
    }
    
    private func receivableSortingPredicate(first: Receivable, second: Receivable) -> Bool {
        let firstTransactions = assetRepository.getTransactions().filter{ $0.receivable == first }
        let firstInitialTransactionDate = firstTransactions.map{ $0.date }.min()
        let secondTransactions = assetRepository.getTransactions().filter{ $0.receivable == second }
        let secondInitialTransactionDate = secondTransactions.map{ $0.date }.min()
        
        return firstInitialTransactionDate ?? .distantPast <= secondInitialTransactionDate ?? .distantPast
    }
    
    private func liabilitySortingPredicate(first: Liability, second: Liability) -> Bool {
        let firstTransactions = liabilityRepository.fetchTransactions(for: first)
        let firstInitialTransactionDate = firstTransactions.map{ $0.date }.min()
        let secondTransactions = liabilityRepository.fetchTransactions(for: second)
        let secondInitialTransactionDate = secondTransactions.map{ $0.date }.min()
        
        return firstInitialTransactionDate ?? .distantPast <= secondInitialTransactionDate ?? .distantPast
    }
    
    func getDebtorName(of receivable: Receivable) -> String {
        receivable.debtor?.name ?? ""
    }
    
    func getCreditorName(of liability: Liability) -> String {
        liability.creditor?.name ?? ""
    }
    
    func getDebtor(of receivable: Receivable) -> LoanPartner? {
        receivable.debtor
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
        liabilities = liabilityRepository.fetchLiabilities().sorted(by: liabilitySortingPredicate)
    }
}

extension LoanManagementViewModel: ReceivableObserver, ReceivableTransactionObserver {
    func notifyAfterAssetPoolUpdate() {
        receivables = assetRepository.getReceivables().sorted(by: receivableSortingPredicate)
    }
    
    func notifyAfterReceivableUpdate() {
        receivables = assetRepository.getReceivables().sorted(by: receivableSortingPredicate)
    }
    
    func notifyAfterReceivableTransactionUpdate() {
        receivables = receivables
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

