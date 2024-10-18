
import CoreData

@Observable
class SnapshotFormViewModel {
    @ObservationIgnored private var snapshotRepository: SnapshotRepository
    @ObservationIgnored private let snapshot: Snapshot?
    var date: Date
    let assetPoolNames: [String]
    let liabilityPoolNames: [String]
    var assetProxies: [PositionProxy]
    var liabilityProxies: [PositionProxy]
    let dismissSheet: () -> ()
    
    init(
            snapshot: Snapshot? = nil,
            snapshotRepository: SnapshotRepository = .production,
            assetRepository: AssetRepository = .production,
            liabilityRepository: LiabilityRepository = .production,
            dismissSheet: @escaping () -> ()
        )
    {
        self.snapshotRepository = snapshotRepository
        self.snapshot = snapshot
        self.dismissSheet = dismissSheet
        
        let assetProxies: [PositionProxy]
        let liabilityProxies: [PositionProxy]
        if let snapshot {
            (assetProxies, liabilityProxies) = Self.createProxies(for: snapshot, using: snapshotRepository)
            self.date = snapshot.date ?? Date.now
            self.assetPoolNames = assetProxies.map{ $0.poolName }.uniqued()
            self.liabilityPoolNames = liabilityProxies.map{ $0.poolName }.uniqued()
        } else {
            (assetProxies, liabilityProxies) = Self.createProxies(using: snapshotRepository, and: assetRepository, and: liabilityRepository)
            self.date = Date.now.startOfDay
            self.assetPoolNames = assetRepository.fetchAssetPools().map{ $0.name }
            self.liabilityPoolNames = liabilityRepository.fetchLiabilityPools().map{ $0.name }
        }
        self.assetProxies = assetProxies
        self.liabilityProxies = liabilityProxies
    }
    
    private static func createProxies(for snapshot: Snapshot,
                                      using snapshotRepository: SnapshotRepository) -> ([PositionProxy],[PositionProxy]) {
        let assetPositions = snapshotRepository.fetchAssetPositions(of: snapshot)
        let assetProxies = assetPositions.map{ PositionProxy(name: $0.name, value: $0.value, pool: $0.poolName) }
        let liabilityPositions = snapshotRepository.fetchLiabilityPositions(of: snapshot)
        let liabilityProxies = liabilityPositions.map{ PositionProxy(name: $0.name, value: $0.value, pool: $0.poolName) }
        return (assetProxies,liabilityProxies)
    }
    
    private static func createProxies(using snapshotRepository: SnapshotRepository,
                                      and assetRepository: AssetRepository,
                                      and liabilityRepository: LiabilityRepository) -> ([PositionProxy],[PositionProxy]) {
        let assets = assetRepository.fetchAssets()
        let assetProxies = assets.map{ asset in
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
        let liabilityProxies = liabilities.map{
            if let pool = $0.pool {
                return PositionProxy(name: $0.name, value: $0.openAmount, pool: pool.name)
            } else {
                return nil
            }
        }.compactMap{ $0 }
        return (assetProxies,liabilityProxies)
    }
    
    private func createSnapshot() {
        snapshotRepository.createSnapshot(with: date, assetProxies, and: liabilityProxies)
    }
    
    private func updateSnapshot() {
        if let snapshot {
            snapshotRepository.updateSnapshot(snapshot, using: date, assetProxies, and: liabilityProxies)
        }
    }
    
    func saveSnapshot() {
        if snapshot.isNotNil {
            updateSnapshot()
        } else {
            createSnapshot()
        }
    }
    
    func getAssetProxies(for poolName: String) -> [PositionProxy] {
        assetProxies.filter{ $0.poolName == poolName}
    }
    
    func getLiabilityProxies(for poolName: String) -> [PositionProxy] {
        liabilityProxies.filter{ $0.poolName == poolName}
    }
}

class PositionProxy: Equatable {
    var name: String
    var value: Double
    var poolName: String
    
    init(name: String, value: Double, pool: String) {
        self.name = name
        self.value = value
        self.poolName = pool
    }
    
    static func == (lhs: PositionProxy, rhs: PositionProxy) -> Bool {
        lhs.name == rhs.name && lhs.value == rhs.value && lhs.poolName == rhs.poolName
    }
}
