import XCTest
@testable import EquityLab

final class DashboardViewModelTests: XCTestCase {
    private var testingCoreDataStack: TestingCoreDataStack!
    private var testingSnapshotRepository: SnapshotRepositoryNew!
    private var testingAssetRepository: AssetRepository!
    private var testingLiabilityRepository: LiabilityRepository!
    private let testDataProvider = DashboardViewModelTestDataProvider()
    
    override func setUpWithError() throws {
        testingCoreDataStack = TestingCoreDataStack()
        testingSnapshotRepository = SnapshotRepositoryNew(context: testingCoreDataStack.context)
        testingAssetRepository = AssetRepository(context: testingCoreDataStack.context)
        testingLiabilityRepository = LiabilityRepository(context: testingCoreDataStack.context)
    }
    
    
    
    /// snapshot with no liabilityPositions
    func test_equityValue_1() throws {
        let sut = DashboardViewModel(snapshotRepository: testingSnapshotRepository)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_equityValue_1(using: testingCoreDataStack.context)
        let expectedResult: Decimal = 17.77
        let actualResult = sut.getEquityValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    /// snapshot with no assetPositions
    func test_equityValue_2() throws {
        let sut = DashboardViewModel(snapshotRepository: testingSnapshotRepository)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_equityValue_2(using: testingCoreDataStack.context)
        let expectedResult: Decimal = -20.43
        let actualResult = sut.getEquityValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    /// snapshot with 5 assetPositions (value >= 0) and 2 liabilityPositions (value > 0)
    func test_equityValue_3() throws {
        let sut = DashboardViewModel(snapshotRepository: testingSnapshotRepository)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_equityValue_3(using: testingCoreDataStack.context)
        let expectedResult: Decimal = 253.91
        let actualResult = sut.getEquityValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult, accuracy: 0.01)
    }
    
    /// snapshot with 10 assetPositions (value > 0) and 7 liabilityPositions (value > 0)
    func test_equityValue_4() throws {
        let sut = DashboardViewModel(snapshotRepository: testingSnapshotRepository)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_equityValue_4(using: testingCoreDataStack.context)
        let expectedResult: Decimal = 876.79
        let actualResult = sut.getEquityValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult, accuracy: 0.01)
    }
    
    
    
    /// snapshot with no assetPositions/no liabilityPositions
    func test_getBalanceViewModel_1() throws {
        let sut = DashboardViewModel(snapshotRepository: testingSnapshotRepository)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_getBalanceViewModel_1(using: testingCoreDataStack.context)
        let balanceViewModel = sut.getBalanceViewModel(for: testSnapshot)
        
        let expectedAssetValueString = LocalizedCurrencyFormatter.shared.string(from: 0.0)!
        let actualAssetValueString = balanceViewModel.assetValueString
        XCTAssertEqual(expectedAssetValueString, actualAssetValueString)
        
        let expectedLiabilityValueString = LocalizedCurrencyFormatter.shared.string(from: 0.0)!
        let actualLiabilityValueString = balanceViewModel.liabilityValueString
        XCTAssertEqual(expectedLiabilityValueString, actualLiabilityValueString)
    }
    
    /// snapshot with 3 assetPosition and 3 liabilityPositions of value 0.0
    func test_getBalanceViewModel_2() throws {
        let sut = DashboardViewModel(snapshotRepository: testingSnapshotRepository)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_getBalanceViewModel_2(using: testingCoreDataStack.context)
        let balanceViewModel = sut.getBalanceViewModel(for: testSnapshot)
        
        let expectedAssetValueString = LocalizedCurrencyFormatter.shared.string(from: 0.0)!
        let actualAssetValueString = balanceViewModel.assetValueString
        XCTAssertEqual(expectedAssetValueString, actualAssetValueString)
        
        let expectedLiabilityValueString = LocalizedCurrencyFormatter.shared.string(from: 0.0)!
        let actualLiabilityValueString = balanceViewModel.liabilityValueString
        XCTAssertEqual(expectedLiabilityValueString, actualLiabilityValueString)
    }
    
