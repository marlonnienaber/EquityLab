@testable import EquityLab
import CoreData

struct DashboardViewModelTestDataProvider {
    func createAndPersistTestObjects_getBalanceViewModel_1(using context: NSManagedObjectContext) -> Snapshot {
        let assetPositions: [AssetPosition] = []
        let liabilityPositions: [LiabilityPosition] = []
        let date: Date = .now
        return DataFactory.createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_getBalanceViewModel_2(using context: NSManagedObjectContext) -> Snapshot {
        let assetPosition1 = DataFactory.createAssetPosition(name: "Purse", poolName: "Cash", value: 0.0, context: context)
        let assetPosition2 = DataFactory.createAssetPosition(name: "Konto Sparkasse", poolName: "Bank", value: 0.0, context: context)
        let assetPosition3 = DataFactory.createAssetPosition(name: "Depot FNZ", poolName: "Securities", value: 0.0, context: context)
        
        let liabilityPosition1 = DataFactory.createLiabilityPosition(name: "Car", poolName: "Private", value: 0.0, context: context)
        let liabilityPosition2 = DataFactory.createLiabilityPosition(name: "Office Building", poolName: "Business", value: 0.0, context: context)
        let liabilityPosition3 = DataFactory.createLiabilityPosition(name: "Server", poolName: "Business", value: 0.0, context: context)
        
        let assetPositions: [AssetPosition] = [assetPosition1, assetPosition2, assetPosition3]
        let liabilityPositions: [LiabilityPosition] = [liabilityPosition1,liabilityPosition2,liabilityPosition3]
        let date: Date = .now
        return DataFactory.createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_getBalanceViewModel_3(using context: NSManagedObjectContext) -> Snapshot {
        let assetPosition1 = DataFactory.createAssetPosition(name: "Purse", poolName: "Cash", value: 5.0, context: context)
        let assetPosition2 = DataFactory.createAssetPosition(name: "Piggy Bank", poolName: "Cash", value: 11.4, context: context)
        let assetPosition3 = DataFactory.createAssetPosition(name: "Konto Sparkasse", poolName: "Bank", value: 89.76, context: context)
        let assetPosition4 = DataFactory.createAssetPosition(name: "Konto Commerzbank", poolName: "Bank", value: 122.33, context: context)
        let assetPosition5 = DataFactory.createAssetPosition(name: "Depot FNZ", poolName: "Securities", value: 50.85, context: context)
        
        let liabilityPosition1 = DataFactory.createLiabilityPosition(name: "Car", poolName: "Private", value: 5.0, context: context)
        let liabilityPosition2 = DataFactory.createLiabilityPosition(name: "DJ Equipment", poolName: "Private", value: 11.4, context: context)
        let liabilityPosition3 = DataFactory.createLiabilityPosition(name: "Office Building", poolName: "Business", value: 89.76, context: context)
        let liabilityPosition4 = DataFactory.createLiabilityPosition(name: "Server", poolName: "Business", value: 122.33, context: context)
        let liabilityPosition5 = DataFactory.createLiabilityPosition(name: "Production", poolName: "Business", value: 50.85, context: context)
        
        let assetPositions: [AssetPosition] = [assetPosition1, assetPosition2, assetPosition3, assetPosition4, assetPosition5]
        let liabilityPositions: [LiabilityPosition] = [liabilityPosition1, liabilityPosition2, liabilityPosition3, liabilityPosition4, liabilityPosition5]
        let date: Date = .now
        return DataFactory.createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_getBalanceViewModel_4(using context: NSManagedObjectContext) -> Snapshot {
        let assetPosition1 = DataFactory.createAssetPosition(name: "Purse", poolName: "Cash", value: 0.0, context: context)
        let assetPosition2 = DataFactory.createAssetPosition(name: "Konto Sparkasse", poolName: "Bank", value: 10.0, context: context)
        
        let liabilityPosition1 = DataFactory.createLiabilityPosition(name: "DJ Equipment", poolName: "Private", value: 0.0, context: context)
        let liabilityPosition2 = DataFactory.createLiabilityPosition(name: "Office Building", poolName: "Business", value: 10.0, context: context)
        
        let assetPositions: [AssetPosition] = [assetPosition1, assetPosition2]
        let liabilityPositions: [LiabilityPosition] = [liabilityPosition1,liabilityPosition2]
        let date: Date = .now
        return DataFactory.createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_getBalanceViewModel_5(using context: NSManagedObjectContext) -> Snapshot {
        let assetPosition1 = DataFactory.createAssetPosition(name: "Purse", poolName: "Cash", value: 0.0, context: context)
        let liabilityPosition1 = DataFactory.createLiabilityPosition(name: "DJ Equipment", poolName: "Private", value: 0.0, context: context)
        
        let assetPositions: [AssetPosition] = [assetPosition1]
        let liabilityPositions: [LiabilityPosition] = [liabilityPosition1]
        let date: Date = .now
        return DataFactory.createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_getBalanceViewModel_6(using context: NSManagedObjectContext) -> Snapshot {
        let assetPosition1 = DataFactory.createAssetPosition(name: "Purse", poolName: "Cash", value: 17.01, context: context)
        let liabilityPosition1 = DataFactory.createLiabilityPosition(name: "Office Building", poolName: "Business", value: 17.01, context: context)
        
        let assetPositions: [AssetPosition] = [assetPosition1]
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
    
    
    
    func createAndPersistTestObjects_noPositiveAssetDistributionCategoriesRecorded_1(using context: NSManagedObjectContext) -> Snapshot {
        let assetPosition1 = DataFactory.createAssetPosition(name: "Purse", poolName: "Cash", value: 0.0, context: context)
        let liabilityPosition1 = DataFactory.createLiabilityPosition(name: "DJ Equipment", poolName: "Private", value: 0.0, context: context)
        
        let assetPositions: [AssetPosition] = [assetPosition1]
        let liabilityPositions: [LiabilityPosition] = [liabilityPosition1]
        let date: Date = .now
        return DataFactory.createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_noPositiveAssetDistributionCategoriesRecorded_2(using context: NSManagedObjectContext) -> Snapshot {
        let assetPosition1 = DataFactory.createAssetPosition(name: "Purse", poolName: "Cash", value: 17.01, context: context)
        let liabilityPosition1 = DataFactory.createLiabilityPosition(name: "Office Building", poolName: "Business", value: 17.01, context: context)
        
        let assetPositions: [AssetPosition] = [assetPosition1]
        let liabilityPositions: [LiabilityPosition] = [liabilityPosition1]
        let date: Date = .now
        return DataFactory.createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    
    
    func createAndPersistTestObjects_distributionCategories_1(using context: NSManagedObjectContext) -> ([DonutChartCategory],[DonutChartCategory]) {
        let assetPosition1 = DataFactory.createAssetPosition(name: "Sparkasse Konto", poolName: "Bank", value: 20.0, context: context)
        let assetPosition2 = DataFactory.createAssetPosition(name: "FNZ Depot", poolName: "Wertpapiere", value: 30.0, context: context)
        let assetPosition3 = DataFactory.createAssetPosition(name: "Geldbeutel", poolName: "Bargeld", value: 50.0, context: context)
        
        let liabilityPosition1 = DataFactory.createLiabilityPosition(name: "Auto-Kredit", poolName: "Privat", value: 40, context: context)
        let liabilityPosition2 = DataFactory.createLiabilityPosition(name: "Studien-Kredit", poolName: "Staat", value: 60, context: context)
        
        let _ = DataFactory.createSnapshot(with: [assetPosition1, assetPosition2, assetPosition3],
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
        let assetPosition1 = DataFactory.createAssetPosition(name: "Sparkasse Girokonto", poolName: "Bank", value: 10.0, context: context)
        let assetPosition2 = DataFactory.createAssetPosition(name: "Sparkasse Tagesgeldkonto", poolName: "Bank", value: 25.0, context: context)
        let assetPosition3 = DataFactory.createAssetPosition(name: "Commerzbank Konto", poolName: "Bank", value: 5.0, context: context)
        let assetPosition4 = DataFactory.createAssetPosition(name: "FNZ Depot", poolName: "Wertpapiere", value: 1.0, context: context)
        let assetPosition5 = DataFactory.createAssetPosition(name: "Sparkasse Depot", poolName: "Wertpapiere", value: 2.0, context: context)
        let assetPosition6 = DataFactory.createAssetPosition(name: "Geldbeutel", poolName: "Bargeld", value: 57.0, context: context)
        
        let liabilityPosition1 = DataFactory.createLiabilityPosition(name: "Auto-Kredit", poolName: "Privat", value: 40, context: context)
        let liabilityPosition2 = DataFactory.createLiabilityPosition(name: "Miete-Kredit", poolName: "Privat", value: 40, context: context)
        let liabilityPosition3 = DataFactory.createLiabilityPosition(name: "Plattenspieler-Kredit", poolName: "Privat", value: 17, context: context)
        let liabilityPosition4 = DataFactory.createLiabilityPosition(name: "Studien-Kredit", poolName: "Staat", value: 3.0, context: context)
        
        let _ = DataFactory.createSnapshot(with: [assetPosition1, assetPosition2, assetPosition3, assetPosition4, assetPosition5, assetPosition6],
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
        let assetPosition1 = DataFactory.createAssetPosition(name: "Sparkasse Girokonto", poolName: "Bank", value: 10.0, context: context)
        let assetPosition2 = DataFactory.createAssetPosition(name: "Sparkasse Tagesgeldkonto", poolName: "Bank", value: 25.0, context: context)
        let assetPosition3 = DataFactory.createAssetPosition(name: "Commerzbank Konto", poolName: "Bank", value: 35.0, context: context)
        let assetPosition4 = DataFactory.createAssetPosition(name: "FNZ Depot", poolName: "Wertpapiere", value: 16.0, context: context)
        let assetPosition5 = DataFactory.createAssetPosition(name: "Sparkasse Depot", poolName: "Wertpapiere", value: 12.0, context: context)
        let assetPosition6 = DataFactory.createAssetPosition(name: "Geldbeutel", poolName: "Bargeld", value: 1.0, context: context)
        let assetPosition7 = DataFactory.createAssetPosition(name: "Sparschwein", poolName: "Bargeld", value: 1.0, context: context)
        
        let liabilityPosition1 = DataFactory.createLiabilityPosition(name: "Auto-Kredit", poolName: "Privat", value: 40, context: context)
        let liabilityPosition2 = DataFactory.createLiabilityPosition(name: "Miete-Kredit", poolName: "Privat", value: 40, context: context)
        let liabilityPosition3 = DataFactory.createLiabilityPosition(name: "Plattenspieler-Kredit", poolName: "Privat", value: 18, context: context)
        let liabilityPosition4 = DataFactory.createLiabilityPosition(name: "Studien-Kredit", poolName: "Staat", value: 2.0, context: context)
        
        let _ = DataFactory.createSnapshot(with: [assetPosition1, assetPosition2, assetPosition3, assetPosition4, assetPosition5, assetPosition6, assetPosition7],
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
        let assetPosition1 = DataFactory.createAssetPosition(name: "Sparkasse Girokonto", poolName: "Bank Inland", value: 10.0, context: context)
        let assetPosition2 = DataFactory.createAssetPosition(name: "Sparkasse Tagesgeldkonto", poolName: "Bank Inland", value: 25.0, context: context)
        let assetPosition3 = DataFactory.createAssetPosition(name: "Commerzbank Konto", poolName: "Bank Inland", value: 35.0, context: context)
        let assetPosition4 = DataFactory.createAssetPosition(name: "FNZ Depot", poolName: "Wertpapiere", value: 16.0, context: context)
        let assetPosition5 = DataFactory.createAssetPosition(name: "Sparkasse Depot", poolName: "Wertpapiere", value: 12.0, context: context)
        let assetPosition6 = DataFactory.createAssetPosition(name: "Geldbeutel", poolName: "Bargeld", value: 1.0, context: context)
        let assetPosition7 = DataFactory.createAssetPosition(name: "Sparschwein", poolName: "Bargeld", value: 0.5, context: context)
        let assetPosition8 = DataFactory.createAssetPosition(name: "Bank of America Konto", poolName: "Bank Ausland", value: 0.5, context: context)
        
        let liabilityPosition1 = DataFactory.createLiabilityPosition(name: "Auto-Kredit", poolName: "Familie", value: 40, context: context)
        let liabilityPosition2 = DataFactory.createLiabilityPosition(name: "Miete-Kredit", poolName: "Familie", value: 40, context: context)
        let liabilityPosition3 = DataFactory.createLiabilityPosition(name: "Plattenspieler-Kredit", poolName: "Familie", value: 18, context: context)
        let liabilityPosition4 = DataFactory.createLiabilityPosition(name: "Studien-Kredit", poolName: "Staat", value: 1.0, context: context)
        let liabilityPosition5 = DataFactory.createLiabilityPosition(name: "Feiern Lenni", poolName: "Freunde", value: 1.0, context: context)
        
        let _ = DataFactory.createSnapshot(with: [assetPosition1, assetPosition2, assetPosition3, assetPosition4, assetPosition5, assetPosition6, assetPosition7, assetPosition8],
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
        let _ = DataFactory.createSnapshotWithoutPositions(for: .now, in: context)
        return ([], [])
    }
    
    
    
    func createAndPersistTestObjects_setSelectedCategoryForNewCumulativeValue_1(using context: NSManagedObjectContext) -> (DonutChartCategory, DonutChartCategory) {
        let assetPosition1 = DataFactory.createAssetPosition(name: "Sparkasse Konto", poolName: "Bank", value: 20.0, context: context)
        let assetPosition2 = DataFactory.createAssetPosition(name: "FNZ Depot", poolName: "Wertpapiere", value: 30.0, context: context)
        let assetPosition3 = DataFactory.createAssetPosition(name: "Geldbeutel", poolName: "Bargeld", value: 50.0, context: context)
        
        let liabilityPosition1 = DataFactory.createLiabilityPosition(name: "Auto-Kredit", poolName: "Privat", value: 40, context: context)
        let liabilityPosition2 = DataFactory.createLiabilityPosition(name: "Studien-Kredit", poolName: "Staat", value: 60, context: context)
        
        let _ = DataFactory.createSnapshot(with: [assetPosition1, assetPosition2, assetPosition3],
                                           and: [liabilityPosition1, liabilityPosition2],
                                           for: .now,
                                           in: context)
        
        return (
            .init(pools: [.init(value: 30.0, name: "Wertpapiere", percentage: 30.0)]),
            .init(pools:[.init(value: 40.0, name: "Privat", percentage: 40.0)])
        )
    }
    
    func createAndPersistTestObjects_setSelectedCategoryForNewCumulativeValue_2(using context: NSManagedObjectContext) -> (DonutChartCategory, DonutChartCategory) {
        let assetPosition1 = DataFactory.createAssetPosition(name: "Sparkasse Konto", poolName: "Bank", value: 20.0, context: context)
        let assetPosition2 = DataFactory.createAssetPosition(name: "FNZ Depot", poolName: "Wertpapiere", value: 30.0, context: context)
        let assetPosition3 = DataFactory.createAssetPosition(name: "Geldbeutel", poolName: "Bargeld", value: 50.0, context: context)
        
        let liabilityPosition1 = DataFactory.createLiabilityPosition(name: "Auto-Kredit", poolName: "Privat", value: 40, context: context)
        let liabilityPosition2 = DataFactory.createLiabilityPosition(name: "Studien-Kredit", poolName: "Staat", value: 60, context: context)
        
        let _ = DataFactory.createSnapshot(with: [assetPosition1, assetPosition2, assetPosition3],
                                           and: [liabilityPosition1, liabilityPosition2],
                                           for: .now,
                                           in: context)
        
        return (
            .init(pools: [.init(value: 20.0, name: "Bank", percentage: 20.0)]),
            .init(pools:[.init(value: 40.0, name: "Privat", percentage: 40.0)])
        )
    }
    
    
    
    func createAndPersistTestObjects_setSelectedDistributionCategoryOnNewSnapshot_1(using context: NSManagedObjectContext) -> (DonutChartCategory, DonutChartCategory, Date) {
        let assetPosition1 = DataFactory.createAssetPosition(name: "Sparkasse Konto", poolName: "Bank", value: 20.0, context: context)
        let assetPosition2 = DataFactory.createAssetPosition(name: "FNZ Depot", poolName: "Wertpapiere", value: 30.0, context: context)
        
        let liabilityPosition1 = DataFactory.createLiabilityPosition(name: "Auto-Kredit", poolName: "Privat", value: 40, context: context)
        let liabilityPosition2 = DataFactory.createLiabilityPosition(name: "Studien-Kredit", poolName: "Staat", value: 60, context: context)
        
        let snapshot = DataFactory.createSnapshot(with: [assetPosition1, assetPosition2],
                                                  and: [liabilityPosition1, liabilityPosition2],
                                                  for: .now,
                                                  in: context)
        
        let assetCategory1 = DonutChartCategory(pools: [Pool(value: 20.0, name: "Bank", percentage: 20.0)])
        let assetCategory2 = DonutChartCategory(pools: [Pool(value: 30.0, name: "Wertpapiere", percentage: 30.0)])
        
        let liabilityCategory1 = DonutChartCategory(pools: [Pool(value: 40.0, name: "Privat", percentage: 40.0)])
        let liabilityCategory2 = DonutChartCategory(pools: [Pool(value: 60.0, name: "Staat", percentage: 60.0)])
        
        return (assetCategory2, liabilityCategory2, snapshot.date!)
    }
    
    func createAndPersistTestObjects_setSelectedDistributionCategoryOnNewSnapshot_2(using context: NSManagedObjectContext) -> (DonutChartCategory, DonutChartCategory, Date) {
        let assetPosition1 = DataFactory.createAssetPosition(name: "Sparkasse Konto", poolName: "Bank", value: 20.0, context: context)
        let assetPosition2 = DataFactory.createAssetPosition(name: "FNZ Depot", poolName: "Wertpapiere", value: 30.0, context: context)
        
        let liabilityPosition1 = DataFactory.createLiabilityPosition(name: "Auto-Kredit", poolName: "Privat", value: 40, context: context)
        let liabilityPosition2 = DataFactory.createLiabilityPosition(name: "Studien-Kredit", poolName: "Staat", value: 60, context: context)
        
        let snapshot = DataFactory.createSnapshot(with: [assetPosition1, assetPosition2],
                                                  and: [liabilityPosition1, liabilityPosition2],
                                                  for: .now,
                                                  in: context)
        
        let assetCategory1 = DonutChartCategory(pools: [Pool(value: 20.0, name: "Bank", percentage: 20.0)])
        let assetCategory2 = DonutChartCategory(pools: [Pool(value: 30.0, name: "Wertpapiere", percentage: 30.0)])
        
        let liabilityCategory1 = DonutChartCategory(pools: [Pool(value: 40.0, name: "Privat", percentage: 40.0)])
        let liabilityCategory2 = DonutChartCategory(pools: [Pool(value: 60.0, name: "Staat", percentage: 60.0)])
        
        return (assetCategory1, liabilityCategory1, snapshot.date!)
    }
    
    
    
    func createAndPersistTestObjects_computeSnapshotBeforeSelectedSnapshot_1(using context: NSManagedObjectContext) -> (Snapshot,Snapshot) {
        let date_21_10_1966 = DateParser.shared.date(from: "1966-10-21T00:00:00")!
        let date_23_04_1970 = DateParser.shared.date(from: "1970-04-23T00:00:00")!
        let date_01_01_2002 = DateParser.shared.date(from: "2002-01-01T00:00:00")!
        let date_26_04_2002 = DateParser.shared.date(from: "2002-04-26T00:00:00")!
        let date_31_12_2002 = DateParser.shared.date(from: "2002-12-31T00:00:00")!
        let date_31_01_2004 = DateParser.shared.date(from: "2004-01-31T00:00:00")!
        let snapshot1 = DataFactory.createSnapshotWithoutPositions(for: date_21_10_1966, in: context)
        let snapshot2 = DataFactory.createSnapshotWithoutPositions(for: date_23_04_1970, in: context)
        let snapshot3 = DataFactory.createSnapshotWithoutPositions(for: date_01_01_2002, in: context)
        let snapshot4 = DataFactory.createSnapshotWithoutPositions(for: date_26_04_2002, in: context)
        let snapshot5 = DataFactory.createSnapshotWithoutPositions(for: date_31_12_2002, in: context)
        let snapshot6 = DataFactory.createSnapshotWithoutPositions(for: date_31_01_2004, in: context)
        return (snapshot5,snapshot6)
    }
    
    func createAndPersistTestObjects_computeSnapshotBeforeSelectedSnapshot_2(using context: NSManagedObjectContext) -> (Snapshot,Snapshot) {
        let date_21_10_1966 = DateParser.shared.date(from: "1966-10-21T00:00:00")!
        let date_23_04_1970 = DateParser.shared.date(from: "1970-04-23T00:00:00")!
        let date_01_01_2002 = DateParser.shared.date(from: "2002-01-01T00:00:00")!
        let date_26_04_2002 = DateParser.shared.date(from: "2002-04-26T00:00:00")!
        let date_31_12_2002 = DateParser.shared.date(from: "2002-12-31T00:00:00")!
        let date_31_01_2004 = DateParser.shared.date(from: "2004-01-31T00:00:00")!
        let snapshot1 = DataFactory.createSnapshotWithoutPositions(for: date_21_10_1966, in: context)
        let snapshot2 = DataFactory.createSnapshotWithoutPositions(for: date_23_04_1970, in: context)
        let snapshot3 = DataFactory.createSnapshotWithoutPositions(for: date_01_01_2002, in: context)
        let snapshot4 = DataFactory.createSnapshotWithoutPositions(for: date_26_04_2002, in: context)
        let snapshot5 = DataFactory.createSnapshotWithoutPositions(for: date_31_12_2002, in: context)
        let snapshot6 = DataFactory.createSnapshotWithoutPositions(for: date_31_01_2004, in: context)
        return (snapshot3,snapshot4)
    }
    
    func createAndPersistTestObjects_computeSnapshotBeforeSelectedSnapshot_3(using context: NSManagedObjectContext) -> Snapshot {
        let date_21_10_1966 = DateParser.shared.date(from: "1966-10-21T00:00:00")!
        let date_23_04_1970 = DateParser.shared.date(from: "1970-04-23T00:00:00")!
        let date_01_01_2002 = DateParser.shared.date(from: "2002-01-01T00:00:00")!
        let date_26_04_2002 = DateParser.shared.date(from: "2002-04-26T00:00:00")!
        let date_31_12_2002 = DateParser.shared.date(from: "2002-12-31T00:00:00")!
        let date_31_01_2004 = DateParser.shared.date(from: "2004-01-31T00:00:00")!
        let snapshot1 = DataFactory.createSnapshotWithoutPositions(for: date_21_10_1966, in: context)
        let snapshot2 = DataFactory.createSnapshotWithoutPositions(for: date_23_04_1970, in: context)
        let snapshot3 = DataFactory.createSnapshotWithoutPositions(for: date_01_01_2002, in: context)
        let snapshot4 = DataFactory.createSnapshotWithoutPositions(for: date_26_04_2002, in: context)
        let snapshot5 = DataFactory.createSnapshotWithoutPositions(for: date_31_12_2002, in: context)
        let snapshot6 = DataFactory.createSnapshotWithoutPositions(for: date_31_01_2004, in: context)
        return snapshot1
    }
    
    
    
    func createAndPersistTestObjects_changeChartCategories_1(using context: NSManagedObjectContext) -> (Snapshot,[BarChartCategory],Decimal) {
        let firstLiabilityPosition1 = DataFactory.createLiabilityPosition(name: "Auto", poolName: "Privat", value: 0, context: context)
        let secondLiabilityPosition1 = DataFactory.createLiabilityPosition(name: "Studium", poolName: "Staatlich", value: 50, context: context)
        let thirdLiabilityPosition1 = DataFactory.createLiabilityPosition(name: "Wohnung", poolName: "Bank", value: 10, context: context)
        let fourthLiabilityPosition1 = DataFactory.createLiabilityPosition(name: "Sport", poolName: "Freunde", value: 20, context: context)
        let liabilityPositions1 = [firstLiabilityPosition1,secondLiabilityPosition1,thirdLiabilityPosition1,fourthLiabilityPosition1]
        let date1 = DateParser.shared.date(from: "1966-10-21T00:00:00")!
        let _ = DataFactory.createSnapshot(with: [], and: liabilityPositions1, for: date1, in: context)
        
        let firstLiabilityPosition2 = DataFactory.createLiabilityPosition(name: "Auto", poolName: "Privat", value: 5, context: context)
        let secondLiabilityPosition2 = DataFactory.createLiabilityPosition(name: "Studium", poolName: "Staatlich", value: 25, context: context)
        let thirdLiabilityPosition2 = DataFactory.createLiabilityPosition(name: "Wohnung", poolName: "Bank", value: 17, context: context)
        let fourthLiabilityPosition2 = DataFactory.createLiabilityPosition(name: "Sport", poolName: "Freunde", value: 20, context: context)
        let liabilityPositions2 = [firstLiabilityPosition2,secondLiabilityPosition2,thirdLiabilityPosition2,fourthLiabilityPosition2]
        let date2 = DateParser.shared.date(from: "1966-10-25T00:00:00")!
        let snapshot = DataFactory.createSnapshot(with: [], and: liabilityPositions2, for: date2, in: context)
        
        let firstExpectedChangeCategory = BarChartCategory(change: 0, name: "Privat")
        let secondExpectedChangeCategory = BarChartCategory(change: -50, name: "Staatlich")
        let thirdExpectedChangeCategory = BarChartCategory(change: 70, name: "Bank")
        let fourthExpectedChangeCategory = BarChartCategory(change: 0, name: "Freunde")
        let expectedChangeCategories = [
            firstExpectedChangeCategory,
            secondExpectedChangeCategory,
            thirdExpectedChangeCategory,
            fourthExpectedChangeCategory
        ]
        return (snapshot, expectedChangeCategories, 70)
    }
    
    func createAndPersistTestObjects_changeChartCategories_2(using context: NSManagedObjectContext) -> (Snapshot,[BarChartCategory],Decimal) {
        let firstAssetPosition1 = DataFactory.createAssetPosition(name: "Auto", poolName: "Privat", value: 0, context: context)
        let secondAssetPosition1 = DataFactory.createAssetPosition(name: "Studium", poolName: "Staatlich", value: 50, context: context)
        let thirdAssetPosition1 = DataFactory.createAssetPosition(name: "Wohnung", poolName: "Bank", value: 10, context: context)
        let fourthAssetPosition1 = DataFactory.createAssetPosition(name: "Sport", poolName: "Freunde", value: 20, context: context)
        let assetPositions1 = [firstAssetPosition1,secondAssetPosition1,thirdAssetPosition1,fourthAssetPosition1]
        let date1 = DateParser.shared.date(from: "1966-10-21T00:00:00")!
        let _ = DataFactory.createSnapshot(with: assetPositions1, and: [], for: date1, in: context)
        
        let firstAssetPosition2 = DataFactory.createAssetPosition(name: "Auto", poolName: "Privat", value: 5, context: context)
        let secondAssetPosition2 = DataFactory.createAssetPosition(name: "Studium", poolName: "Staatlich", value: 25, context: context)
        let thirdAssetPosition2 = DataFactory.createAssetPosition(name: "Wohnung", poolName: "Bank", value: 17, context: context)
        let fourthAssetPosition2 = DataFactory.createAssetPosition(name: "Sport", poolName: "Freunde", value: 20, context: context)
        let assetPositions2 = [firstAssetPosition2,secondAssetPosition2,thirdAssetPosition2,fourthAssetPosition2]
        let date2 = DateParser.shared.date(from: "1966-10-25T00:00:00")!
        let snapshot = DataFactory.createSnapshot(with: assetPositions2, and: [], for: date2, in: context)
        
        let firstExpectedChangeCategory = BarChartCategory(change: 0, name: "Privat")
        let secondExpectedChangeCategory = BarChartCategory(change: -50, name: "Staatlich")
        let thirdExpectedChangeCategory = BarChartCategory(change: 70, name: "Bank")
        let fourthExpectedChangeCategory = BarChartCategory(change: 0, name: "Freunde")
        let expectedChangeCategories = [
            firstExpectedChangeCategory,
            secondExpectedChangeCategory,
            thirdExpectedChangeCategory,
            fourthExpectedChangeCategory
        ]
        return (snapshot, expectedChangeCategories, 70)
    }
}
