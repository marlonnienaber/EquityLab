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
    var hasNoLoans: Bool {
        liabilities.isEmpty && receivables.isEmpty
    }
    
    init(assetRepository: AssetRepository = .production, liabilityRepository: LiabilityRepository = .production) {
        self.assetRepository = assetRepository
        self.liabilityRepository = liabilityRepository
        
        self.receivables = assetRepository.fetchReceivables()
        self.liabilities = liabilityRepository.fetchLiabilities()

        assetRepository.add(observer: self)
        liabilityRepository.add(observer: self)
    }
    
    func deleteReceivables(for indexSet: IndexSet) {
        indexSet.map{receivables[$0]}.forEach{assetRepository.delete(asset: $0)}
    }
    
    func deleteLiabilities(for indexSet: IndexSet) {
        indexSet.map{liabilities[$0]}.forEach{liabilityRepository.delete(liability: $0)}
    }
}

extension LoanManagementViewModel: AssetObserver, LiabilityObserver {
    func notifyAfterAssetUpdate() {
        self.receivables = assetRepository.fetchReceivables()
    }
    
    func notifyAfterLiabilityUpdate() {
        self.liabilities = liabilityRepository.fetchLiabilities()
    }
}

enum LoanUpdateSheet: Identifiable {
    case receivableUpdateSheet(Receivable)
    case liabilityUpdateSheet(Liability)
    var id: String {
        switch self {
        case .liabilityUpdateSheet(let liability): return "liabilityUpdateSheet-\(liability)"
        case .receivableUpdateSheet(let receivable): return "receivableUpdateSheet\(receivable)"
        }
    }
}