    /// snapshot with 5 assetPosition and 5 liabilityPositions of value > 0.0
    func test_getBalanceViewModele_3() throws {
        let sut = DashboardViewModel(snapshotRepository: testingSnapshotRepository)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_getBalanceViewModel_3(using: testingCoreDataStack.context)
        let balanceViewModel = sut.getBalanceViewModel(for: testSnapshot)
        
        let expectedAssetValueString = LocalizedCurrencyFormatter.shared.string(from: 279.34)!
        let actualAssetValueString = balanceViewModel.assetValueString
        XCTAssertEqual(expectedAssetValueString, actualAssetValueString)
        
        let expectedLiabilityValueString = LocalizedCurrencyFormatter.shared.string(from: 279.34)!
        let actualLiabilityValueString = balanceViewModel.liabilityValueString
        XCTAssertEqual(expectedLiabilityValueString, actualLiabilityValueString)
    }
    
    /// snapshot with 2 assetPositions and 2 liabilityPositions(one with value 0.0 and one with value > 0.0)
    func test_getBalanceViewModel_4() throws {
        let sut = DashboardViewModel(snapshotRepository: testingSnapshotRepository)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_getBalanceViewModel_4(using: testingCoreDataStack.context)
        let balanceViewModel = sut.getBalanceViewModel(for: testSnapshot)
        
        let expectedAssetValueString = LocalizedCurrencyFormatter.shared.string(from: 10.0)!
        let actualAssetValueString = balanceViewModel.assetValueString
        XCTAssertEqual(expectedAssetValueString, actualAssetValueString)
        
        let expectedLiabilityValueString = LocalizedCurrencyFormatter.shared.string(from: 10.0)!
        let actualLiabilityValueString = balanceViewModel.liabilityValueString
        XCTAssertEqual(expectedLiabilityValueString, actualLiabilityValueString)
    }
    
    /// snapshot with 1 assetPositions and 1 liabilityPosition of value 0.0
    func test_getBalanceViewModel_5() throws {
        let sut = DashboardViewModel(snapshotRepository: testingSnapshotRepository)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_getBalanceViewModel_5(using: testingCoreDataStack.context)
        let balanceViewModel = sut.getBalanceViewModel(for: testSnapshot)
        
        let expectedAssetValueString = LocalizedCurrencyFormatter.shared.string(from: 0.0)!
        let actualAssetValueString = balanceViewModel.assetValueString
        XCTAssertEqual(expectedAssetValueString, actualAssetValueString)
        
        let expectedLiabilityValueString = LocalizedCurrencyFormatter.shared.string(from: 0.0)!
        let actualLiabilityValueString = balanceViewModel.liabilityValueString
        XCTAssertEqual(expectedLiabilityValueString, actualLiabilityValueString)
    }
    
    /// snapshot with 1 assetPositions and liabilityPosition of value > 0.0
    func test_getBalanceViewModel_6() throws {
        let sut = DashboardViewModel(snapshotRepository: testingSnapshotRepository)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_getBalanceViewModel_6(using: testingCoreDataStack.context)
        let balanceViewModel = sut.getBalanceViewModel(for: testSnapshot)
        
        let expectedAssetValueString = LocalizedCurrencyFormatter.shared.string(from: 17.01)!
        let actualAssetValueString = balanceViewModel.assetValueString
        XCTAssertEqual(expectedAssetValueString, actualAssetValueString)
        
        let expectedLiabilityValueString = LocalizedCurrencyFormatter.shared.string(from: 17.01)!
        let actualLiabilityValueString = balanceViewModel.liabilityValueString
        XCTAssertEqual(expectedLiabilityValueString, actualLiabilityValueString)
    }
    
    
    
    /// many persisted snapshots covering all scopes
    func test_filteredSnapshots_1() throws {
        let sut = DashboardViewModel(snapshotRepository: testingSnapshotRepository)
        sut.selectedTimeHorizon = .threeMonths
        let (threeMonthSnapshots, sixMonthSnapshots, eighteenMonthSnapshots, allScopeSnapshots) = testDataProvider.createAndPersistTestObjects_filteredSnapshots_1(using: testingCoreDataStack.context)
        
        sut.selectedTimeHorizon = .threeMonths
        var expectedSnapshots = threeMonthSnapshots
        var actualSnapshots = sut.filteredSnapshots
        XCTAssertTrue(expectedSnapshots ≡ actualSnapshots)
        
        sut.selectedTimeHorizon = .sixMonths
        expectedSnapshots = threeMonthSnapshots + sixMonthSnapshots
        actualSnapshots = sut.filteredSnapshots
        XCTAssertTrue(expectedSnapshots ≡ actualSnapshots)
        
        sut.selectedTimeHorizon = .eighteenMonths
        expectedSnapshots = threeMonthSnapshots + sixMonthSnapshots + eighteenMonthSnapshots
        actualSnapshots = sut.filteredSnapshots
        XCTAssertTrue(expectedSnapshots ≡ actualSnapshots)
        
        sut.selectedTimeHorizon = .all
        expectedSnapshots = threeMonthSnapshots + sixMonthSnapshots + eighteenMonthSnapshots + allScopeSnapshots
        actualSnapshots = sut.filteredSnapshots
        XCTAssertTrue(expectedSnapshots ≡ actualSnapshots)
    }
    
