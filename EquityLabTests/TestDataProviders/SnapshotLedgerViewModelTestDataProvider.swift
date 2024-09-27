@testable import EquityLab
import CoreData

struct SnapshotLedgerViewModelTestDataProvider {
    func createAndPersistTestObjects_getSnapshots_1(using context: NSManagedObjectContext) -> [Snapshot] {
        let date_23_04_1970 = DateParser.shared.date(from: "1970-04-23T00:00:00Z")!
        let date_21_10_1966 = DateParser.shared.date(from: "1966-10-21T00:00:00Z")!
        let date_26_04_2002 = DateParser.shared.date(from: "2002-04-26T00:00:00Z")!
        let date_31_01_2004 = DateParser.shared.date(from: "2004-01-31T00:00:00Z")!
        let _ = DataFactory.createSnapshotWithoutPositions(for: date_23_04_1970, in: context)
        let _ = DataFactory.createSnapshotWithoutPositions(for: date_21_10_1966, in: context)
        let snapshot3 = DataFactory.createSnapshotWithoutPositions(for: date_26_04_2002, in: context)
        let _ = DataFactory.createSnapshotWithoutPositions(for: date_31_01_2004, in: context)
        return [snapshot3]
    }
    
    func createAndPersistTestObjects_getSnapshots_2(using context: NSManagedObjectContext) -> [Snapshot] {
        let date_23_04_1970 = DateParser.shared.date(from: "1970-04-23T00:00:00Z")!
        let date_21_10_1966 = DateParser.shared.date(from: "1966-10-21T00:00:00Z")!
        let date_26_04_2002 = DateParser.shared.date(from: "2002-04-26T00:00:00Z")!
        let date_01_01_2002 = DateParser.shared.date(from: "2002-01-01T00:00:00Z")!
        let date_31_12_2002 = DateParser.shared.date(from: "2002-12-31T00:00:00Z")!
        let date_31_01_2004 = DateParser.shared.date(from: "2004-01-31T00:00:00Z")!
        let _ = DataFactory.createSnapshotWithoutPositions(for: date_23_04_1970, in: context)
        let _ = DataFactory.createSnapshotWithoutPositions(for: date_21_10_1966, in: context)
        let snapshot3 = DataFactory.createSnapshotWithoutPositions(for: date_26_04_2002, in: context)
        let snapshot4 = DataFactory.createSnapshotWithoutPositions(for: date_01_01_2002, in: context)
        let snapshot5 = DataFactory.createSnapshotWithoutPositions(for: date_31_12_2002, in: context)
        let _ = DataFactory.createSnapshotWithoutPositions(for: date_31_01_2004, in: context)
        return [snapshot3, snapshot4, snapshot5]
    }
    
    func createAndPersistTestObjects_getSnapshots_3(using context: NSManagedObjectContext) -> [Snapshot] {
        let date_23_04_1970 = DateParser.shared.date(from: "1970-04-23T00:00:00Z")!
        let date_21_10_1966 = DateParser.shared.date(from: "1966-10-21T00:00:00Z")!
        let date_31_01_2004 = DateParser.shared.date(from: "2004-01-31T00:00:00Z")!
        let _ = DataFactory.createSnapshotWithoutPositions(for: date_23_04_1970, in: context)
        let _ = DataFactory.createSnapshotWithoutPositions(for: date_21_10_1966, in: context)
        let _ = DataFactory.createSnapshotWithoutPositions(for: date_31_01_2004, in: context)
        return []
    }
    
    
    func createAndPersistTestObjects_getEquityValue_1(using context: NSManagedObjectContext) -> Snapshot {
        let assetPosition1 = DataFactory.createAssetPosition(name: "Purse", poolName: "Cash", value: 4.0, context: context)
        let assetPosition2 = DataFactory.createAssetPosition(name: "Piggy Bank", poolName: "Cash", value: 13.77, context: context)
        
        let assetPositions: [AssetPosition] = [assetPosition1, assetPosition2]
        let liabilityPositions: [LiabilityPosition] = []
        let date: Date = .now
        return DataFactory.createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_getEquityValue_2(using context: NSManagedObjectContext) -> Snapshot {
        let liabilityPosition1 = DataFactory.createLiabilityPosition(name: "DJ Equipment", poolName: "Private", value: 7.04, context: context)
        let liabilityPosition2 = DataFactory.createLiabilityPosition(name: "Office Building", poolName: "Business", value: 13.39, context: context)
        
        let assetPositions: [AssetPosition] = []
        let liabilityPositions: [LiabilityPosition] = [liabilityPosition1, liabilityPosition2]
        let date: Date = .now
        return DataFactory.createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_getEquityValue_3(using context: NSManagedObjectContext) -> Snapshot {
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
    
    func createAndPersistTestObjects_getEquityValue_4(using context: NSManagedObjectContext) -> Snapshot {
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
}
