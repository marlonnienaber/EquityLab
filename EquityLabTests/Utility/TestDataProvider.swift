@testable import EquityLab
import CoreData

class TestDataProvider {
    /* MARK: utility functions */
    
    private func createAssetPosition(name: String, poolName: String, value: Double, context: NSManagedObjectContext) -> AssetPosition {
        let assetPosition = AssetPosition(usedContext: context)
        assetPosition.name = name
        assetPosition.poolName = poolName
        assetPosition.value = value
        try? context.save()
        return assetPosition
    }
    
    private func createLiabilityPosition(name: String, poolName: String, value: Double, context: NSManagedObjectContext) -> LiabilityPosition {
        let liabilityPosition = LiabilityPosition(usedContext: context)
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
        let snapshot = Snapshot(usedContext: context)
        snapshot.date = date
        assetPositions.forEach{ $0.snapshot = snapshot }
        liabilityPositions.forEach{ $0.snapshot = snapshot }
        try? context.save()
        return snapshot
    }
    
    private func createSnapshotWithoutPositions(for date: Date, in context: NSManagedObjectContext) -> Snapshot {
        let snapshot = Snapshot(usedContext: context)
        snapshot.date = date
        try? context.save()
        return snapshot
    }
    
    
    /* MARK: DashboardViewModel */
    
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
    
    
    func createAndPersistTestObjects_selectedDate_1(using context: NSManagedObjectContext) -> Snapshot {
        let today = Calendar.current.startOfDay(for: .now)
        return createSnapshotWithoutPositions(for: today, in: context)
    }
    
    func createAndPersistTestObjects_selectedDate_2(using context: NSManagedObjectContext) -> (Snapshot, Snapshot) {
        let date_15_04_2024 = DateParser.shared.date(from: "2024-04-15T00:00:00Z")!
        let date_15_03_2024 = DateParser.shared.date(from: "2024-03-15T00:00:00Z")!

        let snapshot_15_04_2024 = createSnapshotWithoutPositions(for: date_15_04_2024, in: context)
        let snapshot_15_03_2024 = createSnapshotWithoutPositions(for: date_15_03_2024, in: context)
        
        return (snapshot_15_03_2024, snapshot_15_04_2024)
    }
    
    func createAndPersistTestObjects_selectedDate_3(using context: NSManagedObjectContext) -> (Snapshot, Snapshot, Snapshot) {
        let date_10_05_2023 = DateParser.shared.date(from: "2023-05-10T00:00:00Z")!
        let date_13_05_2023 = DateParser.shared.date(from: "2023-05-13T00:00:00Z")!
        let date_15_05_2023 = DateParser.shared.date(from: "2023-05-15T00:00:00Z")!
        
        let snapshot_10_05_2023 = createSnapshotWithoutPositions(for: date_10_05_2023, in: context)
        let snapshot_13_05_2023 = createSnapshotWithoutPositions(for: date_13_05_2023, in: context)
        let snapshot_15_05_2023 = createSnapshotWithoutPositions(for: date_15_05_2023, in: context)
        
        return (snapshot_10_05_2023, snapshot_13_05_2023, snapshot_15_05_2023)
    }
    
    func createAndPersistTestObjects_selectedDate_4(using context: NSManagedObjectContext) -> (Snapshot, Snapshot, Snapshot) {
        let date_17_05_2022 = DateParser.shared.date(from: "2022-05-17T00:00:00Z")!
        let date_05_09_2022 = DateParser.shared.date(from: "2022-09-05T00:00:00Z")!
        let date_15_12_2022 = DateParser.shared.date(from: "2022-12-15T00:00:00Z")!
        
        let snapshot_17_05_2022 = createSnapshotWithoutPositions(for: date_17_05_2022, in: context)
        let snapshot_05_09_2022 = createSnapshotWithoutPositions(for: date_05_09_2022, in: context)
        let snapshot_15_12_2022 = createSnapshotWithoutPositions(for: date_15_12_2022, in: context)
        
        return (snapshot_17_05_2022, snapshot_05_09_2022, snapshot_15_12_2022)
    }
    
