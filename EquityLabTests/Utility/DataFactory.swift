@testable import EquityLab
import CoreData

struct DataFactory {
    static func createAssetPosition(name: String, poolName: String, value: Double, context: NSManagedObjectContext) -> AssetPosition {
        let assetPosition = AssetPosition(usedContext: context)
        assetPosition.name = name
        assetPosition.poolName = poolName
        assetPosition.value = value
        try? context.save()
        return assetPosition
    }
    
    static func createLiabilityPosition(name: String, poolName: String, value: Double, context: NSManagedObjectContext) -> LiabilityPosition {
        let liabilityPosition = LiabilityPosition(usedContext: context)
        liabilityPosition.name = name
        liabilityPosition.poolName = poolName
        liabilityPosition.value = value
        try? context.save()
        return liabilityPosition
    }
    
    static func createSnapshot(with assetPositions: [AssetPosition],
                                and liabilityPositions: [LiabilityPosition],
                                for date: Date,
                                in context: NSManagedObjectContext) -> Snapshot {
        let snapshot = Snapshot(usedContext: context)
        snapshot.date = date
        assetPositions.forEach{ $0.snapshot = snapshot }
        liabilityPositions.forEach{ $0.snapshot = snapshot }
        try? context.save()
        return snapshot
    }
    
    static func createSnapshotWithoutPositions(for date: Date, in context: NSManagedObjectContext) -> Snapshot {
        let snapshot = Snapshot(usedContext: context)
        snapshot.date = date
        try? context.save()
        return snapshot
    }
    
    static func createAssetPool(named name: String, possessions: [Possession], receivables: [Receivable], in context: NSManagedObjectContext) -> AssetPool {
        let pool = AssetPool(usedContext: context)
        pool.name = name
        for possession in possessions {
            possession.pool = pool
        }
        for receivable in receivables {
            receivable.pool = pool
        }
        try? context.save()
        return pool
    }
    
    static func createLiabilityPool(named name: String, liabilities: [Liability], in context: NSManagedObjectContext) -> LiabilityPool {
        let pool = LiabilityPool(usedContext: context)
        pool.name = name
        for liability in liabilities {
            liability.pool = pool
        }
        try? context.save()
        return pool
    }
    
    static func createReceivable(name: String, date: Date, debtor: String, initialAmount: Double, repaidAmount: Double, context: NSManagedObjectContext) -> Receivable {
        let receivable = Receivable(usedContext: context)
        receivable.name = name
        receivable.grantDate = date
        receivable.debtor = debtor
        receivable.initialAmount = initialAmount
        receivable.repaidAmount = repaidAmount
        try? context.save()
        return receivable
    }
    
    static func createPossession(name: String, volatile: Bool, context: NSManagedObjectContext) -> Possession {
        let possession = Possession(usedContext: context)
        possession.name = name
        possession.volatile = volatile
        try? context.save()
        return possession
    }
    
    static func createLiability(name: String, date: Date, creditor: String, initialAmount: Double, repaidAmount: Double, context: NSManagedObjectContext) -> Liability {
        let liability = Liability(usedContext: context)
        liability.name = name
        liability.creditor = creditor
        liability.grantDate = date
        liability.initialAmount = initialAmount
        liability.repaidAmount = repaidAmount
        try? context.save()
        return liability
    }
}
