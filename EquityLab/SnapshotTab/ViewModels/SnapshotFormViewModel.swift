import Foundation
import CoreData

@Observable
class SnapshotFormViewModel {
    let context: NSManagedObjectContext
    var snapshot: Snapshot?
    var assetProxies: [PositionProxy]
    var liabilityProxies: [PositionProxy]
    var date: Date
    
    
    init(snapshot: Snapshot? = nil) {
        let context = ProductionCoreDataStack.shared.context
        self.context = context
        self.snapshot = snapshot
        if let snapshot, let date = snapshot.date {
            let assetPositions = (try? context.fetch(snapshot.getAssetPositionRequest())) ?? []
            self.assetProxies = assetPositions.map{ PositionProxy(name: $0.name, value: $0.value, pool: $0.poolName) }
            let liabilityPositions = (try? context.fetch(snapshot.getLiabilityPositionRequest())) ?? []
            self.liabilityProxies = liabilityPositions.map{ PositionProxy(name: $0.name, value: $0.value, pool: $0.poolName) }
            self.date = date
        } else {
            self.date = Date.now
            let assetFetchRequest = NSFetchRequest<Asset>(entityName: String(describing: "Asset"))
            let assets = (try? context.fetch(assetFetchRequest)) ?? []
            self.assetProxies = assets.map{ asset in
                if let possession = asset as? Possession {
                    if !possession.volatile {
                        let request = NSFetchRequest<AssetPosition>(entityName: "AssetPosition")
                        request.predicate = NSPredicate(format: "name == %@", possession.name)
                        let positions = (try? context.fetch(request)) ?? []
                        let valuesAndDates = positions.map{ (date: $0.snapshot!.date, value: $0.value) }
                        let latestValue = valuesAndDates.filter {
                            $0.date != nil
                        }.max {
                            $0.date! < $1.date!
                        }?.value ?? 0.0
                        return PositionProxy(name: possession.name, value: latestValue, pool: possession.pool?.name ?? "unknown pool")
                    } else {
                        return PositionProxy(name: possession.name, value: 0.0, pool: possession.pool?.name ?? "unknown pool")
                    }
                } else if let receivable = asset as? Receivable {
                    return PositionProxy(name: receivable.name, value: receivable.openAmount, pool: receivable.pool?.name ?? "unknown pool")
                } else {
                    fatalError("Unexpected asset type: \(type(of: asset))")
                }
            }
            
            let liabilityFetchRequest = NSFetchRequest<Liability>(entityName: String(describing: "Liability"))
            self.liabilityProxies = (try? context.fetch(liabilityFetchRequest).map{ PositionProxy(name: $0.name, value: $0.openAmount, pool: $0.pool?.name ?? "unknown pool") }) ?? []
            
            
        }
    }
    
    func getLiabilityPositions(for snapshot: Snapshot) -> [LiabilityPosition] {
        let request = snapshot.getLiabilityPositionRequest()
        return (try? context.fetch(request)) ?? []
    }
    
    func getAssetPositions(for snapshot: Snapshot) -> [AssetPosition] {
        let request = snapshot.getAssetPositionRequest()
        return (try? context.fetch(request)) ?? []
    }
    
    func getAssetProxies(for poolName: String) -> [PositionProxy] {
        assetProxies.filter{ $0.poolName == poolName}
    }
    
    func getLiabilityProxies(for poolName: String) -> [PositionProxy] {
        liabilityProxies.filter{ $0.poolName == poolName}
    }
    
    func getAssetPoolNames() -> [String] {
        let assetPoolFetchRequest = NSFetchRequest<AssetPool>(entityName: String(describing: "AssetPool"))
        return (try? context.fetch(assetPoolFetchRequest).map{ $0.name }) ?? []
    }
    
    func getLiabilityPoolNames() -> [String] {
        let liabilityPoolFetchRequest = NSFetchRequest<LiabilityPool>(entityName: String(describing: "LiabilityPool"))
        return (try? context.fetch(liabilityPoolFetchRequest).map{ $0.name }) ?? []
    }
    
    func createSnapshot() {
        //TODO: only allow creation of date if snapshot with date does not exist already
        let snapshot = Snapshot(context: context)
        snapshot.date = Calendar.current.startOfDay(for: date)
        
        var assetPositions = [AssetPosition]()
        assetProxies.forEach { proxy in
            let position = AssetPosition(context: context)
            position.name = proxy.name
            position.value = proxy.value
            position.poolName = proxy.poolName
            position.snapshot = snapshot
            assetPositions.append(position)
        }
        
        var liabilityPositions = [LiabilityPosition]()
        liabilityProxies.forEach { proxy in
            let position = LiabilityPosition(context: context)
            position.name = proxy.name
            position.value = proxy.value
            position.poolName = proxy.poolName
            position.snapshot = snapshot
            liabilityPositions.append(position)
        }
        try? context.save()
    }
    
    func updateSnapshot() {
        //TODO: only allow updates of date if snapshot with date does not exist already
        if let snapshot {
            snapshot.date = Calendar.current.startOfDay(for: date)
            let assetPositions = getAssetPositions(for: snapshot)
            assetProxies.forEach { proxy in
                if let position = assetPositions.first(where: { $0.name == proxy.name} ) {
                    position.value = proxy.value
                }
            }
            let liabilityPositions = getLiabilityPositions(for: snapshot)
            liabilityProxies.forEach { proxy in
                if let position = liabilityPositions.first(where: { $0.name == proxy.name} ) {
                    position.value = proxy.value
                }
            }
            try? context.save()
        }
    }
    
    func saveSnapshot() {
        if let _ = snapshot {
            updateSnapshot()
        } else {
            createSnapshot()
        }
    }
}

struct PositionProxy {
    var name: String
    var value: Double
    var poolName: String
    
    init(name: String, value: Double, pool: String) {
        self.name = name
        self.value = value
        self.poolName = pool
    }
}