    func createAndPersistTestObjects_selectedDate_5(using context: NSManagedObjectContext) -> [Snapshot] {
        let date_28_02_2022 = DateParser.shared.date(from: "2022-02-28T00:00:00Z")!
        let date_31_03_2022 = DateParser.shared.date(from: "2022-03-31T00:00:00Z")!
        let date_30_04_2022 = DateParser.shared.date(from: "2022-04-30T00:00:00Z")!
        let date_30_05_2022 = DateParser.shared.date(from: "2022-05-30T00:00:00Z")!
        let date_30_06_2022 = DateParser.shared.date(from: "2022-06-30T00:00:00Z")!
        let date_31_07_2022 = DateParser.shared.date(from: "2022-07-31T00:00:00Z")!
        let date_31_08_2022 = DateParser.shared.date(from: "2022-08-31T00:00:00Z")!
        let date_28_09_2022 = DateParser.shared.date(from: "2022-09-28T00:00:00Z")!
        let date_31_10_2022 = DateParser.shared.date(from: "2022-10-31T00:00:00Z")!
        let date_01_12_2022 = DateParser.shared.date(from: "2022-12-01T00:00:00Z")!
        let date_31_12_2022 = DateParser.shared.date(from: "2022-12-31T00:00:00Z")!
        let date_31_01_2023 = DateParser.shared.date(from: "2023-01-31T00:00:00Z")!
        let date_28_02_2023 = DateParser.shared.date(from: "2023-02-28T00:00:00Z")!
        let date_31_03_2023 = DateParser.shared.date(from: "2023-03-31T00:00:00Z")!
        let date_02_05_2023 = DateParser.shared.date(from: "2023-05-02T00:00:00Z")!
        let date_31_05_2023 = DateParser.shared.date(from: "2023-05-31T00:00:00Z")!
        
        var snapshots: [Snapshot] = []
        let snapshot_28_02_2022 = createSnapshotWithoutPositions(for: date_28_02_2022, in: context)
        snapshots.append(snapshot_28_02_2022)
        let snapshot_31_03_2022 = createSnapshotWithoutPositions(for: date_31_03_2022, in: context)
        snapshots.append(snapshot_31_03_2022)
        let snapshot_30_04_2022 = createSnapshotWithoutPositions(for: date_30_04_2022, in: context)
        snapshots.append(snapshot_30_04_2022)
        let snapshot_30_05_2022 = createSnapshotWithoutPositions(for: date_30_05_2022, in: context)
        snapshots.append(snapshot_30_05_2022)
        let snapshot_30_06_2022 = createSnapshotWithoutPositions(for: date_30_06_2022, in: context)
        snapshots.append(snapshot_30_06_2022)
        let snapshot_31_07_2022 = createSnapshotWithoutPositions(for: date_31_07_2022, in: context)
        snapshots.append(snapshot_31_07_2022)
        let snapshot_31_08_2022 = createSnapshotWithoutPositions(for: date_31_08_2022, in: context)
        snapshots.append(snapshot_31_08_2022)
        let snapshot_28_09_2022 = createSnapshotWithoutPositions(for: date_28_09_2022, in: context)
        snapshots.append(snapshot_28_09_2022)
        let snapshot_31_10_2022 = createSnapshotWithoutPositions(for: date_31_10_2022, in: context)
        snapshots.append(snapshot_31_10_2022)
        let snapshot_01_12_2022 = createSnapshotWithoutPositions(for: date_01_12_2022, in: context)
        snapshots.append(snapshot_01_12_2022)
        let snapshot_31_12_2022 = createSnapshotWithoutPositions(for: date_31_12_2022, in: context)
        snapshots.append(snapshot_31_12_2022)
        let snapshot_31_01_2023 = createSnapshotWithoutPositions(for: date_31_01_2023, in: context)
        snapshots.append(snapshot_31_01_2023)
        let snapshot_28_02_2023 = createSnapshotWithoutPositions(for: date_28_02_2023, in: context)
        snapshots.append(snapshot_28_02_2023)
        let snapshot_31_03_2023 = createSnapshotWithoutPositions(for: date_31_03_2023, in: context)
        snapshots.append(snapshot_31_03_2023)
        let snapshot_02_05_2023 = createSnapshotWithoutPositions(for: date_02_05_2023, in: context)
        snapshots.append(snapshot_02_05_2023)
        let snapshot_31_05_2023 = createSnapshotWithoutPositions(for: date_31_05_2023, in: context)
        snapshots.append(snapshot_31_05_2023)
        
        return snapshots
    }
    
    
    /* MARK: DistributionChartViewModel */
    
