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
    
    private func createSnapshotWithoutPositions(for date: Date, in context: NSManagedObjectContext) -> Snapshot {
        let snapshot = Snapshot(context: context)
        snapshot.date = date
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
    
    
    func createAndPersistTestObjects_filteredSnapshots_1(using context: NSManagedObjectContext) -> ([Snapshot],[Snapshot],[Snapshot],[Snapshot]) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        
        let threeMonthScopeDate1 = calendar.date(byAdding: DateComponents(day: -6), to: today)!
        let threeMonthScopeDate2 = calendar.date(byAdding: DateComponents(month: -1, day: -14), to: today)!
        let threeMonthScopeDate3 = calendar.date(byAdding: DateComponents(month: -2, day: -17), to: today)!
        let threeMonthScopeDate4 = calendar.date(byAdding: DateComponents(month: -3), to: today)!
        
        let sixMonthScopeDate1 = calendar.date(byAdding: DateComponents(month: -3, day: -2), to: today)!
        let sixMonthScopeDate2 = calendar.date(byAdding: DateComponents(month: -4, day: -6), to: today)!
        let sixMonthScopeDate3 = calendar.date(byAdding: DateComponents(month: -5, day: -21), to: today)!
        let sixMonthScopeDate4 = calendar.date(byAdding: DateComponents(month: -6), to: today)!
        
        let eighteenMonthScopeDate1 = calendar.date(byAdding: DateComponents(month: -6, day: -1), to: today)!
        let eighteenMonthScopeDate2 = calendar.date(byAdding: DateComponents(month: -9, day: -17), to: today)!
        let eighteenMonthScopeDate3 = calendar.date(byAdding: DateComponents(month: -14, day: -13), to: today)!
        let eighteenMonthScopeDate4 = calendar.date(byAdding: DateComponents(month: -18), to: today)!
        
        let allScopeDate1 = calendar.date(byAdding: DateComponents(month: -18, day: -1), to: today)!
        let allScopeDate2 = calendar.date(byAdding: DateComponents(month: -30, day: -1), to: today)!
        
        let threeMonthSnapshot1 = createSnapshotWithoutPositions(for: threeMonthScopeDate1, in: context)
        let threeMonthSnapshot2 = createSnapshotWithoutPositions(for: threeMonthScopeDate2, in: context)
        let threeMonthSnapshot3 = createSnapshotWithoutPositions(for: threeMonthScopeDate3, in: context)
        let threeMonthSnapshot4 = createSnapshotWithoutPositions(for: threeMonthScopeDate4, in: context)
        let threeMonthSnapshots = [threeMonthSnapshot1, threeMonthSnapshot2, threeMonthSnapshot3, threeMonthSnapshot4]
        
        let sixMonthSnapshot1 = createSnapshotWithoutPositions(for: sixMonthScopeDate1, in: context)
        let sixMonthSnapshot2 = createSnapshotWithoutPositions(for: sixMonthScopeDate2, in: context)
        let sixMonthSnapshot3 = createSnapshotWithoutPositions(for: sixMonthScopeDate3, in: context)
        let sixMonthSnapshot4 = createSnapshotWithoutPositions(for: sixMonthScopeDate4, in: context)
        let sixMonthSnapshots = [sixMonthSnapshot1, sixMonthSnapshot2, sixMonthSnapshot3, sixMonthSnapshot4]
        
        let eighteenMonthSnapshot1 = createSnapshotWithoutPositions(for: eighteenMonthScopeDate1, in: context)
        let eighteenMonthSnapshot2 = createSnapshotWithoutPositions(for: eighteenMonthScopeDate2, in: context)
        let eighteenMonthSnapshot3 = createSnapshotWithoutPositions(for: eighteenMonthScopeDate3, in: context)
        let eighteenMonthSnapshot4 = createSnapshotWithoutPositions(for: eighteenMonthScopeDate4, in: context)
        let eighteenMonthSnapshots = [eighteenMonthSnapshot1, eighteenMonthSnapshot2, eighteenMonthSnapshot3, eighteenMonthSnapshot4]
        
        let allScopeSnapshot1 = createSnapshotWithoutPositions(for: allScopeDate1, in: context)
        let allScopeSnapshot2 = createSnapshotWithoutPositions(for: allScopeDate2, in: context)
        let allScopeSnapshots = [allScopeSnapshot1, allScopeSnapshot2]
        
        return (threeMonthSnapshots, sixMonthSnapshots, eighteenMonthSnapshots, allScopeSnapshots)
    }
}
