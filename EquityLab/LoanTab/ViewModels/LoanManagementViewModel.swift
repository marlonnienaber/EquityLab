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

        assetRepository.$receivables.registerObserver(self, keyPath: \.receivables) { newReceivables in
            let predicate: (Receivable, Receivable) -> Bool = { first, second in
                let firstTransactions = assetRepository.receivableTransactions.filter{ $0.receivable == first }
                let firstInitialTransactionDate = firstTransactions.map{ $0.date }.min()
                let secondTransactions = assetRepository.receivableTransactions.filter{ $0.receivable == second }
                let secondInitialTransactionDate = secondTransactions.map{ $0.date }.min()
                
                return firstInitialTransactionDate ?? .distantPast <= secondInitialTransactionDate ?? .distantPast
            }
            return newReceivables.sorted(by: predicate)
        }
        liabilityRepository.$liabilities.registerObserver(self, keyPath: \.liabilities) { newLiabilities in
            let predicate: (Liability, Liability) -> Bool = { first, second in
                let firstTransactions = liabilityRepository.liabilityTransactions.filter{ $0.liability == first }
                let firstInitialTransactionDate = firstTransactions.map{ $0.date }.min()
                let secondTransactions = liabilityRepository.liabilityTransactions.filter{ $0.liability == second }
                let secondInitialTransactionDate = secondTransactions.map{ $0.date }.min()
                
                return firstInitialTransactionDate ?? .distantPast <= secondInitialTransactionDate ?? .distantPast
            }
            return newLiabilities.sorted(by: predicate)
        }
        /* TODO: add logic that refreshes liabilities and receivables once a transaction is modified */
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
        indexSet.map{receivables[$0]}.forEach{assetRepository.deleteReceivable(receivable: $0)}
    }
    
    func deleteLiabilities(for indexSet: IndexSet) {
        Self.logger.debug("deleteLiabilities(for indexSet:)")
        indexSet.map{liabilities[$0]}.forEach{liabilityRepository.deleteLiability(liability: $0)}
    }
    
    func getDisbursedAmountString(for receivable: Receivable) -> String? {
        let disbursedAmount = receivableAnalyzer.calculateDisbursedAmount(for: receivable)
        return LocalizedCurrencyFormatter.shared.string(from: disbursedAmount.nsDecimalNumberValue)
    }
    
    func getDisbursedAmountString(for liability: Liability) -> String? {
        let disbursedAmount = liabilityAnalyzer.calculateDisbursedAmount(for: liability)
        return LocalizedCurrencyFormatter.shared.string(from: disbursedAmount.nsDecimalNumberValue)
    }
    
    func getRepaymentPercentage(for receivable: Receivable) -> Double {
        receivableAnalyzer.calculateRepaymentPercentage(for: receivable).doubleValue
    }
    
    func getRepaymentPercentage(for liability: Liability) -> Double {
        liabilityAnalyzer.calculateRepaymentPercentage(for: liability).doubleValue
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
