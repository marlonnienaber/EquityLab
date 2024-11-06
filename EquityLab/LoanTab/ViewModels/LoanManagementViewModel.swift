import os
import CoreData

@Observable
class LoanManagementViewModel {
    @ObservationIgnored private static let logger = Logger(subsystem: .loanManagementTab, component: .loanManagementViewModel)
    
    @ObservationIgnored private let assetRepository: AssetRepository
    @ObservationIgnored private let liabilityRepository: LiabilityRepository
    var liabilities: [Liability]
    var receivables: [Receivable]
    var activeLoanUpdateSheet: LoanUpdateSheet?
    var selectedLoanType: LoanType?
    var showLoanUpdatePickerSheet = false
    var hasNoLoans: Bool {
        liabilities.isEmpty && receivables.isEmpty
    }
    
    init(assetRepository: AssetRepository = .production, liabilityRepository: LiabilityRepository = .production) {
        Self.logger.debug("LoanManagementViewModel()")
        
        self.assetRepository = assetRepository
        self.liabilityRepository = liabilityRepository
        
        self.liabilities = liabilityRepository.fetchLiabilities()
        self.receivables = assetRepository.fetchReceivables()

        assetRepository.$assetPools.onSetDo { [weak self] _ in
            guard let self else { return }
            receivables = assetRepository.fetchReceivables()
        }
        liabilityRepository.$liabilityPools.onSetDo { [weak self] _ in
            guard let self else { return }
            liabilities = liabilityRepository.fetchLiabilities()
        }
    }
    
    func deleteReceivables(for indexSet: IndexSet) {
        Self.logger.debug("deleteReceivables(for indexSet:)")
        indexSet.map{receivables[$0]}.forEach{assetRepository.delete(receivable: $0)}
    }
    
    func deleteLiabilities(for indexSet: IndexSet) {
        Self.logger.debug("deleteLiabilities(for indexSet:)")
        indexSet.map{liabilities[$0]}.forEach{liabilityRepository.delete(liability: $0)}
    }
}

enum LoanUpdateSheet: Identifiable {
    case receivableCreateSheet
    case liabilityCreateSheet
    case receivableUpdateSheet(Receivable)
    case liabilityUpdateSheet(Liability)
    var id: String {
        switch self {
        case .receivableCreateSheet: return "receivableCreateSheet"
        case .liabilityCreateSheet: return "liabilityCreateSheet"
        case .liabilityUpdateSheet(let liability): return "liabilityUpdateSheet-\(liability)"
        case .receivableUpdateSheet(let receivable): return "receivableUpdateSheet\(receivable)"
        }
    }
}

enum LoanType {
    case receivable
    case liability
}
