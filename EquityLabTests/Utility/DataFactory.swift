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
}
