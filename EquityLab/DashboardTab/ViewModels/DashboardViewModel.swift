import Foundation
import CoreData
import os
import SwiftUI

@Observable
class DashboardViewModel: NSObject {
    // MARK: shared members
    @ObservationIgnored private static let loggerSubsystem = Bundle.main.bundleIdentifier ?? ""
    @ObservationIgnored private static let loggerCategory = String(describing: DashboardViewModel.self)
    @ObservationIgnored private static let logger = Logger(subsystem: loggerSubsystem, category: loggerCategory)
    
    @ObservationIgnored private let modelManager: DashboardModelManager
    @ObservationIgnored private var equityValues = [Snapshot:Double]()
    @ObservationIgnored private var assetValues = [Snapshot:Double]()
    @ObservationIgnored private var liabilityValues = [Snapshot:Double]()
    
    var selectedSnapshot: Snapshot?
    var selectedSnapshotDetailView: SnapshotDetailView = .balanceDetailView
    var selectedDetailPage: DetailPage = .changeDetailPage
    
    init(modelManager: DashboardModelManager = DashboardFetchedResultsController()) {
        self.modelManager = modelManager
        super.init()
        self.modelManager.delegate = self
        self.unfilteredSnapshots = modelManager.fetchSnapshots()
        for snapshot in unfilteredSnapshots {
            equityValues[snapshot] = calculateEquityValue(for: snapshot)
        }
        self.selectedSnapshot = unfilteredSnapshots.last
    }
    
    private func calculateEquityValue(for snapshot: Snapshot) -> Double {
        let totalLiabilityValue = calculateLiabilityValue(for: snapshot)
        let totalAssetValue = calculateAssetValue(for: snapshot)
        return totalAssetValue - totalLiabilityValue
    }
    private func calculateAssetValue(for snapshot: Snapshot) -> Double {
        let assetPositions = modelManager.fetchAssetPositions(of: snapshot)
        return assetPositions.map{ $0.value }.reduce(0, +)
    }
    private func calculateLiabilityValue(for snapshot: Snapshot) -> Double {
        let liabilityPositions = modelManager.fetchLiabilityPositions(of: snapshot)
        return liabilityPositions.map{ $0.value }.reduce(0, +)
    }
    
    func equityValue(of snapshot: Snapshot) -> Double {
        equityValues[snapshot] ?? 0.0
    }
    func assetValue(of snapshot: Snapshot) -> Double {
        if let assetValue = assetValues[snapshot] {
            return assetValue
        } else {
            let assetValue = calculateAssetValue(for: snapshot)
            assetValues[snapshot] = assetValue
            return assetValue
        }
    }
    func liabilityValue(of snapshot: Snapshot) -> Double {
        if let liabilityValue = liabilityValues[snapshot] {
            return liabilityValue
        } else {
            let liabilityValue = calculateLiabilityValue(for: snapshot)
            liabilityValues[snapshot] = liabilityValue
            return liabilityValue
        }
    }
    func initializeSelectedSnapshot() {
        if let selectedSnapshot, !unfilteredSnapshots.contains(selectedSnapshot){
            self.selectedSnapshot = unfilteredSnapshots.last
        }
    }
    func computeValueByPool(for positionType: PositionType, using snapshot: Snapshot) -> [String:Double] {
        if positionType == .assets {
            let assetPositions = modelManager.fetchAssetPositions(of: snapshot)
            return Dictionary(grouping: assetPositions, by: { $0.poolName }).mapValues { array in
                array.map { $0.value }.reduce(0, +)
            }
        } else {
            let liabilityPositions = modelManager.fetchLiabilityPositions(of: snapshot)
            return Dictionary(grouping: liabilityPositions, by: { $0.poolName }).mapValues { array in
                array.map { $0.value }.reduce(0, +)
            }
        }
    }
    
    // MARK: members NetWorthChart
    var selectedTimeHorizon: TimeHorizon = .all
    var unfilteredSnapshots = [Snapshot]()
    var filteredSnapshots: [Snapshot] {
        return unfilteredSnapshots
    }
    var selectedDate: Date? {
        get {
            selectedSnapshot?.date
        }
        set {
            if let newValue {
                selectedSnapshot = unfilteredSnapshots.min(by: {closestDayPredicate(firstShot: $0, secondShot: $1, selectedDate: newValue)} )
            }
        }
    }
    
    func closestDayPredicate(firstShot: Snapshot, secondShot: Snapshot, selectedDate: Date) -> Bool {
        computeAbsoluteMinuteDifference(first: firstShot.date, second: selectedDate) < computeAbsoluteMinuteDifference(first: secondShot.date, second: selectedDate) ? true : false
    }
    func computeAbsoluteMinuteDifference(first: Date, second: Date) -> Int {
        let components = Calendar.current.dateComponents([.minute], from: first, to: second)
        return abs(components.minute!)
    }
}

// MARK: making the viewModel testable
protocol DashboardModelManager: AnyObject {
    var delegate: NSFetchedResultsControllerDelegate? { get set }
    func fetchSnapshots() -> [Snapshot]
    func fetchAssetPositions(of snapshot: Snapshot) -> [AssetPosition]
    func fetchLiabilityPositions(of snapshot: Snapshot) -> [LiabilityPosition]
}

class DashboardFetchedResultsController: ObservingFetchedResultsController<Snapshot>, DashboardModelManager {
    init() {
        let context = DataService.shared.persistentContainer.viewContext
        let request = ObservingFetchRequest<Snapshot>(entityName: "Snapshot")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Snapshot.date, ascending: true)]
        request.observedRelationships = ["liabilities"]
        super.init(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    func fetchSnapshots() -> [Snapshot] {
        try? self.performFetch()
        return super.fetchedObjects as? [Snapshot] ?? []
    }
    func fetchAssetPositions(of snapshot: Snapshot) -> [AssetPosition] {
        (try? self.managedObjectContext.fetch(snapshot.getAssetPositionRequest())) ?? []
    }
    func fetchLiabilityPositions(of snapshot: Snapshot) -> [LiabilityPosition] {
        (try? self.managedObjectContext.fetch(snapshot.getLiabilityPositionRequest())) ?? []
    }
}


// MARK: change management
extension DashboardViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        self.unfilteredSnapshots = modelManager.fetchSnapshots()
        for snapshot in unfilteredSnapshots {
            equityValues[snapshot] = calculateEquityValue(for: snapshot)
        }
    }
}


// MARK: utilities
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