    func createAndPersistTestObjects_distributionCategories_1(using context: NSManagedObjectContext) -> ([DonutChartCategory],[DonutChartCategory]) {
        let assetPosition1 = createAssetPosition(name: "Sparkasse Konto", poolName: "Bank", value: 20.0, context: context)
        let assetPosition2 = createAssetPosition(name: "FNZ Depot", poolName: "Wertpapiere", value: 30.0, context: context)
        let assetPosition3 = createAssetPosition(name: "Geldbeutel", poolName: "Bargeld", value: 50.0, context: context)
        
        let liabilityPosition1 = createLiabilityPosition(name: "Auto-Kredit", poolName: "Privat", value: 40, context: context)
        let liabilityPosition2 = createLiabilityPosition(name: "Studien-Kredit", poolName: "Staat", value: 60, context: context)
        
        let _ = createSnapshot(with: [assetPosition1, assetPosition2, assetPosition3],
                               and: [liabilityPosition1, liabilityPosition2],
                               for: .now,
                               in: context)
        
        let assetCategory1 = DonutChartCategory(pools: [Pool(value: 20.0, name: "Bank", percentage: 20.0)])
        let assetCategory2 = DonutChartCategory(pools: [Pool(value: 30.0, name: "Wertpapiere", percentage: 30.0)])
        let assetCategory3 = DonutChartCategory(pools: [Pool(value: 50.0, name: "Bargeld", percentage: 50.0)])
        
        let liabilityCategory1 = DonutChartCategory(pools: [Pool(value: 40.0, name: "Privat", percentage: 40.0)])
        let liabilityCategory2 = DonutChartCategory(pools: [Pool(value: 60.0, name: "Staat", percentage: 60.0)])
        
        return ([assetCategory1, assetCategory2, assetCategory3], [liabilityCategory1,liabilityCategory2])
    }
    
    func createAndPersistTestObjects_distributionCategories_2(using context: NSManagedObjectContext) -> ([DonutChartCategory],[DonutChartCategory]) {
        let assetPosition1 = createAssetPosition(name: "Sparkasse Girokonto", poolName: "Bank", value: 10.0, context: context)
        let assetPosition2 = createAssetPosition(name: "Sparkasse Tagesgeldkonto", poolName: "Bank", value: 25.0, context: context)
        let assetPosition3 = createAssetPosition(name: "Commerzbank Konto", poolName: "Bank", value: 5.0, context: context)
        let assetPosition4 = createAssetPosition(name: "FNZ Depot", poolName: "Wertpapiere", value: 1.0, context: context)
        let assetPosition5 = createAssetPosition(name: "Sparkasse Depot", poolName: "Wertpapiere", value: 2.0, context: context)
        let assetPosition6 = createAssetPosition(name: "Geldbeutel", poolName: "Bargeld", value: 57.0, context: context)
        
        let liabilityPosition1 = createLiabilityPosition(name: "Auto-Kredit", poolName: "Privat", value: 40, context: context)
        let liabilityPosition2 = createLiabilityPosition(name: "Miete-Kredit", poolName: "Privat", value: 40, context: context)
        let liabilityPosition3 = createLiabilityPosition(name: "Plattenspieler-Kredit", poolName: "Privat", value: 17, context: context)
        let liabilityPosition4 = createLiabilityPosition(name: "Studien-Kredit", poolName: "Staat", value: 3.0, context: context)
        
        let _ = createSnapshot(with: [assetPosition1, assetPosition2, assetPosition3, assetPosition4, assetPosition5, assetPosition6],
                               and: [liabilityPosition1, liabilityPosition2, liabilityPosition3, liabilityPosition4],
                               for: .now,
                               in: context)
        
        let assetCategory1 = DonutChartCategory(pools: [Pool(value: 40.0, name: "Bank", percentage: 40.0)])
        let assetCategory2 = DonutChartCategory(pools: [Pool(value: 3.0, name: "Wertpapiere", percentage: 3.0)])
        let assetCategory3 = DonutChartCategory(pools: [Pool(value: 57.0, name: "Bargeld", percentage: 57.0)])
        
        let liabilityCategory1 = DonutChartCategory(pools: [Pool(value: 97.0, name: "Privat", percentage: 97.0)])
        let liabilityCategory2 = DonutChartCategory(pools: [Pool(value: 3.0, name: "Staat", percentage: 3.0)])
        
        return ([assetCategory1, assetCategory2, assetCategory3], [liabilityCategory1,liabilityCategory2])
    }
    