    /// no snapshots persisted
    func test_filteredSnapshots_2() throws {
        let sut = DashboardViewModel(snapshotRepository: testingSnapshotRepository)
        let expectedSnapshots: [Snapshot] = []
        let actualSnapshots = sut.filteredSnapshots
        XCTAssertEqual(expectedSnapshots, actualSnapshots)
    }
    
    
    
    /// 1 snapshot persisted
    func test_selectedDate_1() throws {
        let snapshot = testDataProvider.createAndPersistTestObjects_selectedDate_1(using: testingCoreDataStack.context)
        let sut = DashboardViewModel(snapshotRepository: testingSnapshotRepository)
        let calendar = Calendar.current
        let expectedSelectedSnapshot = snapshot
        
        let dateBeforeSnapshot = calendar.date(byAdding: DateComponents(day: -6), to: snapshot.date!)
        sut.selectedDate = dateBeforeSnapshot
        var actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        let dateLongBeforeSnapshot = calendar.date(byAdding: DateComponents(month: -3, day: -6), to: snapshot.date!)
        sut.selectedDate = dateLongBeforeSnapshot
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        let dateAfterSnapshot = calendar.date(byAdding: DateComponents(day: 1), to: snapshot.date!)!
        sut.selectedDate = dateAfterSnapshot
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        let dateLongAfterSnapshot = calendar.date(byAdding: DateComponents(month: 6, day: 2), to: snapshot.date!)
        sut.selectedDate = dateLongAfterSnapshot
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        sut.selectedDate = snapshot.date
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
    }
    
    /// 2 snapshots persisted one month apart
    func test_selectedDate_2() throws {
        let (snapshot_15_03_2024, snapshot_15_04_2024) = testDataProvider.createAndPersistTestObjects_selectedDate_2(using: testingCoreDataStack.context)
        let sut = DashboardViewModel(snapshotRepository: testingSnapshotRepository)
        
        
        let middleDate = DateParser.shared.date(from: "2024-03-30T00:00:00")!
        sut.selectedDate = middleDate
        var expectedSelectedSnapshot = snapshot_15_03_2024
        var actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        
        let dateCloseToMiddleNear_15_03_2024 = DateParser.shared.date(from: "2024-03-29T00:00:00")!
        sut.selectedDate = dateCloseToMiddleNear_15_03_2024
        expectedSelectedSnapshot = snapshot_15_03_2024
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        
        let dateCloseToMiddleNear_15_04_2024 = DateParser.shared.date(from: "2024-03-31T00:00:00")!
        sut.selectedDate = dateCloseToMiddleNear_15_04_2024
        expectedSelectedSnapshot = snapshot_15_04_2024
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        
        let dateNear_15_03_2024 = DateParser.shared.date(from: "2024-03-21T00:00:00")!
        sut.selectedDate = dateNear_15_03_2024
        expectedSelectedSnapshot = snapshot_15_03_2024
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        
        let dateNear_15_04_2024 = DateParser.shared.date(from: "2024-04-08T00:00:00")!
        sut.selectedDate = dateNear_15_04_2024
        expectedSelectedSnapshot = snapshot_15_04_2024
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        
        let dateVeryNear_15_03_2024 = DateParser.shared.date(from: "2024-03-16T00:00:00")!
        sut.selectedDate = dateVeryNear_15_03_2024
        expectedSelectedSnapshot = snapshot_15_03_2024
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        
        let dateVeryNear_15_04_2024 = DateParser.shared.date(from: "2024-04-14T00:00:00")!
        sut.selectedDate = dateVeryNear_15_04_2024
        expectedSelectedSnapshot = snapshot_15_04_2024
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        
        sut.selectedDate = snapshot_15_03_2024.date
        expectedSelectedSnapshot = snapshot_15_03_2024
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        
        sut.selectedDate = snapshot_15_04_2024.date
        expectedSelectedSnapshot = snapshot_15_04_2024
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
    }
    
