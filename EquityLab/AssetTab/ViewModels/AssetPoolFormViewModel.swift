//
//  AssetPoolFormViewModel.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 14.07.24.
//

import Foundation
import CoreData

@Observable
class AssetPoolFormViewModel {
    private var context: NSManagedObjectContext
    private var pools: [AssetPool]
    public var assetPool: AssetPool?
    public var assetPoolName: String
    
    
    init(pool: AssetPool? = nil, allPools: [AssetPool]) {
        self.context = DataService.shared.persistentContainer.viewContext
        self.pools = allPools
        self.assetPoolName = pool?.name ?? ""
        self.assetPool = pool
    }
    
    func saveAssetPool() {
        if let assetPool {
            updateAssetPool(pool: assetPool)
        } else {
            createAssetPool()
        }
    }
    
    func deleteAssetPool(pool: AssetPool) {
        context.delete(pool)
        try? context.save()
    }
    
    func createAssetPool() {
        let pool = AssetPool(context: context)
        pool.name = assetPoolName
        try? context.save()
    }
    
    func updateAssetPool(pool: AssetPool) {
        pool.name = assetPoolName
        try? context.save()
    }
}
