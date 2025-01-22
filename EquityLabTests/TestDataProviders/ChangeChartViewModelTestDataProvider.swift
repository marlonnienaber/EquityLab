@testable import EquityLab
import CoreData

struct ChangeChartViewModelTestDataProvider {
    func createAndPersistTestObjects_computeShotBeforeSelectedShot_1(using context: NSManagedObjectContext) -> (Snapshot,Snapshot) {
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
    
    func createAndPersistTestObjects_computeShotBeforeSelectedShot_2(using context: NSManagedObjectContext) -> (Snapshot,Snapshot) {
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
    
    func createAndPersistTestObjects_computeShotBeforeSelectedShot_3(using context: NSManagedObjectContext) -> Snapshot {
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