    func createAndPersistTestObjects_distributionCategories_3(using context: NSManagedObjectContext) -> ([DonutChartCategory],[DonutChartCategory]) {
        let assetPosition1 = createAssetPosition(name: "Sparkasse Girokonto", poolName: "Bank", value: 10.0, context: context)
        let assetPosition2 = createAssetPosition(name: "Sparkasse Tagesgeldkonto", poolName: "Bank", value: 25.0, context: context)
        let assetPosition3 = createAssetPosition(name: "Commerzbank Konto", poolName: "Bank", value: 35.0, context: context)
        let assetPosition4 = createAssetPosition(name: "FNZ Depot", poolName: "Wertpapiere", value: 16.0, context: context)
        let assetPosition5 = createAssetPosition(name: "Sparkasse Depot", poolName: "Wertpapiere", value: 12.0, context: context)
        let assetPosition6 = createAssetPosition(name: "Geldbeutel", poolName: "Bargeld", value: 1.0, context: context)
        let assetPosition7 = createAssetPosition(name: "Sparschwein", poolName: "Bargeld", value: 1.0, context: context)
        
        let liabilityPosition1 = createLiabilityPosition(name: "Auto-Kredit", poolName: "Privat", value: 40, context: context)
        let liabilityPosition2 = createLiabilityPosition(name: "Miete-Kredit", poolName: "Privat", value: 40, context: context)
        let liabilityPosition3 = createLiabilityPosition(name: "Plattenspieler-Kredit", poolName: "Privat", value: 18, context: context)
        let liabilityPosition4 = createLiabilityPosition(name: "Studien-Kredit", poolName: "Staat", value: 2.0, context: context)
        
        let _ = createSnapshot(with: [assetPosition1, assetPosition2, assetPosition3, assetPosition4, assetPosition5, assetPosition6, assetPosition7],
                               and: [liabilityPosition1, liabilityPosition2, liabilityPosition3, liabilityPosition4],
                               for: .now,
                               in: context)
        
        let assetCategory1 = DonutChartCategory(pools: [Pool(value: 70.0, name: "Bank", percentage: 70.0)])
        let assetCategory2 = DonutChartCategory(pools: [
            Pool(value: 28.0, name: "Wertpapiere", percentage: 28.0),
            Pool(value: 2.0, name: "Bargeld", percentage: 2.0)
        ])
        
        let liabilityCategory1 = DonutChartCategory(pools: [
            Pool(value: 98.0, name: "Privat", percentage: 98.0),
            Pool(value: 2.0, name: "Staat", percentage: 2.0)
        ])
        
        return ([assetCategory1, assetCategory2], [liabilityCategory1])
    }
    
    func createAndPersistTestObjects_distributionCategories_4(using context: NSManagedObjectContext) -> ([DonutChartCategory],[DonutChartCategory]) {
        let assetPosition1 = createAssetPosition(name: "Sparkasse Girokonto", poolName: "Bank Inland", value: 10.0, context: context)
        let assetPosition2 = createAssetPosition(name: "Sparkasse Tagesgeldkonto", poolName: "Bank Inland", value: 25.0, context: context)
        let assetPosition3 = createAssetPosition(name: "Commerzbank Konto", poolName: "Bank Inland", value: 35.0, context: context)
        let assetPosition4 = createAssetPosition(name: "FNZ Depot", poolName: "Wertpapiere", value: 16.0, context: context)
        let assetPosition5 = createAssetPosition(name: "Sparkasse Depot", poolName: "Wertpapiere", value: 12.0, context: context)
        let assetPosition6 = createAssetPosition(name: "Geldbeutel", poolName: "Bargeld", value: 1.0, context: context)
        let assetPosition7 = createAssetPosition(name: "Sparschwein", poolName: "Bargeld", value: 0.5, context: context)
        let assetPosition8 = createAssetPosition(name: "Bank of America Konto", poolName: "Bank Ausland", value: 0.5, context: context)
        
        let liabilityPosition1 = createLiabilityPosition(name: "Auto-Kredit", poolName: "Familie", value: 40, context: context)
        let liabilityPosition2 = createLiabilityPosition(name: "Miete-Kredit", poolName: "Familie", value: 40, context: context)
        let liabilityPosition3 = createLiabilityPosition(name: "Plattenspieler-Kredit", poolName: "Familie", value: 18, context: context)
        let liabilityPosition4 = createLiabilityPosition(name: "Studien-Kredit", poolName: "Staat", value: 1.0, context: context)
        let liabilityPosition5 = createLiabilityPosition(name: "Feiern Lenni", poolName: "Freunde", value: 1.0, context: context)
        
        let _ = createSnapshot(with: [assetPosition1, assetPosition2, assetPosition3, assetPosition4, assetPosition5, assetPosition6, assetPosition7, assetPosition8],
                               and: [liabilityPosition1, liabilityPosition2, liabilityPosition3, liabilityPosition4, liabilityPosition5],
                               for: .now,
                               in: context)
        
        let assetCategory1 = DonutChartCategory(pools: [Pool(value: 70.0, name: "Bank Inland", percentage: 70.0)])
        let assetCategory2 = DonutChartCategory(pools: [
            Pool(value: 28.0, name: "Wertpapiere", percentage: 28.0),
            Pool(value: 1.5, name: "Bargeld", percentage: 1.5),
            Pool(value: 0.5, name: "Bank Ausland", percentage: 0.5)
        ])
        
        let liabilityCategory1 = DonutChartCategory(pools: [
            Pool(value: 98.0, name: "Familie", percentage: 98.0),
            Pool(value: 1.0, name: "Staat", percentage: 1.0),
            Pool(value: 1.0, name: "Freunde", percentage: 1.0)
        ])
        
        return ([assetCategory1, assetCategory2], [liabilityCategory1])
    }
    