    /// 3 snapshots persisted several days apart
    func test_selectedDate_3() throws {
        let (snapshot_10_05_2023, snapshot_13_05_2023, snapshot_15_05_2023) = testDataProvider.createAndPersistTestObjects_selectedDate_3(using: testingCoreDataStack.context)
        let sut = DashboardViewModel(snapshotRepository: testingSnapshotRepository)
        
        sut.selectedDate = snapshot_10_05_2023.date
        var expectedSelectedSnapshot = snapshot_10_05_2023
        var actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        let dateNear_10_05_2023 = DateParser.shared.date(from: "2023-05-10T03:30:12")!
        sut.selectedDate = dateNear_10_05_2023
        expectedSelectedSnapshot = snapshot_10_05_2023
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        let dateMiddle_10_05_2023_and_13_05_2023 = DateParser.shared.date(from: "2023-05-11T12:00:00")!
        sut.selectedDate = dateMiddle_10_05_2023_and_13_05_2023
        expectedSelectedSnapshot = snapshot_10_05_2023
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        let dateNear1_13_05_2023 = DateParser.shared.date(from: "2023-05-12T10:55:27")!
        sut.selectedDate = dateNear1_13_05_2023
        expectedSelectedSnapshot = snapshot_13_05_2023
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        sut.selectedDate = snapshot_13_05_2023.date
        expectedSelectedSnapshot = snapshot_13_05_2023
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        let dateNear2_13_05_2023 = DateParser.shared.date(from: "2023-05-13T07:37:42")!
        sut.selectedDate = dateNear2_13_05_2023
        expectedSelectedSnapshot = snapshot_13_05_2023
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        let dateMiddle_13_05_2023_and_15_05_2023 = DateParser.shared.date(from: "2023-05-14T00:00:00")!
        sut.selectedDate = dateMiddle_13_05_2023_and_15_05_2023
        expectedSelectedSnapshot = snapshot_13_05_2023
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        let dateNear_15_05_2023 = DateParser.shared.date(from: "2023-05-14T16:16:01")!
        sut.selectedDate = dateNear_15_05_2023
        expectedSelectedSnapshot = snapshot_15_05_2023
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        sut.selectedDate = snapshot_15_05_2023.date
        expectedSelectedSnapshot = snapshot_15_05_2023
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
    }
    
    /// 3 snapshots persisted several months apart
    func test_selectedDate_4() throws {
        let (snapshot_17_05_2022, snapshot_05_09_2022, snapshot_15_12_2022) = testDataProvider.createAndPersistTestObjects_selectedDate_4(using: testingCoreDataStack.context)
        let sut = DashboardViewModel(snapshotRepository: testingSnapshotRepository)
        
        sut.selectedDate = snapshot_17_05_2022.date
        var expectedSelectedSnapshot = snapshot_17_05_2022
        var actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        let dateNear_17_05_2022 = DateParser.shared.date(from: "2022-06-27T14:27:19")!
        sut.selectedDate = dateNear_17_05_2022
        expectedSelectedSnapshot = snapshot_17_05_2022
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        let dateMiddle_17_05_2022_and_05_09_2022 = DateParser.shared.date(from: "2022-07-06T00:00:00")!
        sut.selectedDate = dateMiddle_17_05_2022_and_05_09_2022
        expectedSelectedSnapshot = snapshot_17_05_2022
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        let dateNear1_05_09_2022 = DateParser.shared.date(from: "2022-07-25T23:47:29")!
        sut.selectedDate = dateNear1_05_09_2022
        expectedSelectedSnapshot = snapshot_05_09_2022
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        sut.selectedDate = snapshot_05_09_2022.date
        expectedSelectedSnapshot = snapshot_05_09_2022
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        let dateNear2_05_09_2022 = DateParser.shared.date(from: "2022-09-29T07:37:42")!
        sut.selectedDate = dateNear2_05_09_2022
        expectedSelectedSnapshot = snapshot_05_09_2022
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        let dateMiddle_05_09_2022_and_15_12_2022 = DateParser.shared.date(from: "2022-10-25T00:00:00")!
        sut.selectedDate = dateMiddle_05_09_2022_and_15_12_2022
        expectedSelectedSnapshot = snapshot_05_09_2022
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        let dateNear_15_12_2022 = DateParser.shared.date(from: "2022-11-17T13:37:11")!
        sut.selectedDate = dateNear_15_12_2022
        expectedSelectedSnapshot = snapshot_15_12_2022
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        sut.selectedDate = snapshot_15_12_2022.date
        expectedSelectedSnapshot = snapshot_15_12_2022
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
    }
    
