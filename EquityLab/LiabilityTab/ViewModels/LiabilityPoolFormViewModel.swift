//
//  LiabilityPoolFormViewModel.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 14.07.24.
//

import Foundation
import CoreData

class LiabilityPoolFormViewModel {
    private let context: NSManagedObjectContext
    private var pools: [LiabilityPool]
    public var liabilityPool: LiabilityPool?
    public var liabilityPoolName: String
    
    init(pool: LiabilityPool? = nil, allPools: [LiabilityPool]) {
        self.context = DataService.shared.persistentContainer.viewContext
        self.pools = allPools
        self.liabilityPool = pool
        self.liabilityPoolName = pool?.name ?? ""
    }
    
    func saveLiabilityPool() {
        if let liabilityPool {
            updateLiabilityPool(pool: liabilityPool)
        } else if !pools.contains(where: {$0.name == liabilityPoolName}) {
            createLiabilityPool()
        }
    }
    
    func updateLiabilityPool(pool: LiabilityPool) {
        pool.name = liabilityPoolName
        try? context.save()
    }
    
    func createLiabilityPool() {
        let pool = LiabilityPool(context: context)
        pool.name = liabilityPoolName
        try? context.save()
    }
    
    func deleteLiabilityPool(pool: LiabilityPool) {
        context.delete(pool)
        try? context.save()
    }
    
}
