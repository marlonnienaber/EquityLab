//
//  LiabilityFormViewModel.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 14.07.24.
//

import Foundation
import CoreData

@Observable
class LiabilityFormViewModel {
    private let context: NSManagedObjectContext
    private var liabilities: [Liability]
    public var liabilityPool: LiabilityPool?
    public var liability: Liability?
    public var liabilityName: String
    public var liabilityGrantDate: Date
    public var liabilityInitialAmount: Double
    public var liabilityRepaidAmount: Double
    public var liabilityCreditor: String
    
    init(liability: Liability? = nil, pool: LiabilityPool? = nil, allLiabilities: [Liability]) {
        self.context = ProductionCoreDataStack.shared.context
        self.liabilities = allLiabilities
        self.liabilityPool = pool
        self.liability = liability
        if let liability {
            self.liabilityName = liability.name
            self.liabilityGrantDate = liability.grantDate
            self.liabilityInitialAmount = liability.initialAmount
            self.liabilityRepaidAmount = liability.repaidAmount
            self.liabilityCreditor = liability.creditor
        } else {
            self.liabilityName = ""
            self.liabilityGrantDate = Date.now
            self.liabilityInitialAmount = 0.0
            self.liabilityRepaidAmount = 0.0
            self.liabilityCreditor = ""
        }
    }
    
    func createLiability() {
        let liability = Liability(context: context)
        liability.grantDate = liabilityGrantDate
        liability.creditor = liabilityCreditor
        liability.initialAmount = liabilityInitialAmount
        liability.repaidAmount = liabilityRepaidAmount
        liability.name = liabilityName
        liability.pool = liabilityPool
        try? context.save()
    }
    
    func updateLiability(liability: Liability) {
        let calendar = Calendar.current
        liability.grantDate = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: liabilityGrantDate)) ?? liability.grantDate
        liability.creditor = liabilityCreditor
        liability.initialAmount = liabilityInitialAmount
        liability.repaidAmount = liabilityRepaidAmount
        liability.name = liabilityName
        try? context.save()
    }
}