    func createAndPersistTestObjects_distributionCategories_5(using context: NSManagedObjectContext) -> ([DonutChartCategory],[DonutChartCategory]) {
        let _ = createSnapshotWithoutPositions(for: .now, in: context)
        return ([], [])
    }
    
    
    func createAndPersistTestObjects_computeTotalValue_1(using context: NSManagedObjectContext) -> (Snapshot, Double, Double) {
        let assetPosition1 = createAssetPosition(name: "Sparkasse Konto", poolName: "Bank", value: 1_000_000.0, context: context)
        let liabilityPosition1 = createLiabilityPosition(name: "Auto-Kredit", poolName: "Privat", value: 1_000_000_000.0, context: context)
        
        let snapshot = createSnapshot(with: [assetPosition1],
                               and: [liabilityPosition1],
                               for: .now,
                               in: context)
        
        return (snapshot, 1_000_000.0, 1_000_000_000.0)
    }
    
    func createAndPersistTestObjects_computeTotalValue_2(using context: NSManagedObjectContext) -> (Snapshot, Double, Double) {
        let assetPosition1 = createAssetPosition(name: "Sparkasse Konto", poolName: "Bank", value: 1_000_000.0, context: context)
        let assetPosition2 = createAssetPosition(name: "Commerzbank Konto", poolName: "Bank", value: 10.0, context: context)
        let assetPosition3 = createAssetPosition(name: "Reifeisenbank Konto", poolName: "Bank", value: 30_000.0, context: context)
        let liabilityPosition1 = createLiabilityPosition(name: "Auto", poolName: "Privat", value: 1_000_000_000.0, context: context)
        let liabilityPosition2 = createLiabilityPosition(name: "Wohnung 1", poolName: "Privat", value: 1_000_000.0, context: context)
        let liabilityPosition3 = createLiabilityPosition(name: "Wohnung 2", poolName: "Privat", value: 55.0, context: context)
        let liabilityPosition4 = createLiabilityPosition(name: "Motorrad", poolName: "Privat", value: 340_000.0, context: context)
        let liabilityPosition5 = createLiabilityPosition(name: "Vinylsammlung", poolName: "Privat", value: 1.0, context: context)
        
        let snapshot = createSnapshot(with: [assetPosition1, assetPosition2, assetPosition3],
                               and: [liabilityPosition1, liabilityPosition2, liabilityPosition3, liabilityPosition4, liabilityPosition5],
                               for: .now,
                               in: context)
        
        return (snapshot, 1_030_010.0, 1_001_340_056.0)
    }
    
