import CoreData
import os
import SwiftUI
import Observation

@Observable
class DashboardViewModel {
    @ObservationIgnored private static let logger = Logger(subsystem: .dashboardTab, component: .dashboardViewModel)
    
    @ObservationIgnored private var snapshotRepository: SnapshotRepository
    @ObservationIgnored private let snapshotAnalyzer: SnapshotAnalyzer
    @ObservationIgnored private var equityValueCache = [Snapshot:Decimal]()
    @ObservationIgnored private var assetValueCache = [Snapshot:Decimal]()
    @ObservationIgnored private var liabilityValueCache = [Snapshot:Decimal]()
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
    var selectedSnapshotDetailPage: SnapshotDetailPage = .changeDetailPage
    
    
    init(snapshotRepository: SnapshotRepository = .production) {
        Self.logger.debug("DashboardViewModel()")
        self.snapshotRepository = snapshotRepository
        self.snapshotAnalyzer = SnapshotAnalyzer(repository: snapshotRepository)
        self.snapshotRepository.add(observer: self)
        self.snapshots = snapshotRepository.getSnapshots().sorted{ $0.date ?? .distantFuture < $1.date ?? .distantFuture }
        for snapshot in snapshots {
            equityValueCache[snapshot] = snapshotAnalyzer.calculateEquityValue(for: snapshot)
        }
        self.selectedSnapshot = snapshots.last
    }
    
    
    private func getAssetValue(of snapshot: Snapshot) -> Decimal {
        if let assetValue = assetValueCache[snapshot] {
            return assetValue
        } else {
            let assetValue = snapshotAnalyzer.calculateAssetValue(for: snapshot)
            assetValueCache[snapshot] = assetValue
            return assetValue
        }
    }
    
    private func getLiabilityValue(of snapshot: Snapshot) -> Decimal {
        if let liabilityValue = liabilityValueCache[snapshot] {
            return liabilityValue
        } else {
            let liabilityValue = snapshotAnalyzer.calculateLiabilityValue(for: snapshot)
            liabilityValueCache[snapshot] = liabilityValue
            return liabilityValue
        }
    }
    
    func getEquityValue(of snapshot: Snapshot) -> Decimal {
        Self.logger.debug("getEquityValue(of snapshot)")
        return equityValueCache[snapshot] ?? 0.0
    }
    
    func getBalanceViewModel(for snapshot: Snapshot) -> BalanceViewModel {
        Self.logger.debug("getBalanceViewModel(for snapshot)")
        return BalanceViewModel(
            assetValueString: LocalizedCurrencyFormatter.shared.string(from: getAssetValue(of: snapshot).nsDecimalNumberValue) ?? "",
            liabilityValueString: LocalizedCurrencyFormatter.shared.string(from: getLiabilityValue(of: snapshot).nsDecimalNumberValue) ?? "",
            equityValueString: LocalizedCurrencyFormatter.shared.string(from: getEquityValue(of: snapshot).nsDecimalNumberValue) ?? ""
        )
    }
    
    func initializeSelectedSnapshot() {
        Self.logger.debug("initializeSelectedSnapshot()")
        if let selectedSnapshot, !snapshots.contains(selectedSnapshot){
            self.selectedSnapshot = snapshots.last
        }
    }
    
    func computeValueByPool(for positionType: PositionType, using snapshot: Snapshot) -> [String:Decimal] {
        Self.logger.debug("computeValueByPool(for positionType, using snapshot)")
        if positionType == .assets {
            let assetPositions = snapshotRepository.getAssetPositions().filter{ $0.snapshot == snapshot }
            return Dictionary(grouping: assetPositions, by: { $0.poolName }).mapValues { array in
                array.map { $0.value.decimalValue }.reduce(0, +)
            }
        } else {
            let liabilityPositions = snapshotRepository.getLiabilityPositions().filter{ $0.snapshot == snapshot }
            return Dictionary(grouping: liabilityPositions, by: { $0.poolName }).mapValues { array in
                array.map { $0.value.decimalValue }.reduce(0, +)
            }
        }
    }
}

extension DashboardViewModel: SnapshotObserver, AssetPositionObserver, LiabilityPositionObserver {
    func notifyAfterSnapshotUpdate() {
        Self.logger.debug("notifyAfterSnapshotUpdate()")
        updateSnapshotState()
    }
    
    func notifyAfterAssetPositionUpdate() {
        Self.logger.debug("notifyAfterAssetPositionUpdate()")
        updateSnapshotState()
    }
    
    func notifyAfterLiabilityPositionUpdate() {
        Self.logger.debug("notifyAfterLiabilityPositionUpdate()")
        updateSnapshotState()
    }
    
    private func updateSnapshotState() {
        self.snapshots = snapshotRepository.getSnapshots().sorted{ $0.date ?? .distantFuture < $1.date ?? .distantFuture }
        guard let selectedSnapshot else { return }
        self.selectedSnapshot = snapshots.first(where: { $0 == selectedSnapshot })
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

enum SnapshotDetailPage {
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
