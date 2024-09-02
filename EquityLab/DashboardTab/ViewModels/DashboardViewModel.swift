import Foundation
import CoreData
import os
import SwiftUI

@Observable
class DashboardViewModel {
    @ObservationIgnored private static let loggerSubsystem = Bundle.main.bundleIdentifier ?? ""
    @ObservationIgnored private static let loggerCategory = String(describing: DashboardViewModel.self)
    @ObservationIgnored private static let logger = Logger(subsystem: loggerSubsystem, category: loggerCategory)
    
    @ObservationIgnored private unowned var repository: SnapshotRepository
    @ObservationIgnored private var equityValueCache = [Snapshot:Double]()
    @ObservationIgnored private var assetValueCache = [Snapshot:Double]()
    @ObservationIgnored private var liabilityValueCache = [Snapshot:Double]()
    private var snapshots = [Snapshot]() {
        didSet {
            for snapshot in snapshots {
                equityValueCache[snapshot] = calculateEquityValue(for: snapshot)
            }
        }
    }
    
    var filteredSnapshots: [Snapshot] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        switch selectedTimeHorizon {
        case .threeMonths:
            let threeMonthsAgo = calendar.date(byAdding: .month, value: -3, to: today)!
            return snapshots.filter{ $0.date != nil }.filter{ $0.date! >= threeMonthsAgo }
        case .sixMonths:
            let sixMonthsAgo = calendar.date(byAdding: .month, value: -6, to: today)!
            return snapshots.filter{ $0.date != nil }.filter{ $0.date! >= sixMonthsAgo }
        case .eighteenMonths:
            let eighteenMonthsAgo = calendar.date(byAdding: .month, value: -18, to: today)!
            return snapshots.filter{ $0.date != nil }.filter{ $0.date! >= eighteenMonthsAgo }
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
                    snapshot.date != nil
                }.min{ firstSnapshot, secondSnapshot in
                    firstSnapshot.date!.isCloser(to: newValue, than: secondSnapshot.date!)
                }
            }
        }
    }
    var selectedSnapshot: Snapshot?
    var noSnapshotsAvailable: Bool {
        snapshots.isEmpty
    }
    var selectedTimeHorizon: TimeHorizon = .all
    var selectedSnapshotDetailView: SnapshotDetailView = .balanceDetailView
    var selectedDetailPage: DetailPage = .changeDetailPage
    
    
    init(repository: SnapshotRepository = SnapshotRepository.production) {
        self.repository = repository
        self.repository.add(observer: self)
        self.snapshots = repository.fetchSnapshots()
        for snapshot in snapshots {
            equityValueCache[snapshot] = calculateEquityValue(for: snapshot)
        }
        self.selectedSnapshot = snapshots.last
    }
    
    
    private func calculateEquityValue(for snapshot: Snapshot) -> Double {
        let totalLiabilityValue = calculateLiabilityValue(for: snapshot)
        let totalAssetValue = calculateAssetValue(for: snapshot)
        return totalAssetValue - totalLiabilityValue
    }
    
    private func calculateAssetValue(for snapshot: Snapshot) -> Double {
        let assetPositions = repository.fetchAssetPositions(of: snapshot)
        return assetPositions.map{ $0.value }.reduce(0, +)
    }
    
    private func calculateLiabilityValue(for snapshot: Snapshot) -> Double {
        let liabilityPositions = repository.fetchLiabilityPositions(of: snapshot)
        return liabilityPositions.map{ $0.value }.reduce(0, +)
    }
    
    
    func getEquityValue(of snapshot: Snapshot) -> Double {
        equityValueCache[snapshot] ?? 0.0
    }
    
    func getAssetValue(of snapshot: Snapshot) -> Double {
        if let assetValue = assetValueCache[snapshot] {
            return assetValue
        } else {
            let assetValue = calculateAssetValue(for: snapshot)
            assetValueCache[snapshot] = assetValue
            return assetValue
        }
    }
    
    func getLiabilityValue(of snapshot: Snapshot) -> Double {
        if let liabilityValue = liabilityValueCache[snapshot] {
            return liabilityValue
        } else {
            let liabilityValue = calculateLiabilityValue(for: snapshot)
            liabilityValueCache[snapshot] = liabilityValue
            return liabilityValue
        }
    }
    
    func initializeSelectedSnapshot() {
        if let selectedSnapshot, !snapshots.contains(selectedSnapshot){
            self.selectedSnapshot = snapshots.last
        }
    }
    
    func computeValueByPool(for positionType: PositionType, using snapshot: Snapshot) -> [String:Double] {
        if positionType == .assets {
            let assetPositions = repository.fetchAssetPositions(of: snapshot)
            return Dictionary(grouping: assetPositions, by: { $0.poolName }).mapValues { array in
                array.map { $0.value }.reduce(0, +)
            }
        } else {
            let liabilityPositions = repository.fetchLiabilityPositions(of: snapshot)
            return Dictionary(grouping: liabilityPositions, by: { $0.poolName }).mapValues { array in
                array.map { $0.value }.reduce(0, +)
            }
        }
    }
}

extension DashboardViewModel: SnapshotObserver {
    func updateSnapshots(with newSnapshots: [Snapshot]) {
        self.snapshots = newSnapshots
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
