import Foundation
import CoreData
import os
import SwiftUI

@Observable
class DashboardViewModel: NSObject {
    @ObservationIgnored private static let loggerSubsystem = Bundle.main.bundleIdentifier ?? ""
    @ObservationIgnored private static let loggerCategory = String(describing: DashboardViewModel.self)
    @ObservationIgnored private static let logger = Logger(subsystem: loggerSubsystem, category: loggerCategory)
    
    @ObservationIgnored private var repository: DashboardRepository!
    @ObservationIgnored private var equityValueCache = [Snapshot:Double]()
    @ObservationIgnored private var assetValueCache = [Snapshot:Double]()
    @ObservationIgnored private var liabilityValueCache = [Snapshot:Double]()
    private var snapshots = [Snapshot]()
    
    var filteredSnapshots: [Snapshot] {
        return snapshots
    }
    var selectedDate: Date? {
        get {
            selectedSnapshot?.date
        }
        set {
            if let newValue {
                selectedSnapshot = snapshots.min{ firstSnapshot, secondSnapshot in
                    firstSnapshot.date.isCloser(to: newValue, than: secondSnapshot.date)
                }
            }
        }
    }
    var selectedSnapshot: Snapshot?
    var selectedTimeHorizon: TimeHorizon = .all
    var selectedSnapshotDetailView: SnapshotDetailView = .balanceDetailView
    var selectedDetailPage: DetailPage = .changeDetailPage
    
    
    init(context: NSManagedObjectContext = ProductionCoreDataStack.shared.context) {
        super.init()
        self.repository = DashboardRepository(context: context, viewModel: self)
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


// MARK: data access
private class DashboardRepository {
    private let fetchedResultsController: ObservingFetchedResultsController<Snapshot>
    
    init(context: NSManagedObjectContext, viewModel: DashboardViewModel) {
        let request = ObservingFetchRequest<Snapshot>(entityName: "Snapshot")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Snapshot.date, ascending: true)]
        request.observedRelationships = ["liabilities"]
        fetchedResultsController = .init(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = viewModel
    }
    
    func fetchSnapshots() -> [Snapshot] {
        try? fetchedResultsController.performFetch()
        return fetchedResultsController.fetchedObjects as? [Snapshot] ?? []
    }
    
    func fetchAssetPositions(of snapshot: Snapshot) -> [AssetPosition] {
        (try? fetchedResultsController.managedObjectContext.fetch(snapshot.getAssetPositionRequest())) ?? []
    }
    
    func fetchLiabilityPositions(of snapshot: Snapshot) -> [LiabilityPosition] {
        (try? fetchedResultsController.managedObjectContext.fetch(snapshot.getLiabilityPositionRequest())) ?? []
    }
}


// MARK: change management
extension DashboardViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        self.snapshots = repository.fetchSnapshots()
        for snapshot in snapshots {
            equityValueCache[snapshot] = calculateEquityValue(for: snapshot)
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

extension Date {
    func isCloser(to referenceDate: Date, than otherDate: Date) -> Bool {
        self.computeAbsoluteMinuteDifference(to: referenceDate) < otherDate.computeAbsoluteMinuteDifference(to: referenceDate)
    }
    
    func computeAbsoluteMinuteDifference(to otherDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.minute], from: self, to: otherDate)
        return abs(components.minute!)
    }
}
