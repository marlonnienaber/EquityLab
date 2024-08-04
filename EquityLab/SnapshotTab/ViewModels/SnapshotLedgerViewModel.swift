//
//  SnapshotLedgerViewModel.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 15.07.24.
//

import Foundation
import CoreData

@Observable
class SnapshotLedgerViewModel: NSObject {
    private let context: NSManagedObjectContext
    private let fetchedResultsController: ObservingFetchedResultsController<Snapshot>
    private var equityValues = [Snapshot:Double]()
    var snapshots = [Snapshot]()
    
    override init() {
        let context = DataService.shared.persistentContainer.viewContext
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
            for shot in snapshots {
                equityValues[shot] = calculateEquityValue(for: shot)
            }
        } catch {}
    }
    
    //TODO: remove duplicate code (see DashboardViewModel)
    private func calculateEquityValue(for snapshot: Snapshot) -> Double {
        let liabilityPositions = (try? context.fetch(snapshot.getLiabilityPositionRequest())) ?? []
        let totalLiabilityValue = liabilityPositions.map{ $0.value }.reduce(0, +)
        let assetPositions = (try? context.fetch(snapshot.getAssetPositionRequest())) ?? []
        let totalAssetValue = assetPositions.map{ $0.value }.reduce(0, +)
        return totalAssetValue - totalLiabilityValue
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
        guard let shot = anObject as? Snapshot else { return }
        switch type {
        case .update:
            if let indexPath = indexPath, snapshots[indexPath.row] == shot {
                equityValues[shot] = calculateEquityValue(for: shot)
                snapshots[indexPath.row] = shot
            }
        case .move:
            /// necessary in case FetchRequests without SortDescriptors are involved (repeated fetching might cause changes in indexPath)
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                equityValues[shot] = calculateEquityValue(for: shot)
                snapshots.remove(at: indexPath.row)
                snapshots.insert(shot, at: newIndexPath.row)
            }
        case .delete:
            if let indexPath = indexPath {
                let removedShot = snapshots.remove(at: indexPath.row)
            }
        case .insert:
            if !snapshots.contains(shot) {
                equityValues[shot] = calculateEquityValue(for: shot)
                sortedlyInsert(snapshot: shot, into: &snapshots)
            }
        default:
            break
        }
    }
    
    func sortedlyInsert(snapshot newSnapshot: Snapshot, into sortedArray: inout [Snapshot]) {
        var insertionIndex = 0
        for (index, snapshot) in sortedArray.enumerated() {
            if newSnapshot.date > snapshot.date {
                insertionIndex = index
                break
            }
        }
        sortedArray.insert(newSnapshot, at: insertionIndex)
    }
    
}