    func createAndPersistTestObjects_computeTotalValue_3(using context: NSManagedObjectContext) -> (Snapshot, Double, Double) {
        let assetPosition1 = createAssetPosition(name: "Sparkasse Konto", poolName: "Bank Inland", value: 76.33, context: context)
        let assetPosition2 = createAssetPosition(name: "Commerzbank Konto", poolName: "Bank Inland", value: 2_672_654.80, context: context)
        let assetPosition3 = createAssetPosition(name: "Reifeisenbank Konto", poolName: "Bank Inland", value: 756_085.95, context: context)
        let assetPosition4 = createAssetPosition(name: "Bank of America", poolName: "Bank Ausland", value: 650.01, context: context)
        let assetPosition5 = createAssetPosition(name: "Blackrock", poolName: "Bank Ausland", value: 302_070.29, context: context)
        let assetPosition6 = createAssetPosition(name: "Geldbeutel", poolName: "Bargeld", value: 30.50, context: context)
        let assetPosition7 = createAssetPosition(name: "Sparschwein", poolName: "Bargeld", value: 301.22, context: context)
        let assetPosition8 = createAssetPosition(name: "Morgan Stanley", poolName: "Wertpapiere", value: 56_114.76, context: context)
        let liabilityPosition1 = createLiabilityPosition(name: "Auto", poolName: "Privat", value: 22.2, context: context)
        let liabilityPosition2 = createLiabilityPosition(name: "Wohnung 1", poolName: "Privat", value: 5_000.00, context: context)
        let liabilityPosition3 = createLiabilityPosition(name: "Vinylsammlung", poolName: "Privat", value: 300.0, context: context)
        let liabilityPosition4 = createLiabilityPosition(name: "Motorrad", poolName: "Privat", value: 4_000, context: context)
        let liabilityPosition5 = createLiabilityPosition(name: "Studium 1", poolName: "Bank", value: 2_000.0, context: context)
        let liabilityPosition6 = createLiabilityPosition(name: "Studium 2", poolName: "Bank", value: 6_000.0, context: context)
        let liabilityPosition7 = createLiabilityPosition(name: "Wohnung 2", poolName: "Bank", value: 10_000.0, context: context)
        let liabilityPosition8 = createLiabilityPosition(name: "Herd", poolName: "Online", value: 600.0, context: context)
        let liabilityPosition9 = createLiabilityPosition(name: "Spülmaschine", poolName: "Online", value: 551.0, context: context)
        
        let assetPositions = [
            assetPosition1,
            assetPosition2,
            assetPosition3,
            assetPosition4,
            assetPosition5,
            assetPosition6,
            assetPosition7,
            assetPosition8
        ]
        
        let liabilityPositions = [
            liabilityPosition1,
            liabilityPosition2,
            liabilityPosition3,
            liabilityPosition4,
            liabilityPosition5,
            liabilityPosition6,
            liabilityPosition7,
            liabilityPosition8,
            liabilityPosition9
        ]
        
        let snapshot = createSnapshot(with: assetPositions,
                               and: liabilityPositions,
                               for: .now,
                               in: context)
        
        return (snapshot, 3_787_983.86, 28_473.20)
    }
    
    func createAndPersistTestObjects_computeTotalValue_4(using context: NSManagedObjectContext) -> (Snapshot, Double, Double) {
        let assetPosition1 = createAssetPosition(name: "Sparkasse Konto", poolName: "Bank Inland", value: 76.33, context: context)
        let assetPosition2 = createAssetPosition(name: "Commerzbank Konto", poolName: "Bank Inland", value: 2_672_654.80, context: context)
        let assetPosition3 = createAssetPosition(name: "Reifeisenbank Konto", poolName: "Bank Inland", value: 756_085.95, context: context)
        let assetPosition4 = createAssetPosition(name: "Bank of America", poolName: "Bank Ausland", value: 650.01, context: context)
        let assetPosition5 = createAssetPosition(name: "Blackrock", poolName: "Bank Ausland", value: 302_070.29, context: context)
        let assetPosition6 = createAssetPosition(name: "Geldbeutel", poolName: "Bargeld", value: 30.50, context: context)
        let assetPosition7 = createAssetPosition(name: "Sparschwein", poolName: "Bargeld", value: 301.22, context: context)
        let assetPosition8 = createAssetPosition(name: "Morgan Stanley", poolName: "Wertpapiere", value: 0, context: context)
        let liabilityPosition1 = createLiabilityPosition(name: "Auto", poolName: "Privat", value: 22.2, context: context)
        let liabilityPosition2 = createLiabilityPosition(name: "Wohnung 1", poolName: "Privat", value: 5_000.00, context: context)
        let liabilityPosition3 = createLiabilityPosition(name: "Vinylsammlung", poolName: "Privat", value: 300.0, context: context)
        let liabilityPosition4 = createLiabilityPosition(name: "Motorrad", poolName: "Privat", value: 4_000, context: context)
        let liabilityPosition5 = createLiabilityPosition(name: "Studium 1", poolName: "Bank", value: 2_000.0, context: context)
        let liabilityPosition6 = createLiabilityPosition(name: "Studium 2", poolName: "Bank", value: 6_000.0, context: context)
        let liabilityPosition7 = createLiabilityPosition(name: "Wohnung 2", poolName: "Bank", value: 10_000.0, context: context)
        let liabilityPosition8 = createLiabilityPosition(name: "Herd", poolName: "Online", value: 0.0, context: context)
        let liabilityPosition9 = createLiabilityPosition(name: "Spülmaschine", poolName: "Online", value: 0.0, context: context)
        
        let assetPositions = [
            assetPosition1,
            assetPosition2,
            assetPosition3,
            assetPosition4,
            assetPosition5,
            assetPosition6,
            assetPosition7,
            assetPosition8
        ]
        
        let liabilityPositions = [
            liabilityPosition1,
            liabilityPosition2,
            liabilityPosition3,
            liabilityPosition4,
            liabilityPosition5,
            liabilityPosition6,
            liabilityPosition7,
            liabilityPosition8,
            liabilityPosition9
        ]
        
        let snapshot = createSnapshot(with: assetPositions,
                               and: liabilityPositions,
                               for: .now,
                               in: context)
        
        return (snapshot, 3_731_869.1, 27_322.2)
    }
    
