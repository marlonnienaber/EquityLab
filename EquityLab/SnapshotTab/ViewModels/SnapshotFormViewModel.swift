
import CoreData

@Observable
class SnapshotFormViewModel {
    @ObservationIgnored private var snapshotRepository: SnapshotRepository
    @ObservationIgnored private let snapshot: Snapshot?
    var date: Date //TODO: test
    let assetPoolNames: [String] //TODO: test
    let liabilityPoolNames: [String] //TODO: test
    var assetProxies: [PositionProxy] //TODO: test
    var liabilityProxies: [PositionProxy] //TODO: test
    let dismissSheet: () -> ()
    
    init(
            snapshot: Snapshot? = nil,
            snapshotRepository: SnapshotRepository = SnapshotRepository.production,
            assetRepository: AssetRepository = AssetRepository.production,
            liabilityRepository: LiabilityRepository = LiabilityRepository.production,
            dismissSheet: @escaping () -> ()
        )
    {
        self.snapshotRepository = snapshotRepository
        self.snapshot = snapshot
        self.dismissSheet = dismissSheet
        
        let assetProxies: [PositionProxy]
        let liabilityProxies: [PositionProxy]
        if let snapshot, let date = snapshot.date {
            let assetPositions = snapshotRepository.fetchAssetPositions(of: snapshot)
            assetProxies = assetPositions.map{ PositionProxy(name: $0.name, value: $0.value, pool: $0.poolName) }
            let liabilityPositions = snapshotRepository.fetchLiabilityPositions(of: snapshot)
            liabilityProxies = liabilityPositions.map{ PositionProxy(name: $0.name, value: $0.value, pool: $0.poolName) }
            self.date = date
        } else {
            self.date = Date.now
            let assets = assetRepository.fetchAssets()
            assetProxies = assets.map{ asset in
                if let possession = asset as? Possession, let pool = possession.pool {
                    if possession.volatile {
                        return PositionProxy(name: possession.name, value: 0.0, pool: pool.name)
                    } else {
                        let positions = snapshotRepository.fetchAssetPositions(with: possession.name)
                        let datesAndValues: [(date:Date,value:Double)] = positions.map{
                            if let date = $0.snapshot?.date {
                                return (date: date, value: $0.value)
                            } else {
                                return nil
                            }
                        }.compactMap{ $0 }
                        let latestValue = datesAndValues.max{ $0.date < $1.date }?.value ?? 0.0
                        return PositionProxy(name: possession.name, value: latestValue, pool: pool.name)
                    }
                } else if let receivable = asset as? Receivable, let pool = receivable.pool {
                    return PositionProxy(name: receivable.name, value: receivable.openAmount, pool: pool.name)
                } else {
                    return nil
                }
            }.compactMap{ $0 }
            
            let liabilities = liabilityRepository.fetchLiabilities()
            liabilityProxies = liabilities.map{ PositionProxy(name: $0.name, value: $0.openAmount, pool: $0.pool!.name) }
        }
        self.assetProxies = assetProxies
        self.liabilityProxies = liabilityProxies
        self.assetPoolNames = assetRepository.fetchAssetPools().map{ $0.name }
        self.liabilityPoolNames = liabilityRepository.fetchLiabilityPools().map{ $0.name }
    }
    
    private func createSnapshot() {
        snapshotRepository.createSnapshot(with: date, assetProxies, and: liabilityProxies)
    }
    
    private func updateSnapshot() {
        if let snapshot {
            snapshotRepository.updateSnapshot(snapshot, using: date, assetProxies, and: liabilityProxies)
        }
    }
    
    func saveSnapshot() { //TODO: test
        if snapshot != nil {
            updateSnapshot()
        } else {
            createSnapshot()
        }
    }
    
    func getAssetProxies(for poolName: String) -> [PositionProxy] { //TODO: test
        assetProxies.filter{ $0.poolName == poolName}
    }
    
    func getLiabilityProxies(for poolName: String) -> [PositionProxy] { //TODO: test
        liabilityProxies.filter{ $0.poolName == poolName}
    }
}

class PositionProxy {
    var name: String
    var value: Double
    var poolName: String
    
    init(name: String, value: Double, pool: String) {
        self.name = name
        self.value = value
        self.poolName = pool
    }
}
