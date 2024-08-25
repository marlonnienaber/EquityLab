//
//  TestDataProvider.swift
//  EquityLabTests
//
//  Created by Marlon Nienaber on 21.08.24.
//

import Foundation
@testable import EquityLab
import CoreData

class TestDataProvider {
    private func createAssetPosition(name: String, poolName: String, value: Double, context: NSManagedObjectContext) -> AssetPosition {
        let assetPosition = AssetPosition(context: context)
        assetPosition.name = name
        assetPosition.poolName = poolName
        assetPosition.value = value
        try? context.save()
        return assetPosition
    }
    
    private func createLiabilityPosition(name: String, poolName: String, value: Double, context: NSManagedObjectContext) -> LiabilityPosition {
        let liabilityPosition = LiabilityPosition(context: context)
        liabilityPosition.name = name
        liabilityPosition.poolName = poolName
        liabilityPosition.value = value
        try? context.save()
        return liabilityPosition
    }
    
    private func createSnapshot(with assetPositions: [AssetPosition],
                                and liabilityPositions: [LiabilityPosition],
                                for date: Date,
                                in context: NSManagedObjectContext) -> Snapshot {
        let snapshot = Snapshot(context: context)
        snapshot.date = date
        assetPositions.forEach{ $0.snapshot = snapshot }
        liabilityPositions.forEach{ $0.snapshot = snapshot }
        try? context.save()
        return snapshot
    }
    
    
    func createAndPersistTestObjects_assetValue_1(using context: NSManagedObjectContext) -> Snapshot {
        let assetPositions: [AssetPosition] = []
        let liabilityPositions: [LiabilityPosition] = []
        let date: Date = .now
        return createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_assetValue_2(using context: NSManagedObjectContext) -> Snapshot {
        let assetPosition1 = createAssetPosition(name: "Purse", poolName: "Cash", value: 0.0, context: context)
        let assetPosition2 = createAssetPosition(name: "Konto Sparkasse", poolName: "Bank", value: 0.0, context: context)
        let assetPosition3 = createAssetPosition(name: "Depot FNZ", poolName: "Securities", value: 0.0, context: context)
        
        let assetPositions: [AssetPosition] = [assetPosition1, assetPosition2, assetPosition3]
        let liabilityPositions: [LiabilityPosition] = []
        let date: Date = .now
        return createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_assetValue_3(using context: NSManagedObjectContext) -> Snapshot {
        let assetPosition1 = createAssetPosition(name: "Purse", poolName: "Cash", value: 5.0, context: context)
        let assetPosition2 = createAssetPosition(name: "Piggy Bank", poolName: "Cash", value: 11.4, context: context)
        let assetPosition3 = createAssetPosition(name: "Konto Sparkasse", poolName: "Bank", value: 89.76, context: context)
        let assetPosition4 = createAssetPosition(name: "Konto Commerzbank", poolName: "Bank", value: 122.33, context: context)
        let assetPosition5 = createAssetPosition(name: "Depot FNZ", poolName: "Securities", value: 50.85, context: context)
        
        let assetPositions: [AssetPosition] = [assetPosition1, assetPosition2, assetPosition3, assetPosition4, assetPosition5]
        let liabilityPositions: [LiabilityPosition] = []
        let date: Date = .now
        return createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_assetValue_4(using context: NSManagedObjectContext) -> Snapshot {
        let assetPosition1 = createAssetPosition(name: "Purse", poolName: "Cash", value: 0.0, context: context)
        let assetPosition2 = createAssetPosition(name: "Konto Sparkasse", poolName: "Bank", value: 10.0, context: context)
        
        let assetPositions: [AssetPosition] = [assetPosition1, assetPosition2]
        let liabilityPositions: [LiabilityPosition] = []
        let date: Date = .now
        return createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_assetValue_5(using context: NSManagedObjectContext) -> Snapshot {
        let assetPosition1 = createAssetPosition(name: "Purse", poolName: "Cash", value: 0.0, context: context)
        
        let assetPositions: [AssetPosition] = [assetPosition1]
        let liabilityPositions: [LiabilityPosition] = []
        let date: Date = .now
        return createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_assetValue_6(using context: NSManagedObjectContext) -> Snapshot {
        let assetPosition1 = createAssetPosition(name: "Purse", poolName: "Cash", value: 17.01, context: context)
        
        let assetPositions: [AssetPosition] = [assetPosition1]
        let liabilityPositions: [LiabilityPosition] = []
        let date: Date = .now
        return createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    
    func createAndPersistTestObjects_liabilityValue_1(using context: NSManagedObjectContext) -> Snapshot {
        let assetPositions: [AssetPosition] = []
        let liabilityPositions: [LiabilityPosition] = []
        let date: Date = .now
        return createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_liabilityValue_2(using context: NSManagedObjectContext) -> Snapshot {
        let liabilityPosition1 = createLiabilityPosition(name: "Car", poolName: "Private", value: 0.0, context: context)
        let liabilityPosition2 = createLiabilityPosition(name: "Office Building", poolName: "Business", value: 0.0, context: context)
        let liabilityPosition3 = createLiabilityPosition(name: "Server", poolName: "Business", value: 0.0, context: context)
        
        let assetPositions: [AssetPosition] = []
        let liabilityPositions: [LiabilityPosition] = [liabilityPosition1, liabilityPosition2, liabilityPosition3]
        let date: Date = .now
        return createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_liabilityValue_3(using context: NSManagedObjectContext) -> Snapshot {
        let liabilityPosition1 = createLiabilityPosition(name: "Car", poolName: "Private", value: 5.0, context: context)
        let liabilityPosition2 = createLiabilityPosition(name: "DJ Equipment", poolName: "Private", value: 11.4, context: context)
        let liabilityPosition3 = createLiabilityPosition(name: "Office Building", poolName: "Business", value: 89.76, context: context)
        let liabilityPosition4 = createLiabilityPosition(name: "Server", poolName: "Business", value: 122.33, context: context)
        let liabilityPosition5 = createLiabilityPosition(name: "Production", poolName: "Business", value: 50.85, context: context)
        
        let assetPositions: [AssetPosition] = []
        let liabilityPositions: [LiabilityPosition] = [liabilityPosition1, liabilityPosition2, liabilityPosition3, liabilityPosition4, liabilityPosition5]
        let date: Date = .now
        return createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_liabilityValue_4(using context: NSManagedObjectContext) -> Snapshot {
        let liabilityPosition1 = createLiabilityPosition(name: "DJ Equipment", poolName: "Private", value: 0.0, context: context)
        let liabilityPosition2 = createLiabilityPosition(name: "Office Building", poolName: "Business", value: 10.0, context: context)
        
        let assetPositions: [AssetPosition] = []
        let liabilityPositions: [LiabilityPosition] = [liabilityPosition1, liabilityPosition2]
        let date: Date = .now
        return createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_liabilityValue_5(using context: NSManagedObjectContext) -> Snapshot {
        let liabilityPosition1 = createLiabilityPosition(name: "DJ Equipment", poolName: "Private", value: 0.0, context: context)
        
        let assetPositions: [AssetPosition] = []
        let liabilityPositions: [LiabilityPosition] = [liabilityPosition1]
        let date: Date = .now
        return createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_liabilityValue_6(using context: NSManagedObjectContext) -> Snapshot {
        let liabilityPosition1 = createLiabilityPosition(name: "Office Building", poolName: "Business", value: 17.01, context: context)
        
        let assetPositions: [AssetPosition] = []
        let liabilityPositions: [LiabilityPosition] = [liabilityPosition1]
        let date: Date = .now
        return createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    
    func createAndPersistTestObjects_equityValue_1(using context: NSManagedObjectContext) -> Snapshot {
        let assetPosition1 = createAssetPosition(name: "Purse", poolName: "Cash", value: 4.0, context: context)
        let assetPosition2 = createAssetPosition(name: "Piggy Bank", poolName: "Cash", value: 13.77, context: context)
        
        let assetPositions: [AssetPosition] = [assetPosition1, assetPosition2]
        let liabilityPositions: [LiabilityPosition] = []
        let date: Date = .now
        return createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_equityValue_2(using context: NSManagedObjectContext) -> Snapshot {
        let liabilityPosition1 = createLiabilityPosition(name: "DJ Equipment", poolName: "Private", value: 7.04, context: context)
        let liabilityPosition2 = createLiabilityPosition(name: "Office Building", poolName: "Business", value: 13.39, context: context)
        
        let assetPositions: [AssetPosition] = []
        let liabilityPositions: [LiabilityPosition] = [liabilityPosition1, liabilityPosition2]
        let date: Date = .now
        return createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_equityValue_3(using context: NSManagedObjectContext) -> Snapshot {
        let assetPosition1 = createAssetPosition(name: "Purse", poolName: "Cash", value: 0.0, context: context)
        let assetPosition2 = createAssetPosition(name: "Piggy Bank", poolName: "Cash", value: 11.4, context: context)
        let assetPosition3 = createAssetPosition(name: "Konto Sparkasse", poolName: "Bank", value: 89.76, context: context)
        let assetPosition4 = createAssetPosition(name: "Konto Commerzbank", poolName: "Bank", value: 122.33, context: context)
        let assetPosition5 = createAssetPosition(name: "Depot FNZ", poolName: "Securities", value: 50.85, context: context)
        
        let liabilityPosition1 = createLiabilityPosition(name: "DJ Equipment", poolName: "Private", value: 7.04, context: context)
        let liabilityPosition2 = createLiabilityPosition(name: "Office Building", poolName: "Business", value: 13.39, context: context)
        
        let assetPositions: [AssetPosition] = [assetPosition1, assetPosition2, assetPosition3, assetPosition4, assetPosition5]
        let liabilityPositions: [LiabilityPosition] = [liabilityPosition1, liabilityPosition2]
        let date: Date = .now
        return createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_equityValue_4(using context: NSManagedObjectContext) -> Snapshot {
        let assetPosition1 = createAssetPosition(name: "Wallet", poolName: "Cash", value: 5.75, context: context)
        let assetPosition2 = createAssetPosition(name: "Piggy Bank", poolName: "Cash", value: 15.3, context: context)
        let assetPosition3 = createAssetPosition(name: "Checking Account", poolName: "Bank", value: 120.5, context: context)
        let assetPosition4 = createAssetPosition(name: "Savings Account", poolName: "Bank", value: 240.75, context: context)
        let assetPosition5 = createAssetPosition(name: "Brokerage Account", poolName: "Securities", value: 300.45, context: context)
        let assetPosition6 = createAssetPosition(name: "401k", poolName: "Securities", value: 450.0, context: context)
        let assetPosition7 = createAssetPosition(name: "Mutual Fund", poolName: "Securities", value: 120.25, context: context)
        let assetPosition8 = createAssetPosition(name: "Emergency Fund", poolName: "Cash", value: 50.0, context: context)
        let assetPosition9 = createAssetPosition(name: "Vacation Fund", poolName: "Cash", value: 100.88, context: context)
        let assetPosition10 = createAssetPosition(name: "Real Estate Investment", poolName: "Bank", value: 350.0, context: context)
        
        let liabilityPosition1 = createLiabilityPosition(name: "Credit Card Debt", poolName: "Private", value: 120.99, context: context)
        let liabilityPosition2 = createLiabilityPosition(name: "Mortgage", poolName: "Business", value: 200.0, context: context)
        let liabilityPosition3 = createLiabilityPosition(name: "Car Loan", poolName: "Private", value: 150.5, context: context)
        let liabilityPosition4 = createLiabilityPosition(name: "Student Loan", poolName: "Private", value: 75.25, context: context)
        let liabilityPosition5 = createLiabilityPosition(name: "Office Lease", poolName: "Business", value: 85.0, context: context)
        let liabilityPosition6 = createLiabilityPosition(name: "Business Loan", poolName: "Business", value: 180.0, context: context)
        let liabilityPosition7 = createLiabilityPosition(name: "Equipment Lease", poolName: "Business", value: 65.35, context: context)
        
        let assetPositions: [AssetPosition] = [assetPosition1, assetPosition2, assetPosition3, assetPosition4, assetPosition5, assetPosition6, assetPosition7, assetPosition8, assetPosition9, assetPosition10]
        let liabilityPositions: [LiabilityPosition] = [liabilityPosition1, liabilityPosition2, liabilityPosition3, liabilityPosition4, liabilityPosition5, liabilityPosition6, liabilityPosition7]
        let date: Date = .now
        return createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    
    func createAndPersistTestObjects_computeValueByPool_1(using context: NSManagedObjectContext) -> Snapshot {
        let assetPosition1 = createAssetPosition(name: "Wallet", poolName: "Cash", value: 0.0, context: context)
        let assetPosition2 = createAssetPosition(name: "Piggy Bank", poolName: "Cash", value: 15.3, context: context)
        let assetPosition3 = createAssetPosition(name: "Emergency Fund", poolName: "Cash", value: 50.0, context: context)
        let assetPosition4 = createAssetPosition(name: "Vacation Fund", poolName: "Cash", value: 100.88, context: context)
        let assetPosition5 = createAssetPosition(name: "Checking Account", poolName: "Bank", value: 120.5, context: context)
        let assetPosition6 = createAssetPosition(name: "Savings Account", poolName: "Bank", value: 240.75, context: context)
        let assetPosition7 = createAssetPosition(name: "Real Estate Investment", poolName: "Bank", value: 350.0, context: context)
        let assetPosition8 = createAssetPosition(name: "Brokerage Account", poolName: "Securities", value: 300.45, context: context)
        let assetPosition9 = createAssetPosition(name: "401k", poolName: "Securities", value: 450.0, context: context)
        let assetPosition10 = createAssetPosition(name: "Mutual Fund", poolName: "Securities", value: 120.25, context: context)
        
        let liabilityPosition1 = createLiabilityPosition(name: "Credit Card Debt", poolName: "Private", value: 0.0, context: context)
        let liabilityPosition3 = createLiabilityPosition(name: "Car Loan", poolName: "Private", value: 150.5, context: context)
        let liabilityPosition4 = createLiabilityPosition(name: "Student Loan", poolName: "Private", value: 75.25, context: context)
        let liabilityPosition2 = createLiabilityPosition(name: "Mortgage", poolName: "Business", value: 200.0, context: context)
        let liabilityPosition5 = createLiabilityPosition(name: "Office Lease", poolName: "Business", value: 85.0, context: context)
        let liabilityPosition6 = createLiabilityPosition(name: "Business Loan", poolName: "Business", value: 180.0, context: context)
        let liabilityPosition7 = createLiabilityPosition(name: "Equipment Lease", poolName: "Business", value: 65.35, context: context)
        
        let assetPositions: [AssetPosition] = [assetPosition1, assetPosition2, assetPosition3, assetPosition4, assetPosition5, assetPosition6, assetPosition7, assetPosition8, assetPosition9, assetPosition10]
        let liabilityPositions: [LiabilityPosition] = [liabilityPosition1, liabilityPosition2, liabilityPosition3, liabilityPosition4, liabilityPosition5, liabilityPosition6, liabilityPosition7]
        let date: Date = .now
        return createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_computeValueByPool_2(using context: NSManagedObjectContext) -> Snapshot {
        let assetPositions: [AssetPosition] = []
        let liabilityPositions: [LiabilityPosition] = []
        let date: Date = .now
        return createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_computeValueByPool_3(using context: NSManagedObjectContext) -> Snapshot {
        let assetPosition1 = createAssetPosition(name: "Wallet", poolName: "Cash", value: 5.75, context: context)
        let liabilityPosition1 = createLiabilityPosition(name: "Credit Card Debt", poolName: "Private", value: 120.99, context: context)
        
        let assetPositions: [AssetPosition] = [assetPosition1]
        let liabilityPositions: [LiabilityPosition] = [liabilityPosition1]
        let date: Date = .now
        return createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_computeValueByPool_4(using context: NSManagedObjectContext) -> Snapshot {
        let assetPosition1 = createAssetPosition(name: "Wallet", poolName: "Cash", value: 0.0, context: context)
        let liabilityPosition1 = createLiabilityPosition(name: "Credit Card Debt", poolName: "Private", value: 0.0, context: context)
        
        let assetPositions: [AssetPosition] = [assetPosition1]
        let liabilityPositions: [LiabilityPosition] = [liabilityPosition1]
        let date: Date = .now
        return createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_computeValueByPool_5(using context: NSManagedObjectContext) -> Snapshot {
        let assetPosition1 = createAssetPosition(name: "Wallet", poolName: "Cash", value: 0.0, context: context)
        let assetPosition2 = createAssetPosition(name: "Piggy Bank", poolName: "Cash", value: 0.0, context: context)
        let liabilityPosition1 = createLiabilityPosition(name: "Credit Card Debt", poolName: "Private", value: 0.0, context: context)
        let liabilityPosition2 = createLiabilityPosition(name: "Car Loan", poolName: "Private", value: 0.0, context: context)
        
        let assetPositions: [AssetPosition] = [assetPosition1, assetPosition2]
        let liabilityPositions: [LiabilityPosition] = [liabilityPosition1, liabilityPosition2]
        let date: Date = .now
        return createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
}
