import os
import CoreData

@Observable
class LiabilityLedgerViewModel {
    @ObservationIgnored private static let logger = Logger(subsystem: .liabilityTab, component: .liabilityLedgerViewModel)
    
    @ObservationIgnored private let repository: LiabilityRepository
    @ObservationIgnored private var poolToLiabilitiesDictionary = [LiabilityPool:[Liability]]()
    var pools = [LiabilityPool]()
    var alertPoolName = ""
    var alertPool: LiabilityPool? = nil
    var showCreatePoolAlert = false
    var showEditPoolAlert = false
    var activeSheet: LiabilityLedgerSheetType? = nil
    
    init(repository: LiabilityRepository = .production) {
        Self.logger.debug("LiabilityLedgerViewModel()")
        self.repository = repository
        self.pools = repository.fetchLiabilityPools()
        self.repository.add(observer: self)
        for pool in pools {
            poolToLiabilitiesDictionary[pool] = repository.fetchLiabilities(for: pool)
        }
    }
    
    func liabilities(for pool: LiabilityPool) -> [Liability] {
        Self.logger.debug("liabilities(for pool)")
        return poolToLiabilitiesDictionary[pool] ?? []
    }
    
    func liabilities() -> [Liability] {
        Self.logger.debug("liabilities()")
        return Array(poolToLiabilitiesDictionary.values.flatMap { $0 })
    }
    
    func deleteLiabilities(in pool: LiabilityPool, for indexSet: IndexSet) {
        Self.logger.debug("deleteLiabilities(in pool, for indexSet)")
        guard let sectionLiabilities = poolToLiabilitiesDictionary[pool] else { return }
        indexSet.map{sectionLiabilities[$0]}.forEach{ repository.delete(liability: $0) }
    }
    
    func deleteLiabilityPool() {
        Self.logger.debug("deleteLiabilityPool()")
        guard let alertPool else { return }
        repository.delete(liabilityPool: alertPool)
    }
    
    func createLiabilityPool() {
        Self.logger.debug("createLiabilityPool()")
        repository.createLiabilityPool(named: alertPoolName)
    }
    
    func updateLiabilityPool() {
        Self.logger.debug("updateLiabilityPool()")
        guard let alertPool else { return }
        repository.update(liabilityPool: alertPool, newName: alertPoolName)
    }
    
    func resetPoolVariables() {
        Self.logger.debug("resetPoolVariables()")
        alertPool = nil
        alertPoolName = ""
    }
}

extension LiabilityLedgerViewModel: LiabilityObserver {
    func notifyAfterLiabilityUpdate() {
        Self.logger.debug("notifyAfterLiabilityUpdate()")
        pools = repository.fetchLiabilityPools()
        poolToLiabilitiesDictionary = .init()
        for pool in pools {
            poolToLiabilitiesDictionary[pool] = repository.fetchLiabilities(for: pool)
        }
    }
}

enum LiabilityLedgerSheetType: Identifiable {
    case addSheetLiability(pool: LiabilityPool)
    case updateSheetLiability(liability: Liability)
    var id: String {
        switch self {
        case .addSheetLiability(let pool):
            return "addSheetLiability-\(pool.id)"
        case .updateSheetLiability(let liability):
            return "updateSheetLiability-\(liability.id)"
        }
    }
}