    /// 16 snapshots persisted each about 1 month apart (realistic spacing)
    func test_selectedDate_5() throws {
        let snapshots = testDataProvider.createAndPersistTestObjects_selectedDate_5(using: testingCoreDataStack.context)
        let sut = DashboardViewModel(snapshotRepository: testingSnapshotRepository)
        
        let snapshot_28_02_2022 = snapshots[0]
        let dateNear_28_02_2022 = DateParser.shared.date(from: "2022-03-06T14:27:19")!
        sut.selectedDate = dateNear_28_02_2022
        var expectedSelectedSnapshot = snapshot_28_02_2022
        var actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        let snapshot_31_05_2023 = snapshots[15]
        let dateNear_31_05_2023 = DateParser.shared.date(from: "2023-05-20T22:02:33")!
        sut.selectedDate = dateNear_31_05_2023
        expectedSelectedSnapshot = snapshot_31_05_2023
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        let snapshot_01_12_2022 = snapshots[9]
        let dateNear_01_12_2022 = DateParser.shared.date(from: "2022-12-13T07:13:51")!
        sut.selectedDate = dateNear_01_12_2022
        expectedSelectedSnapshot = snapshot_01_12_2022
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        let snapshot_31_07_2022 = snapshots[5]
        sut.selectedDate = snapshot_31_07_2022.date
        expectedSelectedSnapshot = snapshot_31_07_2022
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
    }
    
    
    
    /// snapshot with 1 assetPositions and 1 liabilityPosition of value 0.0
    func  test_noPositiveDistributionCategoriesRecorded_1() {
        let snapshot = testDataProvider.createAndPersistTestObjects_noPositiveAssetDistributionCategoriesRecorded_1(using: testingCoreDataStack.context)
        let sut = DashboardViewModel(snapshotRepository: testingSnapshotRepository)
        
        sut.selectedDate = snapshot.date
        XCTAssertTrue(sut.noPositiveAssetDistributionCategoriesRecorded)
        XCTAssertTrue(sut.noPositiveLiabilityDistributionCategoriesRecorded)
    }
    
    /// snapshot with 1 assetPositions and liabilityPosition of value > 0.0
    func  test_noPositiveDistributionCategoriesRecorded_2() {
        let snapshot = testDataProvider.createAndPersistTestObjects_noPositiveAssetDistributionCategoriesRecorded_2(using: testingCoreDataStack.context)
        let sut = DashboardViewModel(snapshotRepository: testingSnapshotRepository)
        
        sut.selectedDate = snapshot.date
        XCTAssertFalse(sut.noPositiveAssetDistributionCategoriesRecorded)
        XCTAssertFalse(sut.noPositiveLiabilityDistributionCategoriesRecorded)
    }
    
    /// selected snapshot with 3 asset pool and 2 liability pools containing one position each (each position  making up >= 5% of respective total value)
    func test_distributionCategories_1() throws {
        let (assetCategories, liabilityCategories) = testDataProvider.createAndPersistTestObjects_distributionCategories_1(using: testingCoreDataStack.context)
        let sut = DashboardViewModel(snapshotRepository: testingSnapshotRepository)
        
        let expectedAssetCategories = assetCategories
        let actualAssetCategories = sut.assetDistributionChartCategories
        
        for category in actualAssetCategories {
            XCTAssertTrue(expectedAssetCategories.contains(where: {$0 == category}))
        }
        XCTAssertEqual(expectedAssetCategories.count, actualAssetCategories.count)
        
        let expectedLiabilityCategories = liabilityCategories
        let actualLiabilityCategories = sut.liabilityDistributionChartCategories
        
        for category in actualLiabilityCategories {
            XCTAssertTrue(expectedLiabilityCategories.contains(where: {$0 == category}))
        }
        XCTAssertEqual(expectedLiabilityCategories.count, actualLiabilityCategories.count)
    }
    
