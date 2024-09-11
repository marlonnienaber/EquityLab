import Foundation
import CoreData

@Observable
class SnapshotLedgerViewModel: NSObject {
    private let context: NSManagedObjectContext
    private let fetchedResultsController: ObservingFetchedResultsController<Snapshot>
    private var equityValues = [Snapshot:Double]()
    private var snapshots = [Snapshot]()
    var yearToSnapshotDictionary = [Int:[Snapshot]]()
    var years = [Int]()
    
    override init() {
        let context = ProductionCoreDataStack.shared.context
        self.context = context
        let request = ObservingFetchRequest<Snapshot>(entityName: "Snapshot")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Snapshot.date, ascending: false)]
        request.observedRelationships = ["liabilities"]
        fetchedResultsController = ObservingFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
            self.snapshots = fetchedResultsController.fetchedObjects as! [Snapshot]
            for snapshot in snapshots {
                equityValues[snapshot] = calculateEquityValue(for: snapshot)
                if let year = extractYear(from: snapshot) {
                    if !yearToSnapshotDictionary.keys.contains(year) {
                        years.append(year)
                    }
                    if var associatedSnapshots = yearToSnapshotDictionary[year] {
                        associatedSnapshots.append(snapshot)
                        yearToSnapshotDictionary[year] = associatedSnapshots
                    } else {
                        yearToSnapshotDictionary[year] = [snapshot]
                    }
                }
            }
        } catch {}
    }
    
    private func extractYear(from snapshot: Snapshot) -> Int? {
        guard let date = snapshot.date else { return nil }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: date)
        return components.year
    }
    
    //TODO: remove duplicate code (see DashboardViewModel)
    private func calculateEquityValue(for snapshot: Snapshot) -> Double {
        let liabilityPositions = (try? context.fetch(snapshot.getLiabilityPositionRequest())) ?? []
        let totalLiabilityValue = liabilityPositions.map{ $0.value }.reduce(0, +)
        let assetPositions = (try? context.fetch(snapshot.getAssetPositionRequest())) ?? []
        let totalAssetValue = assetPositions.map{ $0.value }.reduce(0, +)
        return totalAssetValue - totalLiabilityValue
    }
    
    func snapshots(fallingInto year: Int) -> [Snapshot] {
        yearToSnapshotDictionary[year] ?? []
    }
    
    func deleteSnapshots(in year: Int, for indexSet: IndexSet) {
        guard let sectionSnapshots = yearToSnapshotDictionary[year] else { return }
        indexSet.map{sectionSnapshots[$0]}.forEach{context.delete($0)}
        try? context.save()
    }
    
    func deleteSnapshots(withIndices indexSet: IndexSet) {
        indexSet.map{snapshots[$0]}.forEach{context.delete($0)}
        try? context.save()
    }
    
    func equityValue(of snapshot: Snapshot) -> NSNumber {
        let equityValue = equityValues[snapshot] ?? 0.0
        return NSNumber(value: equityValue)
    }
    
}

extension SnapshotLedgerViewModel: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        do {
            try fetchedResultsController.performFetch()
            yearToSnapshotDictionary = [Int:[Snapshot]]()
            years = [Int]()
            self.snapshots = fetchedResultsController.fetchedObjects as! [Snapshot]
            for snapshot in snapshots {
                equityValues[snapshot] = calculateEquityValue(for: snapshot)
                if let year = extractYear(from: snapshot) {
                    if !yearToSnapshotDictionary.keys.contains(year) {
                        years.append(year)
                    }
                    if var associatedSnapshots = yearToSnapshotDictionary[year] {
                        associatedSnapshots.append(snapshot)
                        yearToSnapshotDictionary[year] = associatedSnapshots
                    } else {
                        yearToSnapshotDictionary[year] = [snapshot]
                    }
                }
            }
        } catch {}
    }
}
