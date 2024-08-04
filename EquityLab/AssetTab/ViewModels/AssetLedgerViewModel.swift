//
//  AssetLedgerViewModel.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 14.07.24.
//

import Foundation
import CoreData

@Observable
class AssetLedgerViewModel: NSObject {
    private let context: NSManagedObjectContext
    private let fetchedResultsController: ObservingFetchedResultsController<AssetPool>
    private var assets = [AssetPool:[Asset]]()
    var pools = [AssetPool]()
    
    override init() {
        let context = DataService.shared.persistentContainer.viewContext
        self.context = context
        let request = ObservingFetchRequest<AssetPool>(entityName: "AssetPool")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \AssetPool.name, ascending: true)]
        request.observedRelationships = ["assets"]
        fetchedResultsController = ObservingFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
            self.pools = fetchedResultsController.fetchedObjects as! [AssetPool]
            for pool in pools {
                assets[pool] = (try? context.fetch(pool.getAssetRequest())) ?? []
            }
        } catch {}
    }
    
    func assets(for pool: AssetPool) -> [Asset] {
        assets[pool] ?? []
    }
    
    func allAssets() -> [Asset] {
        Array(assets.values.flatMap { $0 })
    }
    
    func deleteAssets(in pool: AssetPool, forIndexSet indexSet: IndexSet) {
        guard let sectionAssets = assets[pool] else { return }
        indexSet.map{sectionAssets[$0]}.forEach{context.delete($0)}
        try? context.save()
    }
}

extension AssetLedgerViewModel: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        do {
            try fetchedResultsController.performFetch()
            self.pools = fetchedResultsController.fetchedObjects as! [AssetPool]
            for pool in pools {
                assets[pool] = (try? context.fetch(pool.getAssetRequest())) ?? []
            }
        } catch {}
//        guard let pool = anObject as? AssetPool else { return }
//        switch type {
//        case .update:
//            if let indexPath = indexPath, pools[indexPath.row] == pool {
//                pools[indexPath.row] = pool
//                assets[pool] = (try? context.fetch(pool.getAssetRequest())) ?? []
//            }
//        case .move:
//            /// necessary in case FetchRequests without SortDescriptors are involved (repeated fetching might cause changes in indexPath)
//            if let indexPath = indexPath, let newIndexPath = newIndexPath {
//                pools.remove(at: indexPath.row)
//                pools.insert(pool, at: newIndexPath.row)
//                assets[pool] = (try? context.fetch(pool.getAssetRequest())) ?? []
//            }
//        case .delete:
//            if let indexPath = indexPath {
//                pools.remove(at: indexPath.row)
//            }
//        case .insert:
//            if !pools.contains(pool) {
//                pools.append(pool)
//                assets[pool] = []
//            }
//        default:
//            break
//        }
    }
    
}