    /// selected snapshot with 3 asset pools and 2 liability pools containing >= 1 position each (each pool making up >= 3% of respective total value)
    func test_distributionCategories_2() throws {
        let (assetCategories, liabilityCategories) = testDataProvider.createAndPersistTestObjects_distributionCategories_2(using: testingCoreDataStack.context)
        let sut = DashboardViewModel(snapshotRepository: testingSnapshotRepository)
        
        let expectedAssetCategories = assetCategories
        let actualAssetCategories = sut.assetDistributionChartCategories
        
        for category in actualAssetCategories {
            XCTAssertTrue(expectedAssetCategories.contains(where: {$0 == category}))
        }
        XCTAssertEqual(expectedAssetCategories.count, actualAssetCategories.count)
        
        let expectedLiabilityCategories = liabilityCategories
        let actualLiabilityCategories = sut.liabilityDistributionChartCategories
        
        for category in actualLiabilityCategories {
            XCTAssertTrue(expectedLiabilityCategories.contains(where: {$0 == category}))
        }
        XCTAssertEqual(expectedLiabilityCategories.count, actualLiabilityCategories.count)
    }
    
    /// selected snapshot with 3 asset pool and 2 liability pools containing >= 1 position each (for both assets/liabilities only one pool making up less than 3% of respective value)
    func test_distributionCategories_3() throws {
        let (assetCategories, liabilityCategories) = testDataProvider.createAndPersistTestObjects_distributionCategories_3(using: testingCoreDataStack.context)
        let sut = DashboardViewModel(snapshotRepository: testingSnapshotRepository)
        
        let expectedAssetCategories = assetCategories
        let actualAssetCategories = sut.assetDistributionChartCategories
        
        for category in actualAssetCategories {
            XCTAssertTrue(expectedAssetCategories.contains(where: {$0 == category}))
        }
        XCTAssertEqual(expectedAssetCategories.count, actualAssetCategories.count)
        
        let expectedLiabilityCategories = liabilityCategories
        let actualLiabilityCategories = sut.liabilityDistributionChartCategories
        
        for category in actualLiabilityCategories {
            XCTAssertTrue(expectedLiabilityCategories.contains(where: {$0 == category}))
        }
        XCTAssertEqual(expectedLiabilityCategories.count, actualLiabilityCategories.count)
    }
    
    /// selected snapshot with multiple pools making up less than 3% for both liabilities and assets
    func test_distributionCategories_4() throws {
        let (assetCategories, liabilityCategories) = testDataProvider.createAndPersistTestObjects_distributionCategories_4(using: testingCoreDataStack.context)
        let sut = DashboardViewModel(snapshotRepository: testingSnapshotRepository)
        
        let expectedAssetCategories = assetCategories
        let actualAssetCategories = sut.assetDistributionChartCategories
        
        for category in actualAssetCategories {
            XCTAssertTrue(expectedAssetCategories.contains(where: {$0 == category}))
        }
        XCTAssertEqual(expectedAssetCategories.count, actualAssetCategories.count)
        
        let expectedLiabilityCategories = liabilityCategories
        let actualLiabilityCategories = sut.liabilityDistributionChartCategories
        
        for category in actualLiabilityCategories {
            XCTAssertTrue(expectedLiabilityCategories.contains(where: {$0 == category}))
        }
        XCTAssertEqual(expectedLiabilityCategories.count, actualLiabilityCategories.count)
    }
    
    /// selected snapshot with no asset pools or liability pools
    func test_distributionCategories_5() throws {
        let (assetCategories, liabilityCategories) = testDataProvider.createAndPersistTestObjects_distributionCategories_5(using: testingCoreDataStack.context)
        let sut = DashboardViewModel(snapshotRepository: testingSnapshotRepository)
        
        let expectedAssetCategories = assetCategories
        let actualAssetCategories = sut.assetDistributionChartCategories
        
        for category in actualAssetCategories {
            XCTAssertTrue(expectedAssetCategories.contains(where: {$0 == category}))
        }
        XCTAssertEqual(expectedAssetCategories.count, actualAssetCategories.count)
        
        let expectedLiabilityCategories = liabilityCategories
        let actualLiabilityCategories = sut.liabilityDistributionChartCategories
        
        for category in actualLiabilityCategories {
            XCTAssertTrue(expectedLiabilityCategories.contains(where: {$0 == category}))
        }
        XCTAssertEqual(expectedLiabilityCategories.count, actualLiabilityCategories.count)
    }
    
    
    
