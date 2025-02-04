import CoreData
import Retrievers
import os

class SnapshotRepositoryNew {
    private static let logger = Logger(subsystem: .snapshotTab, component: .snapshotLedgerViewModel)
    public static let production = SnapshotRepositoryNew(context: ProductionCoreDataStack.shared.context)
    private var coreDataObserver: CoreDataObserver?
    private let context: NSManagedObjectContext
    
    @Retriever var snapshots: [Snapshot]
    @Retriever var assetPositions: [AssetPosition]
    @Retriever var liabilityPositions: [LiabilityPosition]
    
    
    init(context: NSManagedObjectContext) {
        self.context = context
        
        coreDataObserver = CoreDataObserver(context: context) { [weak self] entityType in
            guard let self = self else { return }
            if entityType == Snapshot.self {
                _snapshots.triggerUpdate()
            }
            if entityType == AssetPosition.self {
                _assetPositions.triggerUpdate()
            }
            if entityType == LiabilityPosition.self {
                _liabilityPositions.triggerUpdate()
            }
        }
        
        _snapshots.toRetrieveDo {
            Snapshot.retrieveInstances(via: context)
        }
        _assetPositions.toRetrieveDo {
            AssetPosition.retrieveInstances(via: context)
        }
        _liabilityPositions.toRetrieveDo {
            LiabilityPosition.retrieveInstances(via: context)
        }
    }

    
    func createSnapshot(with date: Date, _ assetProxies: [PositionProxy], and liabilityProxies: [PositionProxy]) {
        let snapshot = Snapshot(usedContext: context)
        snapshot.date = date.startOfDay
        
        var assetPositions = [AssetPosition]()
        assetProxies.forEach { proxy in
            let position = AssetPosition(usedContext: context)
            position.name = proxy.name
            position.value = proxy.value.nsDecimalNumberValue
            position.poolName = proxy.poolName
            position.snapshot = snapshot
            assetPositions.append(position)
        }
        
        var liabilityPositions = [LiabilityPosition]()
        liabilityProxies.forEach { proxy in
            let position = LiabilityPosition(usedContext: context)
            position.name = proxy.name
            position.value = proxy.value.nsDecimalNumberValue
            position.poolName = proxy.poolName
            position.snapshot = snapshot
            liabilityPositions.append(position)
        }
        try? context.save()
    }
    
    func updateSnapshot(_ snapshot: Snapshot, using date: Date, _ assetProxies: [PositionProxy], and liabilityProxies: [PositionProxy]) {
        snapshot.date = date.startOfDay
        let assetPositions = assetPositions.filter{ $0.snapshot == snapshot }
        assetProxies.forEach { proxy in
            if let position = assetPositions.first(where: { $0.name == proxy.name} ) {
                position.value = proxy.value.nsDecimalNumberValue
            }
        }
        let liabilityPositions = liabilityPositions.filter{ $0.snapshot == snapshot }
        liabilityProxies.forEach { proxy in
            if let position = liabilityPositions.first(where: { $0.name == proxy.name} ) {
                position.value = proxy.value.nsDecimalNumberValue
            }
        }
        try? context.save()
    }
    
    func deleteSnapshot(_ snapshot: Snapshot) {
        context.delete(snapshot)
        try? context.save()
    }
}
