import XCTest
@testable import EquityLab

final class DashboardViewModelTests: XCTestCase {
    private var testingCoreDataStack: TestingCoreDataStack!
    private var testingSnapshotRepository: SnapshotRepository!
    private let testDataProvider = DashboardViewModelTestDataProvider()
    
    override func setUpWithError() throws {
        testingCoreDataStack = TestingCoreDataStack()
        testingSnapshotRepository = SnapshotRepository(context: testingCoreDataStack.context)
    }

    
    
    /// snapshot with no assetPositions
    func test_assetValue_1() throws {
        let sut = DashboardViewModel(repository: testingSnapshotRepository)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_assetValue_1(using: testingCoreDataStack.context)
        let expectedResult = 0.0
        let actualResult = sut.getAssetValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    /// snapshot with 3 assetPosition of value 0.0
    func test_assetValue_2() throws {
        let sut = DashboardViewModel(repository: testingSnapshotRepository)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_assetValue_2(using: testingCoreDataStack.context)
        let expectedResult = 0.0
        let actualResult = sut.getAssetValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    /// snapshot with 5 assetPosition of value > 0.0
    func test_assetValue_3() throws {
        let sut = DashboardViewModel(repository: testingSnapshotRepository)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_assetValue_3(using: testingCoreDataStack.context)
        let expectedResult = 279.34
        let actualResult = sut.getAssetValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    /// snapshot with 2 assetPositions (one with value 0.0 and one with value > 0.0)
    func test_assetValue_4() throws {
        let sut = DashboardViewModel(repository: testingSnapshotRepository)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_assetValue_4(using: testingCoreDataStack.context)
        let expectedResult = 10.0
        let actualResult = sut.getAssetValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    /// snapshot with 1 assetPositions of value 0.0
    func test_assetValue_5() throws {
        let sut = DashboardViewModel(repository: testingSnapshotRepository)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_assetValue_5(using: testingCoreDataStack.context)
        let expectedResult = 0.0
        let actualResult = sut.getAssetValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    /// snapshot with 1 assetPositions of value > 0.0
    func test_assetValue_6() throws {
        let sut = DashboardViewModel(repository: testingSnapshotRepository)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_assetValue_6(using: testingCoreDataStack.context)
        let expectedResult = 17.01
        let actualResult = sut.getAssetValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    
    
    /// snapshot with no liabilityPositions
    func test_liabilityValue_1() throws {
        let sut = DashboardViewModel(repository: testingSnapshotRepository)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_liabilityValue_1(using: testingCoreDataStack.context)
        let expectedResult = 0.0
        let actualResult = sut.getLiabilityValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    /// snapshot with 3 liabilityPositions of value 0.0
    func test_liabilityValue_2() throws {
        let sut = DashboardViewModel(repository: testingSnapshotRepository)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_liabilityValue_2(using: testingCoreDataStack.context)
        let expectedResult = 0.0
        let actualResult = sut.getLiabilityValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    /// snapshot with 5 liabilityPositions of value > 0.0
    func test_liabilityValue_3() throws {
        let sut = DashboardViewModel(repository: testingSnapshotRepository)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_liabilityValue_3(using: testingCoreDataStack.context)
        let expectedResult = 279.34
        let actualResult = sut.getLiabilityValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    /// snapshot with 2 liabilityPositions (one with value 0.0 and one with value > 0.0)
    func test_liabilityValue_4() throws {
        let sut = DashboardViewModel(repository: testingSnapshotRepository)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_liabilityValue_4(using: testingCoreDataStack.context)
        let expectedResult = 10.0
        let actualResult = sut.getLiabilityValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    /// snapshot with 1 liabilityPosition of value 0.0
    func test_liabilityValue_5() throws {
        let sut = DashboardViewModel(repository: testingSnapshotRepository)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_liabilityValue_5(using: testingCoreDataStack.context)
        let expectedResult = 0.0
        let actualResult = sut.getLiabilityValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    /// snapshot with 1 liabilityPosition of value > 0.0
    func test_liabilityValue_6() throws {
        let sut = DashboardViewModel(repository: testingSnapshotRepository)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_liabilityValue_6(using: testingCoreDataStack.context)
        let expectedResult = 17.01
        let actualResult = sut.getLiabilityValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    
    
    /// snapshot with no liabilityPositions
    func test_equityValue_1() throws {
        let sut = DashboardViewModel(repository: testingSnapshotRepository)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_equityValue_1(using: testingCoreDataStack.context)
        let expectedResult = 17.77
        let actualResult = sut.getEquityValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    /// snapshot with no assetPositions
    func test_equityValue_2() throws {
        let sut = DashboardViewModel(repository: testingSnapshotRepository)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_equityValue_2(using: testingCoreDataStack.context)
        let expectedResult = -20.43
        let actualResult = sut.getEquityValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    /// snapshot with 5 assetPositions (value >= 0) and 2 liabilityPositions (value > 0)
    func test_equityValue_3() throws {
        let sut = DashboardViewModel(repository: testingSnapshotRepository)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_equityValue_3(using: testingCoreDataStack.context)
        let expectedResult = 253.91
        let actualResult = sut.getEquityValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult, accuracy: 0.01)
    }
    
    /// snapshot with 10 assetPositions (value > 0) and 7 liabilityPositions (value > 0)
    func test_equityValue_4() throws {
        let sut = DashboardViewModel(repository: testingSnapshotRepository)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_equityValue_4(using: testingCoreDataStack.context)
        let expectedResult = 876.79
        let actualResult = sut.getEquityValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult, accuracy: 0.01)
    }
    
    
    
    /// several asset-/liabilityPools with multipe members
    func test_computeValueByPool_1() throws {
        let sut = DashboardViewModel(repository: testingSnapshotRepository)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_computeValueByPool_1(using: testingCoreDataStack.context)
        
        let resultAssetPoolValueDictionary = sut.computeValueByPool(for: .assets, using: testSnapshot)
        let expectedCashValue = 166.18
        let expectedBankValue = 711.25
        let expectedSecuritiesValue = 870.7
        
        let cashValue = resultAssetPoolValueDictionary["Cash"]
        let bankValue = resultAssetPoolValueDictionary["Bank"]
        let securitiesValue = resultAssetPoolValueDictionary["Securities"]
        XCTAssertNotNil(cashValue)
        XCTAssertNotNil(bankValue)
        XCTAssertNotNil(securitiesValue)
        let actualCashValue = cashValue!
        let actualBankValue = bankValue!
        let actualSecuritiesValue = securitiesValue!
        
        XCTAssertEqual(expectedCashValue, actualCashValue, accuracy: 0.01)
        XCTAssertEqual(expectedBankValue, actualBankValue, accuracy: 0.01)
        XCTAssertEqual(expectedSecuritiesValue, actualSecuritiesValue, accuracy: 0.01)
        
        let expectedAssetPoolKeyNumber = 3
        let actualAssetPoolKeyNumber = resultAssetPoolValueDictionary.keys.count
        XCTAssertEqual(expectedAssetPoolKeyNumber, actualAssetPoolKeyNumber)
        
        let resultLiabilityPoolValueDictionary = sut.computeValueByPool(for: .liabilities, using: testSnapshot)
        let expectedPrivateValue = 225.75
        let expectedBusinessValue = 530.35
        
        let privateValue = resultLiabilityPoolValueDictionary["Private"]
        let businessValue = resultLiabilityPoolValueDictionary["Business"]
        XCTAssertNotNil(privateValue)
        XCTAssertNotNil(businessValue)
        let actualPrivateValue = privateValue!
        let actualBusinessValue = businessValue!
        
        XCTAssertEqual(expectedPrivateValue, actualPrivateValue, accuracy: 0.01)
        XCTAssertEqual(expectedBusinessValue, actualBusinessValue, accuracy: 0.01)
        
        let expectedLiabilityPoolKeyNumber = 2
        let actualLiabilityPoolKeyNumber = resultLiabilityPoolValueDictionary.keys.count
        XCTAssertEqual(expectedLiabilityPoolKeyNumber, actualLiabilityPoolKeyNumber)
    }
    
    /// no asset-/liabilityPools
    func test_computeValueByPool_2() throws {
        let sut = DashboardViewModel(repository: testingSnapshotRepository)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_computeValueByPool_2(using: testingCoreDataStack.context)
        
        let resultAssetPoolValueDictionary = sut.computeValueByPool(for: .assets, using: testSnapshot)
        let expectedAssetPoolKeyNumber = 0
        let actualAssetPoolKeyNumber = resultAssetPoolValueDictionary.keys.count
        XCTAssertEqual(expectedAssetPoolKeyNumber, actualAssetPoolKeyNumber)
        
        let resultLiabilityPoolValueDictionary = sut.computeValueByPool(for: .liabilities, using: testSnapshot)
        let expectedLiabilityPoolKeyNumber = 0
        let actualLiabilityPoolKeyNumber = resultLiabilityPoolValueDictionary.keys.count
        XCTAssertEqual(expectedLiabilityPoolKeyNumber, actualLiabilityPoolKeyNumber)
    }
    
    /// one asset-/liabilityPools with one position respectively (value > 0)
    func test_computeValueByPool_3() throws {
        let sut = DashboardViewModel(repository: testingSnapshotRepository)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_computeValueByPool_3(using: testingCoreDataStack.context)
        
        let resultAssetPoolValueDictionary = sut.computeValueByPool(for: .assets, using: testSnapshot)
        let expectedCashValue = 5.75
        
        let cashValue = resultAssetPoolValueDictionary["Cash"]
        XCTAssertNotNil(cashValue)
        let actualCashValue = cashValue!
        
        XCTAssertEqual(expectedCashValue, actualCashValue, accuracy: 0.01)

        let expectedAssetPoolKeyNumber = 1
        let actualAssetPoolKeyNumber = resultAssetPoolValueDictionary.keys.count
        XCTAssertEqual(expectedAssetPoolKeyNumber, actualAssetPoolKeyNumber)
        
        let resultLiabilityPoolValueDictionary = sut.computeValueByPool(for: .liabilities, using: testSnapshot)
        let expectedPrivateValue = 120.99
        
        let privateValue = resultLiabilityPoolValueDictionary["Private"]
        XCTAssertNotNil(privateValue)
        let actualPrivateValue = privateValue!
        
        XCTAssertEqual(expectedPrivateValue, actualPrivateValue, accuracy: 0.01)
        
        let expectedLiabilityPoolKeyNumber = 1
        let actualLiabilityPoolKeyNumber = resultLiabilityPoolValueDictionary.keys.count
        XCTAssertEqual(expectedLiabilityPoolKeyNumber, actualLiabilityPoolKeyNumber)
    }
    
    /// one asset-/liabilityPools with one position respectively (value == 0)
    func test_computeValueByPool_4() throws {
        let sut = DashboardViewModel(repository: testingSnapshotRepository)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_computeValueByPool_4(using: testingCoreDataStack.context)
        
        let resultAssetPoolValueDictionary = sut.computeValueByPool(for: .assets, using: testSnapshot)
        let expectedCashValue = 0.0
        
        let cashValue = resultAssetPoolValueDictionary["Cash"]
        XCTAssertNotNil(cashValue)
        let actualCashValue = cashValue!
        
        XCTAssertEqual(expectedCashValue, actualCashValue, accuracy: 0.01)

        let expectedAssetPoolKeyNumber = 1
        let actualAssetPoolKeyNumber = resultAssetPoolValueDictionary.keys.count
        XCTAssertEqual(expectedAssetPoolKeyNumber, actualAssetPoolKeyNumber)
        
        let resultLiabilityPoolValueDictionary = sut.computeValueByPool(for: .liabilities, using: testSnapshot)
        let expectedPrivateValue = 0.0
        
        let privateValue = resultLiabilityPoolValueDictionary["Private"]
        XCTAssertNotNil(privateValue)
        let actualPrivateValue = privateValue!
        
        XCTAssertEqual(expectedPrivateValue, actualPrivateValue, accuracy: 0.01)
        
        let expectedLiabilityPoolKeyNumber = 1
        let actualLiabilityPoolKeyNumber = resultLiabilityPoolValueDictionary.keys.count
        XCTAssertEqual(expectedLiabilityPoolKeyNumber, actualLiabilityPoolKeyNumber)
    }
    
    /// one asset-/liabilityPools with two positions respectively (value == 0)
    func test_computeValueByPool_5() throws {
        let sut = DashboardViewModel(repository: testingSnapshotRepository)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_computeValueByPool_5(using: testingCoreDataStack.context)
        
        let resultAssetPoolValueDictionary = sut.computeValueByPool(for: .assets, using: testSnapshot)
        let expectedCashValue = 0.0
        
        let cashValue = resultAssetPoolValueDictionary["Cash"]
        XCTAssertNotNil(cashValue)
        let actualCashValue = cashValue!
        
        XCTAssertEqual(expectedCashValue, actualCashValue, accuracy: 0.01)

        let expectedAssetPoolKeyNumber = 1
        let actualAssetPoolKeyNumber = resultAssetPoolValueDictionary.keys.count
        XCTAssertEqual(expectedAssetPoolKeyNumber, actualAssetPoolKeyNumber)
        
        let resultLiabilityPoolValueDictionary = sut.computeValueByPool(for: .liabilities, using: testSnapshot)
        let expectedPrivateValue = 0.0
        
        let privateValue = resultLiabilityPoolValueDictionary["Private"]
        XCTAssertNotNil(privateValue)
        let actualPrivateValue = privateValue!
        
        XCTAssertEqual(expectedPrivateValue, actualPrivateValue, accuracy: 0.01)
        
        let expectedLiabilityPoolKeyNumber = 1
        let actualLiabilityPoolKeyNumber = resultLiabilityPoolValueDictionary.keys.count
        XCTAssertEqual(expectedLiabilityPoolKeyNumber, actualLiabilityPoolKeyNumber)
    }
    
    
    
    /// many persisted snapshots covering all scopes
    func test_filteredSnapshots_1() throws {
        let sut = DashboardViewModel(repository: testingSnapshotRepository)
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
        let sut = DashboardViewModel(repository: testingSnapshotRepository)
        let expectedSnapshots: [Snapshot] = []
        let actualSnapshots = sut.filteredSnapshots
        XCTAssertEqual(expectedSnapshots, actualSnapshots)
    }
    
    
    
    /// 1 snapshot persisted
    func test_selectedDate_1() throws {
        let snapshot = testDataProvider.createAndPersistTestObjects_selectedDate_1(using: testingCoreDataStack.context)
        let sut = DashboardViewModel(repository: testingSnapshotRepository)
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
        let sut = DashboardViewModel(repository: testingSnapshotRepository)
        
        
        let middleDate = DateParser.shared.date(from: "2024-03-30T00:00:00Z")!
        sut.selectedDate = middleDate
        var expectedSelectedSnapshot = snapshot_15_03_2024
        var actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        
        let dateCloseToMiddleNear_15_03_2024 = DateParser.shared.date(from: "2024-03-29T00:00:00Z")!
        sut.selectedDate = dateCloseToMiddleNear_15_03_2024
        expectedSelectedSnapshot = snapshot_15_03_2024
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        
        let dateCloseToMiddleNear_15_04_2024 = DateParser.shared.date(from: "2024-03-31T00:00:00Z")!
        sut.selectedDate = dateCloseToMiddleNear_15_04_2024
        expectedSelectedSnapshot = snapshot_15_04_2024
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        
        let dateNear_15_03_2024 = DateParser.shared.date(from: "2024-03-21T00:00:00Z")!
        sut.selectedDate = dateNear_15_03_2024
        expectedSelectedSnapshot = snapshot_15_03_2024
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        
        let dateNear_15_04_2024 = DateParser.shared.date(from: "2024-04-08T00:00:00Z")!
        sut.selectedDate = dateNear_15_04_2024
        expectedSelectedSnapshot = snapshot_15_04_2024
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        
        let dateVeryNear_15_03_2024 = DateParser.shared.date(from: "2024-03-16T00:00:00Z")!
        sut.selectedDate = dateVeryNear_15_03_2024
        expectedSelectedSnapshot = snapshot_15_03_2024
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        
        let dateVeryNear_15_04_2024 = DateParser.shared.date(from: "2024-04-14T00:00:00Z")!
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
        let sut = DashboardViewModel(repository: testingSnapshotRepository)
        
        sut.selectedDate = snapshot_10_05_2023.date
        var expectedSelectedSnapshot = snapshot_10_05_2023
        var actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        let dateNear_10_05_2023 = DateParser.shared.date(from: "2023-05-10T03:30:12Z")!
        sut.selectedDate = dateNear_10_05_2023
        expectedSelectedSnapshot = snapshot_10_05_2023
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        let dateMiddle_10_05_2023_and_13_05_2023 = DateParser.shared.date(from: "2023-05-11T12:00:00Z")!
        sut.selectedDate = dateMiddle_10_05_2023_and_13_05_2023
        expectedSelectedSnapshot = snapshot_10_05_2023
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        let dateNear1_13_05_2023 = DateParser.shared.date(from: "2023-05-12T10:55:27Z")!
        sut.selectedDate = dateNear1_13_05_2023
        expectedSelectedSnapshot = snapshot_13_05_2023
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        sut.selectedDate = snapshot_13_05_2023.date
        expectedSelectedSnapshot = snapshot_13_05_2023
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        let dateNear2_13_05_2023 = DateParser.shared.date(from: "2023-05-13T07:37:42Z")!
        sut.selectedDate = dateNear2_13_05_2023
        expectedSelectedSnapshot = snapshot_13_05_2023
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        let dateMiddle_13_05_2023_and_15_05_2023 = DateParser.shared.date(from: "2023-05-14T00:00:00Z")!
        sut.selectedDate = dateMiddle_13_05_2023_and_15_05_2023
        expectedSelectedSnapshot = snapshot_13_05_2023
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        let dateNear_15_05_2023 = DateParser.shared.date(from: "2023-05-14T16:16:01Z")!
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
        let sut = DashboardViewModel(repository: testingSnapshotRepository)
        
        sut.selectedDate = snapshot_17_05_2022.date
        var expectedSelectedSnapshot = snapshot_17_05_2022
        var actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        let dateNear_17_05_2022 = DateParser.shared.date(from: "2022-06-27T14:27:19Z")!
        sut.selectedDate = dateNear_17_05_2022
        expectedSelectedSnapshot = snapshot_17_05_2022
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        let dateMiddle_17_05_2022_and_05_09_2022 = DateParser.shared.date(from: "2022-07-06T00:00:00Z")!
        sut.selectedDate = dateMiddle_17_05_2022_and_05_09_2022
        expectedSelectedSnapshot = snapshot_17_05_2022
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        let dateNear1_05_09_2022 = DateParser.shared.date(from: "2022-07-25T23:47:29Z")!
        sut.selectedDate = dateNear1_05_09_2022
        expectedSelectedSnapshot = snapshot_05_09_2022
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        sut.selectedDate = snapshot_05_09_2022.date
        expectedSelectedSnapshot = snapshot_05_09_2022
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        let dateNear2_05_09_2022 = DateParser.shared.date(from: "2022-09-29T07:37:42Z")!
        sut.selectedDate = dateNear2_05_09_2022
        expectedSelectedSnapshot = snapshot_05_09_2022
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        let dateMiddle_05_09_2022_and_15_12_2022 = DateParser.shared.date(from: "2022-10-25T00:00:00Z")!
        sut.selectedDate = dateMiddle_05_09_2022_and_15_12_2022
        expectedSelectedSnapshot = snapshot_05_09_2022
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        let dateNear_15_12_2022 = DateParser.shared.date(from: "2022-11-17T13:37:11Z")!
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
        let sut = DashboardViewModel(repository: testingSnapshotRepository)
        
        let snapshot_28_02_2022 = snapshots[0]
        let dateNear_28_02_2022 = DateParser.shared.date(from: "2022-03-06T14:27:19Z")!
        sut.selectedDate = dateNear_28_02_2022
        var expectedSelectedSnapshot = snapshot_28_02_2022
        var actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        let snapshot_31_05_2023 = snapshots[15]
        let dateNear_31_05_2023 = DateParser.shared.date(from: "2023-05-20T22:02:33Z")!
        sut.selectedDate = dateNear_31_05_2023
        expectedSelectedSnapshot = snapshot_31_05_2023
        actualSelectedSnapshot = try XCTUnwrap(sut.selectedSnapshot)
        XCTAssertEqual(expectedSelectedSnapshot, actualSelectedSnapshot)
        
        let snapshot_01_12_2022 = snapshots[9]
        let dateNear_01_12_2022 = DateParser.shared.date(from: "2022-12-13T07:13:51Z")!
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
}
