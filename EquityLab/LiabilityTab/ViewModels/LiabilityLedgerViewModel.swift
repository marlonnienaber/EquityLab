//
//  LiabilityLedgerViewModel.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 14.07.24.
//

import Foundation
import CoreData

@Observable
class LiabilityLedgerViewModel: NSObject {
    private let context: NSManagedObjectContext
    private let fetchedResultsController: ObservingFetchedResultsController<LiabilityPool>
    private var liabilities = [LiabilityPool:[Liability]]()
    var pools = [LiabilityPool]()
    var showCreatePoolAlert = false
    var showEditPoolAlert = false
    var pool: LiabilityPool? = nil
    var poolName = ""
    var activeSheet: LiabilityLedgerSheetType? = nil
    
    override init() {
        let context = ProductionCoreDataStack.shared.context
        self.context = context
        let request = ObservingFetchRequest<LiabilityPool>(entityName: "LiabilityPool")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Liability.name, ascending: true)]
        request.observedRelationships = ["liabilities"]
        fetchedResultsController = ObservingFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
            self.pools = fetchedResultsController.fetchedObjects as! [LiabilityPool]
            for pool in pools {
                liabilities[pool] = (try? context.fetch(pool.getLiabilityRequest())) ?? []
            }
        } catch {}
    }
    
    func liabilities(for pool: LiabilityPool) -> [Liability] {
        liabilities[pool] ?? []
    }
    
    func allLiabilities() -> [Liability] {
        Array(liabilities.values.flatMap { $0 })
    }
    
    func deleteLiabilities(in pool: LiabilityPool, for indexSet: IndexSet) {
        guard let sectionLiabilities = liabilities[pool] else { return }
        indexSet.map{sectionLiabilities[$0]}.forEach{context.delete($0)}
        try? context.save()
    }
    
    func deleteLiabilityPool() {
        guard let pool else { return }
        context.delete(pool)
        try? context.save()
    }
    
    func createLiabilityPool() {
        let pool = LiabilityPool(context: context)
        pool.name = poolName
        try? context.save()
    }
    
    func updateLiabilityPool() {
        guard let pool else { return }
        pool.name = poolName
        try? context.save()
    }
    
    func resetPoolVariables() {
        pool = nil
        poolName = ""
    }
}

extension LiabilityLedgerViewModel: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        do {
            try fetchedResultsController.performFetch()
            self.pools = fetchedResultsController.fetchedObjects as! [LiabilityPool]
            for pool in pools {
                liabilities[pool] = (try? context.fetch(pool.getLiabilityRequest())) ?? []
            }
        } catch {}
//        guard let pool = anObject as? LiabilityPool else { return }
//        switch type {
//        case .update:
//            if let indexPath = indexPath, pools[indexPath.row] == pool {
//                pools[indexPath.row] = pool
//                liabilities[pool] = (try? context.fetch(pool.getLiabilityRequest())) ?? []
//            }
//        case .move:
//            /// necessary in case FetchRequests without SortDescriptors are involved (repeated fetching might cause changes in indexPath)
//            if let indexPath = indexPath, let newIndexPath = newIndexPath {
//                pools.remove(at: indexPath.row)
//                pools.insert(pool, at: newIndexPath.row)
//                liabilities[pool] = (try? context.fetch(pool.getLiabilityRequest())) ?? []
//            }
//        case .delete:
//            if let indexPath = indexPath {
//                pools.remove(at: indexPath.row)
//            }
//        case .insert:
//            if !pools.contains(pool) {
//                pools.append(pool)
//                liabilities[pool] = []
//            }
//        default:
//            break
//        }
    }
    
}

enum LiabilityLedgerSheetType: Identifiable {
    var id: UUID { UUID() }
    case addSheetLiability(pool: LiabilityPool)
    case updateSheetLiability(liability: Liability)
}