    /// cumulative value falling well within the range that should be attributed to the according category (far away from borders of range)
    func test_setSelectedCategoryForNewCumulativeValue_1() throws {
        let (expectedAssetSelectedCategory, expectedLiabilitySelectedCategory) = testDataProvider.createAndPersistTestObjects_setSelectedCategoryForNewCumulativeValue_1(using: testingCoreDataStack.context)
        
        let sut = DashboardViewModel(snapshotRepository: testingSnapshotRepository)
        
        sut.setSelectedDistributionCategory(for: .assets, with: 39.71)
        let actualAssetSelectedCategory = sut.selectedAssetDistributionCategory
        XCTAssertEqual(expectedAssetSelectedCategory, actualAssetSelectedCategory)
        
        sut.setSelectedDistributionCategory(for: .liabilities, with: 27.11)
        let actualLiabilitySelectedCategory = sut.selectedLiabilityDistributionCategory
        XCTAssertEqual(expectedLiabilitySelectedCategory, actualLiabilitySelectedCategory)
    }
    
    /// last cumulative value that should be attributed to the first category
    func test_setSelectedCategoryForNewCumulativeValue_2() throws {
        let (expectedAssetSelectedCategory, expectedLiabilitySelectedCategory) = testDataProvider.createAndPersistTestObjects_setSelectedCategoryForNewCumulativeValue_2(using: testingCoreDataStack.context)
        
        let sut = DashboardViewModel(snapshotRepository: testingSnapshotRepository)
        
        sut.setSelectedDistributionCategory(for: .assets, with: 20)
        let actualAssetSelectedCategory = sut.selectedAssetDistributionCategory
        XCTAssertEqual(expectedAssetSelectedCategory, actualAssetSelectedCategory)
        
        sut.setSelectedDistributionCategory(for: .liabilities, with: 40)
        let actualLiabilitySelectedCategory = sut.selectedLiabilityDistributionCategory
        XCTAssertEqual(expectedLiabilitySelectedCategory, actualLiabilitySelectedCategory)
    }
    
    
    
    /// snapshot with equal category
    func test_setSelectedDistributionCategoryOnNewSnapshot_1() throws {
        let (
            expectedAssetCategory,
            expectedLiabilityCategory,
            snapshotDate,
        ) = testDataProvider.createAndPersistTestObjects_setSelectedDistributionCategoryOnNewSnapshot_1(using: testingCoreDataStack.context)
        
        let sut = DashboardViewModel(snapshotRepository: testingSnapshotRepository)
        sut.selectedAssetDistributionCategory = expectedAssetCategory
        sut.selectedLiabilityDistributionCategory = expectedLiabilityCategory
        sut.selectedDate = snapshotDate
        
        sut.selectedSnapshotDetailView = .assetDetailView
        sut.setSelectedDistributionCategoryOnNewSnapshot()
        
        let actualSelectedAssetDistributionCategory = sut.selectedAssetDistributionCategory
        XCTAssertEqual(expectedAssetCategory, actualSelectedAssetDistributionCategory)
        
        sut.selectedSnapshotDetailView = .liabilityDetailView
        sut.setSelectedDistributionCategoryOnNewSnapshot()
        
        let actualSelectedLiabilityDistributionCategory = sut.selectedLiabilityDistributionCategory
        XCTAssertEqual(expectedLiabilityCategory, actualSelectedLiabilityDistributionCategory)
    }
    
    /// snapshot with different categories
    func test_setSelectedDistributionCategoryOnNewSnapshot_2() throws {
        let (
            expectedAssetCategory,
            expectedLiabilityCategory,
            snapshotDate,
        ) = testDataProvider.createAndPersistTestObjects_setSelectedDistributionCategoryOnNewSnapshot_2(using: testingCoreDataStack.context)
        
        let sut = DashboardViewModel(snapshotRepository: testingSnapshotRepository)
        var differentAssetCategory = expectedAssetCategory
        differentAssetCategory.pools.removeFirst()
        sut.selectedAssetDistributionCategory = differentAssetCategory
        var differentLiabilityCategory = expectedLiabilityCategory
        differentLiabilityCategory.pools.removeFirst()
        sut.selectedLiabilityDistributionCategory = differentLiabilityCategory
        sut.selectedDate = snapshotDate
        
        sut.selectedSnapshotDetailView = .assetDetailView
        sut.setSelectedDistributionCategoryOnNewSnapshot()
        
        let actualSelectedAssetDistributionCategory = sut.selectedAssetDistributionCategory
        XCTAssertNotEqual(differentAssetCategory, actualSelectedAssetDistributionCategory)
        XCTAssertEqual(expectedAssetCategory, actualSelectedAssetDistributionCategory)
        
        sut.selectedSnapshotDetailView = .liabilityDetailView
        sut.setSelectedDistributionCategoryOnNewSnapshot()
        
        let actualSelectedLiabilityDistributionCategory = sut.selectedLiabilityDistributionCategory
        XCTAssertNotEqual(differentLiabilityCategory, actualSelectedLiabilityDistributionCategory)
        XCTAssertEqual(expectedLiabilityCategory, actualSelectedLiabilityDistributionCategory)
    }
    
    
    
