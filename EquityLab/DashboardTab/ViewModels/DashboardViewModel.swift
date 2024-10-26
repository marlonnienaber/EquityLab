import CoreData
import os
import SwiftUI

@Observable
class DashboardViewModel {
    @ObservationIgnored private static let logger = Logger(subsystem: .dashboardTab, component: .dashboardViewModel)
    
    @ObservationIgnored private var snapshotRepository: SnapshotRepository
    @ObservationIgnored private let snapshotAnalyzer: SnapshotAnalyzer
    @ObservationIgnored private var equityValueCache = [Snapshot:Double]()
    @ObservationIgnored private var assetValueCache = [Snapshot:Double]()
    @ObservationIgnored private var liabilityValueCache = [Snapshot:Double]()
    private var snapshots = [Snapshot]() {
        didSet {
            for snapshot in snapshots {
                equityValueCache[snapshot] = snapshotAnalyzer.calculateEquityValue(for: snapshot)
            }
        }
    }
    
    var filteredSnapshots: [Snapshot] {
        Self.logger.debug("filteredSnapshots")
        let calendar = Calendar.current
        let today = Date.now.startOfDay
        switch selectedTimeHorizon {
        case .threeMonths:
            let threeMonthsAgo = calendar.date(byAdding: .month, value: -3, to: today)!
            return snapshots.filter{ $0.date.isNotNil }.filter{ $0.date! >= threeMonthsAgo }
        case .sixMonths:
            let sixMonthsAgo = calendar.date(byAdding: .month, value: -6, to: today)!
            return snapshots.filter{ $0.date.isNotNil }.filter{ $0.date! >= sixMonthsAgo }
        case .eighteenMonths:
            let eighteenMonthsAgo = calendar.date(byAdding: .month, value: -18, to: today)!
            return snapshots.filter{ $0.date.isNotNil }.filter{ $0.date! >= eighteenMonthsAgo }
        case .all:
            return snapshots
        }
    }
    var selectedDate: Date? {
        get {
            selectedSnapshot?.date
        }
        set {
            if let newValue {
                selectedSnapshot = snapshots.filter { snapshot in
                    snapshot.date.isNotNil
                }.min{ firstSnapshot, secondSnapshot in
                    firstSnapshot.date!.isCloser(to: newValue, than: secondSnapshot.date!)
                }
            }
        }
    }
    var selectedSnapshot: Snapshot?
    var noSnapshotsAvailable: Bool {
        Self.logger.debug("noSnapshotsAvailable")
        return snapshots.isEmpty
    }
    var selectedTimeHorizon: TimeHorizon = .all
    var selectedSnapshotDetailView: SnapshotDetailView = .balanceDetailView
    var selectedDetailPage: DetailPage = .changeDetailPage
    
    
    init(snapshotRepository: SnapshotRepository = .production) {
        Self.logger.debug("DashboardViewModel()")
        self.snapshotRepository = snapshotRepository
        self.snapshotAnalyzer = SnapshotAnalyzer(repository: snapshotRepository)
        
        snapshotRepository.$snapshots.registerObserver(self, keyPath: \.snapshots)
        snapshotRepository.$snapshots.onSetDo { [weak self] newSnapshots in
            guard let self else { return }
            for snapshot in newSnapshots {
                equityValueCache[snapshot] = snapshotAnalyzer.calculateEquityValue(for: snapshot)
            }
        }
        
        self.selectedSnapshot = snapshots.last
    }
    
    
    private func getAssetValue(of snapshot: Snapshot) -> Double {
        Self.logger.debug("getAssetValue(of snapshot)")
        if let assetValue = assetValueCache[snapshot] {
            return assetValue
        } else {
            let assetValue = snapshotAnalyzer.calculateAssetValue(for: snapshot)
            assetValueCache[snapshot] = assetValue
            return assetValue
        }
    }
    
    private func getLiabilityValue(of snapshot: Snapshot) -> Double {
        Self.logger.debug("getLiabilityValue(of snapshot)")
        if let liabilityValue = liabilityValueCache[snapshot] {
            return liabilityValue
        } else {
            let liabilityValue = snapshotAnalyzer.calculateLiabilityValue(for: snapshot)
            liabilityValueCache[snapshot] = liabilityValue
            return liabilityValue
        }
    }
    
    func getEquityValue(of snapshot: Snapshot) -> Double {
        Self.logger.debug("getEquityValue(of snapshot)")
        return equityValueCache[snapshot] ?? 0.0
    }
    
    func getBalanceViewModel(for snapshot: Snapshot) -> BalanceViewModel {
        BalanceViewModel(
            assetValueString: LocalizedCurrencyFormatter.shared.string(from: getAssetValue(of: snapshot) as NSNumber) ?? "",
            liabilityValueString: LocalizedCurrencyFormatter.shared.string(from: getLiabilityValue(of: snapshot) as NSNumber) ?? "",
            equityValueString: LocalizedCurrencyFormatter.shared.string(from: getEquityValue(of: snapshot) as NSNumber) ?? ""
        )
    }
    
    func initializeSelectedSnapshot() {
        Self.logger.debug("")
        if let selectedSnapshot, !snapshots.contains(selectedSnapshot){
            self.selectedSnapshot = snapshots.last
        }
    }
    
    func computeValueByPool(for positionType: PositionType, using snapshot: Snapshot) -> [String:Double] {
        Self.logger.debug("computeValueByPool(for positionType, using snapshot)")
        if positionType == .assets {
            let assetPositions = snapshotRepository.fetchAssetPositions(of: snapshot)
            return Dictionary(grouping: assetPositions, by: { $0.poolName }).mapValues { array in
                array.map { $0.value }.reduce(0, +)
            }
        } else {
            let liabilityPositions = snapshotRepository.fetchLiabilityPositions(of: snapshot)
            return Dictionary(grouping: liabilityPositions, by: { $0.poolName }).mapValues { array in
                array.map { $0.value }.reduce(0, +)
            }
        }
    }
}

enum PositionType {
    case assets
    case liabilities
}

enum TimeHorizon: String, CaseIterable, Identifiable {
    case threeMonths = "3M"
    case sixMonths = "6M"
    case eighteenMonths = "18M"
    case all = "ALL"

    var id: String { self.rawValue }
}

enum SnapshotDetailView: String, CaseIterable, Identifiable {
    case balanceDetailView = "Balance"
    case assetDetailView = "Assets"
    case liabilityDetailView = "Liabilities"
    var id: String { self.rawValue }
}

enum DetailPage {
    case changeDetailPage
    case distributionDetailPage
}

extension Date {
    func isCloser(to referenceDate: Date, than otherDate: Date) -> Bool {
        self.computeAbsoluteMinuteDifference(to: referenceDate) < otherDate.computeAbsoluteMinuteDifference(to: referenceDate)
    }
    
    func computeAbsoluteMinuteDifference(to otherDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.minute], from: self, to: otherDate)
        return abs(components.minute!)
    }
}

struct JsonBackup: Codable {
    let snapshots: [Snapshot]
    let liabilityPools: [LiabilityPool]
    let assetPools: [AssetPool]
}

extension URL: Identifiable {
    public var id: String {
        absoluteString
    }
}

struct BalanceViewModel {
    let assetValueString: String
    let liabilityValueString: String
    let equityValueString:String
}