    func createAndPersistTestObjects_computeTotalValue_5(using context: NSManagedObjectContext) -> (Snapshot, Double, Double) {
        let snapshot = createSnapshotWithoutPositions(for: .now, in: context)
        return (snapshot, 0.0, 0.0)
    }
    
    
    func createAndPersistTestObjects_setSelectedCategoryForNewCumulativeValue_1(using context: NSManagedObjectContext) -> (DonutChartCategory, DonutChartCategory) {
        let assetPosition1 = createAssetPosition(name: "Sparkasse Konto", poolName: "Bank", value: 20.0, context: context)
        let assetPosition2 = createAssetPosition(name: "FNZ Depot", poolName: "Wertpapiere", value: 30.0, context: context)
        let assetPosition3 = createAssetPosition(name: "Geldbeutel", poolName: "Bargeld", value: 50.0, context: context)
        
        let liabilityPosition1 = createLiabilityPosition(name: "Auto-Kredit", poolName: "Privat", value: 40, context: context)
        let liabilityPosition2 = createLiabilityPosition(name: "Studien-Kredit", poolName: "Staat", value: 60, context: context)
        
        let _ = createSnapshot(with: [assetPosition1, assetPosition2, assetPosition3],
                               and: [liabilityPosition1, liabilityPosition2],
                               for: .now,
                               in: context)
        
        return (
            .init(pools: [.init(value: 30.0, name: "Wertpapiere", percentage: 30.0)]),
            .init(pools:[.init(value: 40.0, name: "Privat", percentage: 40.0)])
        )
    }
    
    func createAndPersistTestObjects_setSelectedCategoryForNewCumulativeValue_2(using context: NSManagedObjectContext) -> (DonutChartCategory, DonutChartCategory) {
        let assetPosition1 = createAssetPosition(name: "Sparkasse Konto", poolName: "Bank", value: 20.0, context: context)
        let assetPosition2 = createAssetPosition(name: "FNZ Depot", poolName: "Wertpapiere", value: 30.0, context: context)
        let assetPosition3 = createAssetPosition(name: "Geldbeutel", poolName: "Bargeld", value: 50.0, context: context)
        
        let liabilityPosition1 = createLiabilityPosition(name: "Auto-Kredit", poolName: "Privat", value: 40, context: context)
        let liabilityPosition2 = createLiabilityPosition(name: "Studien-Kredit", poolName: "Staat", value: 60, context: context)
        
        let _ = createSnapshot(with: [assetPosition1, assetPosition2, assetPosition3],
                               and: [liabilityPosition1, liabilityPosition2],
                               for: .now,
                               in: context)
        
        return (
            .init(pools: [.init(value: 20.0, name: "Bank", percentage: 20.0)]),
            .init(pools:[.init(value: 40.0, name: "Privat", percentage: 40.0)])
        )
    }
}