    /// test whether the Snapshot before the last Snapshot is correctly computed
    func test_computeSnapshotBeforeSelectedSnapshot_1() throws {
        let (expectedBeforeSnapshot,selectedSnapshot) = testDataProvider.createAndPersistTestObjects_computeSnapshotBeforeSelectedSnapshot_1(using: testingCoreDataStack.context)
        
        let sut = DashboardViewModel(snapshotRepository: testingSnapshotRepository)
        sut.selectedSnapshot = selectedSnapshot
        
        let actualBeforeSnapshot = sut.computeSnapshotBeforeSelectedSnapshot()
        
        XCTAssertEqual(expectedBeforeSnapshot, actualBeforeSnapshot)
    }
    
    /// test whether the Snapshot before one of the middle Snapshots is correctly computed
    func test_computeSnapshotBeforeSelectedSnapshot_2() throws {
        let (expectedBeforeSnapshot,selectedSnapshot) = testDataProvider.createAndPersistTestObjects_computeSnapshotBeforeSelectedSnapshot_2(using: testingCoreDataStack.context)
        
        let sut = DashboardViewModel(snapshotRepository: testingSnapshotRepository)
        sut.selectedSnapshot = selectedSnapshot
        
        let actualBeforeSnapshot = sut.computeSnapshotBeforeSelectedSnapshot()
        
        XCTAssertEqual(expectedBeforeSnapshot, actualBeforeSnapshot)
    }
    
    /// test whether computing the Snapshot before the last Snapshot correctly returns nil
    func test_computeSnapshotBeforeSelectedSnapshot_3() throws {
        let selectedSnapshot = testDataProvider.createAndPersistTestObjects_computeSnapshotBeforeSelectedSnapshot_3(using: testingCoreDataStack.context)
        
        let sut = DashboardViewModel(snapshotRepository: testingSnapshotRepository)
        sut.selectedSnapshot = selectedSnapshot
        
        let beforeSnapshot = sut.computeSnapshotBeforeSelectedSnapshot()
        
        XCTAssertNil(beforeSnapshot)
    }
    
    
    
    /// test liabilityChangeChartCategories/maxLiabilityChangePercentage for two consecutive Snapshots. The test includes positive, negative and no change  and a case where the category from the earlier snapshot was of value 0
    func test_changeChartCategories_1() throws {
        let (snapshot, expectedChangeCategories, expectedMaxChangePercentage) = testDataProvider.createAndPersistTestObjects_changeChartCategories_1(using: testingCoreDataStack.context)
        let sut = DashboardViewModel(snapshotRepository: testingSnapshotRepository)
        sut.selectedSnapshot = snapshot
        
        let actualChangeCategories = sut.liabilityChangeChartCategories
        let actualMaxChangePercentage = sut.maxLiabilityChangePercentage
        
        XCTAssertTrue(
            checkEquivalence(of: expectedChangeCategories, and: actualChangeCategories) {
                $0.change == $1.change && $0.name == $1.name
            }
        )
        XCTAssertEqual(expectedMaxChangePercentage, actualMaxChangePercentage)
    }
    
    /// test assetChangeChartCategories/maxAssetChangePercentage for two consecutive Snapshots. The test includes positive, negative and no change and a case where the category from the earlier snapshot was of value 0
    func test_changeChartCategories_2() throws {
        let (snapshot, expectedChangeCategories, expectedMaxChangePercentage) = testDataProvider.createAndPersistTestObjects_changeChartCategories_2(using: testingCoreDataStack.context)
        let sut = DashboardViewModel(snapshotRepository: testingSnapshotRepository)
        sut.selectedSnapshot = snapshot
        
        let actualChangeCategories = sut.assetChangeChartCategories
        let actualMaxChangePercentage = sut.maxAssetChangePercentage
        
        XCTAssertTrue(
            checkEquivalence(of: expectedChangeCategories, and: actualChangeCategories) {
                $0.change == $1.change && $0.name == $1.name
            }
        )
        XCTAssertEqual(expectedMaxChangePercentage, actualMaxChangePercentage)
    }
}
