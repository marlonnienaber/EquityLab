import os
import CoreData

@Observable
class LiabilityFormViewModel {
    @ObservationIgnored private static let logger = Logger(subsystem: .liabilityTab, component: .liabilityFormViewModel)
    
    @ObservationIgnored private let repository: LiabilityRepository
    var liabilityPool: LiabilityPool?
    var liability: Liability?
    var liabilityName: String
    var liabilityGrantDate: Date
    var liabilityInitialAmount: Double
    var liabilityRepaidAmount: Double
    var liabilityCreditor: String
    let dismissSheet: () -> ()
    
    init(liability: Liability? = nil, pool: LiabilityPool? = nil, repository: LiabilityRepository = .production, dismissSheet: @escaping () -> ()) {
        Self.logger.debug("LiabilityFormViewModel()")
        self.repository = repository
        self.liabilityPool = pool
        self.liability = liability
        if let liability {
            self.liabilityName = liability.name
            self.liabilityGrantDate = liability.grantDate
            self.liabilityInitialAmount = liability.initialAmount
            self.liabilityRepaidAmount = liability.repaidAmount
            self.liabilityCreditor = liability.creditor
        } else {
            self.liabilityName = ""
            self.liabilityGrantDate = Date.now
            self.liabilityInitialAmount = 0.0
            self.liabilityRepaidAmount = 0.0
            self.liabilityCreditor = ""
        }
        self.dismissSheet = dismissSheet
    }
    
    func createLiability() {
        Self.logger.debug("createLiability()")
        guard let liabilityPool else { return }
        repository.createLiability(name: liabilityName,
                                   pool: liabilityPool,
                                   creditor: liabilityCreditor,
                                   initialAmount: liabilityInitialAmount,
                                   repaidAmount: liabilityRepaidAmount,
                                   grantDate: liabilityGrantDate)
    }
    
    func updateLiability(liability: Liability) {
        Self.logger.debug("updateLiability(liability)")
        repository.updateLiability(liability: liability,
                                   newName: liabilityName,
                                   newCreditor: liabilityCreditor,
                                   newInitialAmount: liabilityInitialAmount,
                                   newRepaidAmount: liabilityRepaidAmount,
                                   newGrantDate: liabilityGrantDate)
    }
    
    func getLiabilityPools() -> [LiabilityPool] {
        print("getLiabilityPools()")
        let liabilityPools = repository.fetchLiabilityPools()
        for pool in liabilityPools {
            print(pool.name)
        }
        return liabilityPools
    }
    
    func deleteLiability() {
        Self.logger.debug("deleteLiability()")
        guard let liability else { return }
        repository.delete(liability: liability)
    }
}
