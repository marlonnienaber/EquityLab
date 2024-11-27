import os
import CoreData

@Observable // refactored for new AssetRepo
class SnapshotFormViewModel {
    @ObservationIgnored private static let logger = Logger(subsystem: .snapshotTab, component: .snapshotFormViewModel)
    
    @ObservationIgnored private var snapshotRepository: SnapshotRepository
    @ObservationIgnored private let snapshot: Snapshot?
    
    var date: Date
    let assetPoolNames: [String]
    let liabilityPoolNames: [String]
    var assetProxies: [PositionProxy]
    var liabilityProxies: [PositionProxy]
    var snapshotValidationError: SnapshotValidationError?
    var showValidationErrorAlert = false
    let dismissSheet: () -> ()
    
    init(
        snapshot: Snapshot? = nil,
        snapshotRepository: SnapshotRepository = .production,
        assetRepository: AssetRepository = .production,
        liabilityRepository: LiabilityRepository = .production,
        dismissSheet: @escaping () -> ()
    ) {
        self.snapshotRepository = snapshotRepository
        self.snapshot = snapshot
        self.dismissSheet = dismissSheet
        
        let assetProxies: [PositionProxy]
        let liabilityProxies: [PositionProxy]
        if let snapshot {
            (assetProxies, liabilityProxies) = Self.createProxies(for: snapshot, using: snapshotRepository)
            self.date = snapshot.date ?? Date.now.startOfDay
            self.assetPoolNames = assetProxies.map{ $0.poolName }.uniqued()
            self.liabilityPoolNames = liabilityProxies.map{ $0.poolName }.uniqued()
        } else {
            (assetProxies, liabilityProxies) = Self.createProxies(using: snapshotRepository,
                                                                  and: assetRepository,
                                                                  and: liabilityRepository)
            self.date = Date.now.startOfDay
            self.assetPoolNames = assetRepository.assetPools.map{ $0.name }
            self.liabilityPoolNames = liabilityRepository.liabilityPools.map{ $0.name }
        }
        self.assetProxies = assetProxies
        self.liabilityProxies = liabilityProxies
    }
    
    private static func createProxies(for snapshot: Snapshot,
                                      using snapshotRepository: SnapshotRepository) -> ([PositionProxy],[PositionProxy]) {
        let assetPositions = snapshotRepository.assetPositions.filter{ $0.snapshot == snapshot }
        let assetProxies = assetPositions.map{ PositionProxy(name: $0.name, value: $0.value.decimalValue, pool: $0.poolName) }
        let liabilityPositions = snapshotRepository.liabilityPositions.filter{ $0.snapshot == snapshot }
        let liabilityProxies = liabilityPositions.map{ PositionProxy(name: $0.name, value: $0.value.decimalValue, pool: $0.poolName) }
        return (assetProxies,liabilityProxies)
    }
    
    private static func createProxies(using snapshotRepository: SnapshotRepository,
                                      and assetRepository: AssetRepository,
                                      and liabilityRepository: LiabilityRepository) -> ([PositionProxy],[PositionProxy]) {
        let possessions = assetRepository.possessions
        let possessionProxies = possessions.map{ possession in
            if let pool = possession.pool {
                if possession.volatile {
                    return PositionProxy(name: possession.name, value: 0.0, pool: pool.name)
                } else {
                    let positions = snapshotRepository.assetPositions.filter{ $0.name == possession.name}
                    let datesAndValues: [(date:Date,value:Decimal)] = positions.map{
                        if let date = $0.snapshot?.date {
                            return (date: date, value: $0.value.decimalValue)
                        } else {
                            return nil
                        }
                    }.compactMap{ $0 }
                    let latestValue = datesAndValues.max{ $0.date < $1.date }?.value ?? 0
                    return PositionProxy(name: possession.name, value: latestValue, pool: pool.name)
                }
            } else {
                return nil
            }
        }.compactMap{ $0 }
        
        let receivablesAnalyzer = ReceivableAnalyzer(repository: assetRepository)
        let receivables = assetRepository.receivables
        let receivableProxies = receivables.map{ receivable in
            if let pool = receivable.pool {
                let openAmount = receivablesAnalyzer.calculateOpenAmount(for: receivable)
                return PositionProxy(name: receivable.name, value: openAmount, pool: pool.name)
            } else {
                return nil
            }
        }.compactMap{ $0 }
        
        let liabilityAnalyzer = LiabilityAnalyzer(repository: liabilityRepository)
        let liabilities = liabilityRepository.liabilities
        let liabilityProxies = liabilities.map{ liability in
            if let pool = liability.pool {
                let openAmount = liabilityAnalyzer.calculateOpenAmount(for: liability)
                return PositionProxy(name: liability.name, value: openAmount, pool: pool.name)
            } else {
                return nil
            }
        }.compactMap{ $0 }
        
        return (possessionProxies + receivableProxies, liabilityProxies)
    }
    
    private var snapshotWithSameDateDoesExist: Bool {
        let snapshots = snapshotRepository.snapshots
        return snapshots.contains(where: { $0.date == date.startOfDay && $0 != snapshot })
    }
    
    private func validateSnapshot() throws {
        if snapshotWithSameDateDoesExist {
            throw SnapshotValidationError.sameDateAlreadyExists
        }
    }
    
    private func createSnapshot() throws {
        try validateSnapshot()
        snapshotRepository.createSnapshot(with: date, assetProxies, and: liabilityProxies)
    }
    
    private func updateSnapshot() throws {
        guard let snapshot else { return }
        try validateSnapshot()
        snapshotRepository.updateSnapshot(snapshot, using: date, assetProxies, and: liabilityProxies)
    }
    
    
    
    func saveSnapshot() throws {
        if snapshot.isNotNil {
            try updateSnapshot()
        } else {
            try createSnapshot()
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
    var value: Decimal
    var poolName: String
    
    init(name: String, value: Decimal, pool: String) {
        self.name = name
        self.value = value
        self.poolName = pool
    }
    
    static func == (lhs: PositionProxy, rhs: PositionProxy) -> Bool {
        lhs.name == rhs.name && lhs.value == rhs.value && lhs.poolName == rhs.poolName
    }
}

enum SnapshotValidationError: String, LocalizedError {
    case sameDateAlreadyExists = "A snapshot of this day was already taken!"
    var errorDescription: String? {
        return self.rawValue
    }
}
