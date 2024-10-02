@testable import EquityLab
import CoreData

struct DashboardViewModelTestDataProvider {
    func createAndPersistTestObjects_assetValue_1(using context: NSManagedObjectContext) -> Snapshot {
        let assetPositions: [AssetPosition] = []
        let liabilityPositions: [LiabilityPosition] = []
        let date: Date = .now
        return DataFactory.createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_assetValue_2(using context: NSManagedObjectContext) -> Snapshot {
        let assetPosition1 = DataFactory.createAssetPosition(name: "Purse", poolName: "Cash", value: 0.0, context: context)
        let assetPosition2 = DataFactory.createAssetPosition(name: "Konto Sparkasse", poolName: "Bank", value: 0.0, context: context)
        let assetPosition3 = DataFactory.createAssetPosition(name: "Depot FNZ", poolName: "Securities", value: 0.0, context: context)
        
        let assetPositions: [AssetPosition] = [assetPosition1, assetPosition2, assetPosition3]
        let liabilityPositions: [LiabilityPosition] = []
        let date: Date = .now
        return DataFactory.createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_assetValue_3(using context: NSManagedObjectContext) -> Snapshot {
        let assetPosition1 = DataFactory.createAssetPosition(name: "Purse", poolName: "Cash", value: 5.0, context: context)
        let assetPosition2 = DataFactory.createAssetPosition(name: "Piggy Bank", poolName: "Cash", value: 11.4, context: context)
        let assetPosition3 = DataFactory.createAssetPosition(name: "Konto Sparkasse", poolName: "Bank", value: 89.76, context: context)
        let assetPosition4 = DataFactory.createAssetPosition(name: "Konto Commerzbank", poolName: "Bank", value: 122.33, context: context)
        let assetPosition5 = DataFactory.createAssetPosition(name: "Depot FNZ", poolName: "Securities", value: 50.85, context: context)
        
        let assetPositions: [AssetPosition] = [assetPosition1, assetPosition2, assetPosition3, assetPosition4, assetPosition5]
        let liabilityPositions: [LiabilityPosition] = []
        let date: Date = .now
        return DataFactory.createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_assetValue_4(using context: NSManagedObjectContext) -> Snapshot {
        let assetPosition1 = DataFactory.createAssetPosition(name: "Purse", poolName: "Cash", value: 0.0, context: context)
        let assetPosition2 = DataFactory.createAssetPosition(name: "Konto Sparkasse", poolName: "Bank", value: 10.0, context: context)
        
        let assetPositions: [AssetPosition] = [assetPosition1, assetPosition2]
        let liabilityPositions: [LiabilityPosition] = []
        let date: Date = .now
        return DataFactory.createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_assetValue_5(using context: NSManagedObjectContext) -> Snapshot {
        let assetPosition1 = DataFactory.createAssetPosition(name: "Purse", poolName: "Cash", value: 0.0, context: context)
        
        let assetPositions: [AssetPosition] = [assetPosition1]
        let liabilityPositions: [LiabilityPosition] = []
        let date: Date = .now
        return DataFactory.createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_assetValue_6(using context: NSManagedObjectContext) -> Snapshot {
        let assetPosition1 = DataFactory.createAssetPosition(name: "Purse", poolName: "Cash", value: 17.01, context: context)
        
        let assetPositions: [AssetPosition] = [assetPosition1]
        let liabilityPositions: [LiabilityPosition] = []
        let date: Date = .now
        return DataFactory.createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    
    
    func createAndPersistTestObjects_liabilityValue_1(using context: NSManagedObjectContext) -> Snapshot {
        let assetPositions: [AssetPosition] = []
        let liabilityPositions: [LiabilityPosition] = []
        let date: Date = .now
        return DataFactory.createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_liabilityValue_2(using context: NSManagedObjectContext) -> Snapshot {
        let liabilityPosition1 = DataFactory.createLiabilityPosition(name: "Car", poolName: "Private", value: 0.0, context: context)
        let liabilityPosition2 = DataFactory.createLiabilityPosition(name: "Office Building", poolName: "Business", value: 0.0, context: context)
        let liabilityPosition3 = DataFactory.createLiabilityPosition(name: "Server", poolName: "Business", value: 0.0, context: context)
        
        let assetPositions: [AssetPosition] = []
        let liabilityPositions: [LiabilityPosition] = [liabilityPosition1, liabilityPosition2, liabilityPosition3]
        let date: Date = .now
        return DataFactory.createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_liabilityValue_3(using context: NSManagedObjectContext) -> Snapshot {
        let liabilityPosition1 = DataFactory.createLiabilityPosition(name: "Car", poolName: "Private", value: 5.0, context: context)
        let liabilityPosition2 = DataFactory.createLiabilityPosition(name: "DJ Equipment", poolName: "Private", value: 11.4, context: context)
        let liabilityPosition3 = DataFactory.createLiabilityPosition(name: "Office Building", poolName: "Business", value: 89.76, context: context)
        let liabilityPosition4 = DataFactory.createLiabilityPosition(name: "Server", poolName: "Business", value: 122.33, context: context)
        let liabilityPosition5 = DataFactory.createLiabilityPosition(name: "Production", poolName: "Business", value: 50.85, context: context)
        
        let assetPositions: [AssetPosition] = []
        let liabilityPositions: [LiabilityPosition] = [liabilityPosition1, liabilityPosition2, liabilityPosition3, liabilityPosition4, liabilityPosition5]
        let date: Date = .now
        return DataFactory.createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_liabilityValue_4(using context: NSManagedObjectContext) -> Snapshot {
        let liabilityPosition1 = DataFactory.createLiabilityPosition(name: "DJ Equipment", poolName: "Private", value: 0.0, context: context)
        let liabilityPosition2 = DataFactory.createLiabilityPosition(name: "Office Building", poolName: "Business", value: 10.0, context: context)
        
        let assetPositions: [AssetPosition] = []
        let liabilityPositions: [LiabilityPosition] = [liabilityPosition1, liabilityPosition2]
        let date: Date = .now
        return DataFactory.createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_liabilityValue_5(using context: NSManagedObjectContext) -> Snapshot {
        let liabilityPosition1 = DataFactory.createLiabilityPosition(name: "DJ Equipment", poolName: "Private", value: 0.0, context: context)
        
        let assetPositions: [AssetPosition] = []
        let liabilityPositions: [LiabilityPosition] = [liabilityPosition1]
        let date: Date = .now
        return DataFactory.createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_liabilityValue_6(using context: NSManagedObjectContext) -> Snapshot {
        let liabilityPosition1 = DataFactory.createLiabilityPosition(name: "Office Building", poolName: "Business", value: 17.01, context: context)
        
        let assetPositions: [AssetPosition] = []
        let liabilityPositions: [LiabilityPosition] = [liabilityPosition1]
        let date: Date = .now
        return DataFactory.createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    
    
    func createAndPersistTestObjects_equityValue_1(using context: NSManagedObjectContext) -> Snapshot {
        let assetPosition1 = DataFactory.createAssetPosition(name: "Purse", poolName: "Cash", value: 4.0, context: context)
        let assetPosition2 = DataFactory.createAssetPosition(name: "Piggy Bank", poolName: "Cash", value: 13.77, context: context)
        
        let assetPositions: [AssetPosition] = [assetPosition1, assetPosition2]
        let liabilityPositions: [LiabilityPosition] = []
        let date: Date = .now
        return DataFactory.createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_equityValue_2(using context: NSManagedObjectContext) -> Snapshot {
        let liabilityPosition1 = DataFactory.createLiabilityPosition(name: "DJ Equipment", poolName: "Private", value: 7.04, context: context)
        let liabilityPosition2 = DataFactory.createLiabilityPosition(name: "Office Building", poolName: "Business", value: 13.39, context: context)
        
        let assetPositions: [AssetPosition] = []
        let liabilityPositions: [LiabilityPosition] = [liabilityPosition1, liabilityPosition2]
        let date: Date = .now
        return DataFactory.createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_equityValue_3(using context: NSManagedObjectContext) -> Snapshot {
        let assetPosition1 = DataFactory.createAssetPosition(name: "Purse", poolName: "Cash", value: 0.0, context: context)
        let assetPosition2 = DataFactory.createAssetPosition(name: "Piggy Bank", poolName: "Cash", value: 11.4, context: context)
        let assetPosition3 = DataFactory.createAssetPosition(name: "Konto Sparkasse", poolName: "Bank", value: 89.76, context: context)
        let assetPosition4 = DataFactory.createAssetPosition(name: "Konto Commerzbank", poolName: "Bank", value: 122.33, context: context)
        let assetPosition5 = DataFactory.createAssetPosition(name: "Depot FNZ", poolName: "Securities", value: 50.85, context: context)
        
        let liabilityPosition1 = DataFactory.createLiabilityPosition(name: "DJ Equipment", poolName: "Private", value: 7.04, context: context)
        let liabilityPosition2 = DataFactory.createLiabilityPosition(name: "Office Building", poolName: "Business", value: 13.39, context: context)
        
        let assetPositions: [AssetPosition] = [assetPosition1, assetPosition2, assetPosition3, assetPosition4, assetPosition5]
        let liabilityPositions: [LiabilityPosition] = [liabilityPosition1, liabilityPosition2]
        let date: Date = .now
        return DataFactory.createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_equityValue_4(using context: NSManagedObjectContext) -> Snapshot {
        let assetPosition1 = DataFactory.createAssetPosition(name: "Wallet", poolName: "Cash", value: 5.75, context: context)
        let assetPosition2 = DataFactory.createAssetPosition(name: "Piggy Bank", poolName: "Cash", value: 15.3, context: context)
        let assetPosition3 = DataFactory.createAssetPosition(name: "Checking Account", poolName: "Bank", value: 120.5, context: context)
        let assetPosition4 = DataFactory.createAssetPosition(name: "Savings Account", poolName: "Bank", value: 240.75, context: context)
        let assetPosition5 = DataFactory.createAssetPosition(name: "Brokerage Account", poolName: "Securities", value: 300.45, context: context)
        let assetPosition6 = DataFactory.createAssetPosition(name: "401k", poolName: "Securities", value: 450.0, context: context)
        let assetPosition7 = DataFactory.createAssetPosition(name: "Mutual Fund", poolName: "Securities", value: 120.25, context: context)
        let assetPosition8 = DataFactory.createAssetPosition(name: "Emergency Fund", poolName: "Cash", value: 50.0, context: context)
        let assetPosition9 = DataFactory.createAssetPosition(name: "Vacation Fund", poolName: "Cash", value: 100.88, context: context)
        let assetPosition10 = DataFactory.createAssetPosition(name: "Real Estate Investment", poolName: "Bank", value: 350.0, context: context)
        
        let liabilityPosition1 = DataFactory.createLiabilityPosition(name: "Credit Card Debt", poolName: "Private", value: 120.99, context: context)
        let liabilityPosition2 = DataFactory.createLiabilityPosition(name: "Mortgage", poolName: "Business", value: 200.0, context: context)
        let liabilityPosition3 = DataFactory.createLiabilityPosition(name: "Car Loan", poolName: "Private", value: 150.5, context: context)
        let liabilityPosition4 = DataFactory.createLiabilityPosition(name: "Student Loan", poolName: "Private", value: 75.25, context: context)
        let liabilityPosition5 = DataFactory.createLiabilityPosition(name: "Office Lease", poolName: "Business", value: 85.0, context: context)
        let liabilityPosition6 = DataFactory.createLiabilityPosition(name: "Business Loan", poolName: "Business", value: 180.0, context: context)
        let liabilityPosition7 = DataFactory.createLiabilityPosition(name: "Equipment Lease", poolName: "Business", value: 65.35, context: context)
        
        let assetPositions: [AssetPosition] = [assetPosition1, assetPosition2, assetPosition3, assetPosition4, assetPosition5, assetPosition6, assetPosition7, assetPosition8, assetPosition9, assetPosition10]
        let liabilityPositions: [LiabilityPosition] = [liabilityPosition1, liabilityPosition2, liabilityPosition3, liabilityPosition4, liabilityPosition5, liabilityPosition6, liabilityPosition7]
        let date: Date = .now
        return DataFactory.createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    
    
    func createAndPersistTestObjects_computeValueByPool_1(using context: NSManagedObjectContext) -> Snapshot {
        let assetPosition1 = DataFactory.createAssetPosition(name: "Wallet", poolName: "Cash", value: 0.0, context: context)
        let assetPosition2 = DataFactory.createAssetPosition(name: "Piggy Bank", poolName: "Cash", value: 15.3, context: context)
        let assetPosition3 = DataFactory.createAssetPosition(name: "Emergency Fund", poolName: "Cash", value: 50.0, context: context)
        let assetPosition4 = DataFactory.createAssetPosition(name: "Vacation Fund", poolName: "Cash", value: 100.88, context: context)
        let assetPosition5 = DataFactory.createAssetPosition(name: "Checking Account", poolName: "Bank", value: 120.5, context: context)
        let assetPosition6 = DataFactory.createAssetPosition(name: "Savings Account", poolName: "Bank", value: 240.75, context: context)
        let assetPosition7 = DataFactory.createAssetPosition(name: "Real Estate Investment", poolName: "Bank", value: 350.0, context: context)
        let assetPosition8 = DataFactory.createAssetPosition(name: "Brokerage Account", poolName: "Securities", value: 300.45, context: context)
        let assetPosition9 = DataFactory.createAssetPosition(name: "401k", poolName: "Securities", value: 450.0, context: context)
        let assetPosition10 = DataFactory.createAssetPosition(name: "Mutual Fund", poolName: "Securities", value: 120.25, context: context)
        
        let liabilityPosition1 = DataFactory.createLiabilityPosition(name: "Credit Card Debt", poolName: "Private", value: 0.0, context: context)
        let liabilityPosition3 = DataFactory.createLiabilityPosition(name: "Car Loan", poolName: "Private", value: 150.5, context: context)
        let liabilityPosition4 = DataFactory.createLiabilityPosition(name: "Student Loan", poolName: "Private", value: 75.25, context: context)
        let liabilityPosition2 = DataFactory.createLiabilityPosition(name: "Mortgage", poolName: "Business", value: 200.0, context: context)
        let liabilityPosition5 = DataFactory.createLiabilityPosition(name: "Office Lease", poolName: "Business", value: 85.0, context: context)
        let liabilityPosition6 = DataFactory.createLiabilityPosition(name: "Business Loan", poolName: "Business", value: 180.0, context: context)
        let liabilityPosition7 = DataFactory.createLiabilityPosition(name: "Equipment Lease", poolName: "Business", value: 65.35, context: context)
        
        let assetPositions: [AssetPosition] = [assetPosition1, assetPosition2, assetPosition3, assetPosition4, assetPosition5, assetPosition6, assetPosition7, assetPosition8, assetPosition9, assetPosition10]
        let liabilityPositions: [LiabilityPosition] = [liabilityPosition1, liabilityPosition2, liabilityPosition3, liabilityPosition4, liabilityPosition5, liabilityPosition6, liabilityPosition7]
        let date: Date = .now
        return DataFactory.createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_computeValueByPool_2(using context: NSManagedObjectContext) -> Snapshot {
        let assetPositions: [AssetPosition] = []
        let liabilityPositions: [LiabilityPosition] = []
        let date: Date = .now
        return DataFactory.createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_computeValueByPool_3(using context: NSManagedObjectContext) -> Snapshot {
        let assetPosition1 = DataFactory.createAssetPosition(name: "Wallet", poolName: "Cash", value: 5.75, context: context)
        let liabilityPosition1 = DataFactory.createLiabilityPosition(name: "Credit Card Debt", poolName: "Private", value: 120.99, context: context)
        
        let assetPositions: [AssetPosition] = [assetPosition1]
        let liabilityPositions: [LiabilityPosition] = [liabilityPosition1]
        let date: Date = .now
        return DataFactory.createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_computeValueByPool_4(using context: NSManagedObjectContext) -> Snapshot {
        let assetPosition1 = DataFactory.createAssetPosition(name: "Wallet", poolName: "Cash", value: 0.0, context: context)
        let liabilityPosition1 = DataFactory.createLiabilityPosition(name: "Credit Card Debt", poolName: "Private", value: 0.0, context: context)
        
        let assetPositions: [AssetPosition] = [assetPosition1]
        let liabilityPositions: [LiabilityPosition] = [liabilityPosition1]
        let date: Date = .now
        return DataFactory.createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_computeValueByPool_5(using context: NSManagedObjectContext) -> Snapshot {
        let assetPosition1 = DataFactory.createAssetPosition(name: "Wallet", poolName: "Cash", value: 0.0, context: context)
        let assetPosition2 = DataFactory.createAssetPosition(name: "Piggy Bank", poolName: "Cash", value: 0.0, context: context)
        let liabilityPosition1 = DataFactory.createLiabilityPosition(name: "Credit Card Debt", poolName: "Private", value: 0.0, context: context)
        let liabilityPosition2 = DataFactory.createLiabilityPosition(name: "Car Loan", poolName: "Private", value: 0.0, context: context)
        
        let assetPositions: [AssetPosition] = [assetPosition1, assetPosition2]
        let liabilityPositions: [LiabilityPosition] = [liabilityPosition1, liabilityPosition2]
        let date: Date = .now
        return DataFactory.createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
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
        
        let threeMonthSnapshot1 = DataFactory.createSnapshotWithoutPositions(for: threeMonthScopeDate1, in: context)
        let threeMonthSnapshot2 = DataFactory.createSnapshotWithoutPositions(for: threeMonthScopeDate2, in: context)
        let threeMonthSnapshot3 = DataFactory.createSnapshotWithoutPositions(for: threeMonthScopeDate3, in: context)
        let threeMonthSnapshot4 = DataFactory.createSnapshotWithoutPositions(for: threeMonthScopeDate4, in: context)
        let threeMonthSnapshots = [threeMonthSnapshot1, threeMonthSnapshot2, threeMonthSnapshot3, threeMonthSnapshot4]
        
        let sixMonthSnapshot1 = DataFactory.createSnapshotWithoutPositions(for: sixMonthScopeDate1, in: context)
        let sixMonthSnapshot2 = DataFactory.createSnapshotWithoutPositions(for: sixMonthScopeDate2, in: context)
        let sixMonthSnapshot3 = DataFactory.createSnapshotWithoutPositions(for: sixMonthScopeDate3, in: context)
        let sixMonthSnapshot4 = DataFactory.createSnapshotWithoutPositions(for: sixMonthScopeDate4, in: context)
        let sixMonthSnapshots = [sixMonthSnapshot1, sixMonthSnapshot2, sixMonthSnapshot3, sixMonthSnapshot4]
        
        let eighteenMonthSnapshot1 = DataFactory.createSnapshotWithoutPositions(for: eighteenMonthScopeDate1, in: context)
        let eighteenMonthSnapshot2 = DataFactory.createSnapshotWithoutPositions(for: eighteenMonthScopeDate2, in: context)
        let eighteenMonthSnapshot3 = DataFactory.createSnapshotWithoutPositions(for: eighteenMonthScopeDate3, in: context)
        let eighteenMonthSnapshot4 = DataFactory.createSnapshotWithoutPositions(for: eighteenMonthScopeDate4, in: context)
        let eighteenMonthSnapshots = [eighteenMonthSnapshot1, eighteenMonthSnapshot2, eighteenMonthSnapshot3, eighteenMonthSnapshot4]
        
        let allScopeSnapshot1 = DataFactory.createSnapshotWithoutPositions(for: allScopeDate1, in: context)
        let allScopeSnapshot2 = DataFactory.createSnapshotWithoutPositions(for: allScopeDate2, in: context)
        let allScopeSnapshots = [allScopeSnapshot1, allScopeSnapshot2]
        
        return (threeMonthSnapshots, sixMonthSnapshots, eighteenMonthSnapshots, allScopeSnapshots)
    }
    
    
    
    func createAndPersistTestObjects_selectedDate_1(using context: NSManagedObjectContext) -> Snapshot {
        let today = Date.now.startOfDay
        return DataFactory.createSnapshotWithoutPositions(for: today, in: context)
    }
    
    func createAndPersistTestObjects_selectedDate_2(using context: NSManagedObjectContext) -> (Snapshot, Snapshot) {
        let date_15_04_2024 = DateParser.shared.date(from: "2024-04-15T00:00:00")!
        let date_15_03_2024 = DateParser.shared.date(from: "2024-03-15T00:00:00")!

        let snapshot_15_04_2024 = DataFactory.createSnapshotWithoutPositions(for: date_15_04_2024, in: context)
        let snapshot_15_03_2024 = DataFactory.createSnapshotWithoutPositions(for: date_15_03_2024, in: context)
        
        return (snapshot_15_03_2024, snapshot_15_04_2024)
    }
    
    func createAndPersistTestObjects_selectedDate_3(using context: NSManagedObjectContext) -> (Snapshot, Snapshot, Snapshot) {
        let date_10_05_2023 = DateParser.shared.date(from: "2023-05-10T00:00:00")!
        let date_13_05_2023 = DateParser.shared.date(from: "2023-05-13T00:00:00")!
        let date_15_05_2023 = DateParser.shared.date(from: "2023-05-15T00:00:00")!
        
        let snapshot_10_05_2023 = DataFactory.createSnapshotWithoutPositions(for: date_10_05_2023, in: context)
        let snapshot_13_05_2023 = DataFactory.createSnapshotWithoutPositions(for: date_13_05_2023, in: context)
        let snapshot_15_05_2023 = DataFactory.createSnapshotWithoutPositions(for: date_15_05_2023, in: context)
        
        return (snapshot_10_05_2023, snapshot_13_05_2023, snapshot_15_05_2023)
    }
    
    func createAndPersistTestObjects_selectedDate_4(using context: NSManagedObjectContext) -> (Snapshot, Snapshot, Snapshot) {
        let date_17_05_2022 = DateParser.shared.date(from: "2022-05-17T00:00:00")!
        let date_05_09_2022 = DateParser.shared.date(from: "2022-09-05T00:00:00")!
        let date_15_12_2022 = DateParser.shared.date(from: "2022-12-15T00:00:00")!
        
        let snapshot_17_05_2022 = DataFactory.createSnapshotWithoutPositions(for: date_17_05_2022, in: context)
        let snapshot_05_09_2022 = DataFactory.createSnapshotWithoutPositions(for: date_05_09_2022, in: context)
        let snapshot_15_12_2022 = DataFactory.createSnapshotWithoutPositions(for: date_15_12_2022, in: context)
        
        return (snapshot_17_05_2022, snapshot_05_09_2022, snapshot_15_12_2022)
    }
    
    func createAndPersistTestObjects_selectedDate_5(using context: NSManagedObjectContext) -> [Snapshot] {
        let date_28_02_2022 = DateParser.shared.date(from: "2022-02-28T00:00:00")!
        let date_31_03_2022 = DateParser.shared.date(from: "2022-03-31T00:00:00")!
        let date_30_04_2022 = DateParser.shared.date(from: "2022-04-30T00:00:00")!
        let date_30_05_2022 = DateParser.shared.date(from: "2022-05-30T00:00:00")!
        let date_30_06_2022 = DateParser.shared.date(from: "2022-06-30T00:00:00")!
        let date_31_07_2022 = DateParser.shared.date(from: "2022-07-31T00:00:00")!
        let date_31_08_2022 = DateParser.shared.date(from: "2022-08-31T00:00:00")!
        let date_28_09_2022 = DateParser.shared.date(from: "2022-09-28T00:00:00")!
        let date_31_10_2022 = DateParser.shared.date(from: "2022-10-31T00:00:00")!
        let date_01_12_2022 = DateParser.shared.date(from: "2022-12-01T00:00:00")!
        let date_31_12_2022 = DateParser.shared.date(from: "2022-12-31T00:00:00")!
        let date_31_01_2023 = DateParser.shared.date(from: "2023-01-31T00:00:00")!
        let date_28_02_2023 = DateParser.shared.date(from: "2023-02-28T00:00:00")!
        let date_31_03_2023 = DateParser.shared.date(from: "2023-03-31T00:00:00")!
        let date_02_05_2023 = DateParser.shared.date(from: "2023-05-02T00:00:00")!
        let date_31_05_2023 = DateParser.shared.date(from: "2023-05-31T00:00:00")!
        
        var snapshots: [Snapshot] = []
        let snapshot_28_02_2022 = DataFactory.createSnapshotWithoutPositions(for: date_28_02_2022, in: context)
        snapshots.append(snapshot_28_02_2022)
        let snapshot_31_03_2022 = DataFactory.createSnapshotWithoutPositions(for: date_31_03_2022, in: context)
        snapshots.append(snapshot_31_03_2022)
        let snapshot_30_04_2022 = DataFactory.createSnapshotWithoutPositions(for: date_30_04_2022, in: context)
        snapshots.append(snapshot_30_04_2022)
        let snapshot_30_05_2022 = DataFactory.createSnapshotWithoutPositions(for: date_30_05_2022, in: context)
        snapshots.append(snapshot_30_05_2022)
        let snapshot_30_06_2022 = DataFactory.createSnapshotWithoutPositions(for: date_30_06_2022, in: context)
        snapshots.append(snapshot_30_06_2022)
        let snapshot_31_07_2022 = DataFactory.createSnapshotWithoutPositions(for: date_31_07_2022, in: context)
        snapshots.append(snapshot_31_07_2022)
        let snapshot_31_08_2022 = DataFactory.createSnapshotWithoutPositions(for: date_31_08_2022, in: context)
        snapshots.append(snapshot_31_08_2022)
        let snapshot_28_09_2022 = DataFactory.createSnapshotWithoutPositions(for: date_28_09_2022, in: context)
        snapshots.append(snapshot_28_09_2022)
        let snapshot_31_10_2022 = DataFactory.createSnapshotWithoutPositions(for: date_31_10_2022, in: context)
        snapshots.append(snapshot_31_10_2022)
        let snapshot_01_12_2022 = DataFactory.createSnapshotWithoutPositions(for: date_01_12_2022, in: context)
        snapshots.append(snapshot_01_12_2022)
        let snapshot_31_12_2022 = DataFactory.createSnapshotWithoutPositions(for: date_31_12_2022, in: context)
        snapshots.append(snapshot_31_12_2022)
        let snapshot_31_01_2023 = DataFactory.createSnapshotWithoutPositions(for: date_31_01_2023, in: context)
        snapshots.append(snapshot_31_01_2023)
        let snapshot_28_02_2023 = DataFactory.createSnapshotWithoutPositions(for: date_28_02_2023, in: context)
        snapshots.append(snapshot_28_02_2023)
        let snapshot_31_03_2023 = DataFactory.createSnapshotWithoutPositions(for: date_31_03_2023, in: context)
        snapshots.append(snapshot_31_03_2023)
        let snapshot_02_05_2023 = DataFactory.createSnapshotWithoutPositions(for: date_02_05_2023, in: context)
        snapshots.append(snapshot_02_05_2023)
        let snapshot_31_05_2023 = DataFactory.createSnapshotWithoutPositions(for: date_31_05_2023, in: context)
        snapshots.append(snapshot_31_05_2023)
        
        return snapshots
    }
}
