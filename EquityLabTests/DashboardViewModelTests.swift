import XCTest
@testable import EquityLab
import CoreData

final class DashboardViewModelTests: XCTestCase {
    private var testingCoreDataStack: TestingCoreDataStack!
    private let testDataProvider = TestDataProvider()
    
    
    override func setUpWithError() throws {
        testingCoreDataStack = TestingCoreDataStack()
    }

    override func tearDownWithError() throws {
        testingCoreDataStack = nil
    }

    
    
    /// snapshot with no assetPositions
    func test_assetValue_1() throws {
        let sut = DashboardViewModel(context: testingCoreDataStack.context)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_assetValue_1(using: testingCoreDataStack.context)
        let expectedResult = 0.0
        let actualResult = sut.getAssetValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    /// snapshot with 3 assetPosition of value 0.0
    func test_assetValue_2() throws {
        let sut = DashboardViewModel(context: testingCoreDataStack.context)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_assetValue_2(using: testingCoreDataStack.context)
        let expectedResult = 0.0
        let actualResult = sut.getAssetValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    /// snapshot with 5 assetPosition of value > 0.0
    func test_assetValue_3() throws {
        let sut = DashboardViewModel(context: testingCoreDataStack.context)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_assetValue_3(using: testingCoreDataStack.context)
        let expectedResult = 279.34
        let actualResult = sut.getAssetValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    /// snapshot with 2 assetPositions (one with value 0.0 and one with value > 0.0)
    func test_assetValue_4() throws {
        let sut = DashboardViewModel(context: testingCoreDataStack.context)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_assetValue_4(using: testingCoreDataStack.context)
        let expectedResult = 10.0
        let actualResult = sut.getAssetValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    /// snapshot with 1 assetPositions of value 0.0
    func test_assetValue_5() throws {
        let sut = DashboardViewModel(context: testingCoreDataStack.context)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_assetValue_5(using: testingCoreDataStack.context)
        let expectedResult = 0.0
        let actualResult = sut.getAssetValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    /// snapshot with 1 assetPositions of value > 0.0
    func test_assetValue_6() throws {
        let sut = DashboardViewModel(context: testingCoreDataStack.context)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_assetValue_6(using: testingCoreDataStack.context)
        let expectedResult = 17.01
        let actualResult = sut.getAssetValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    
    
    /// snapshot with no liabilityPositions
    func test_liabilityValue_1() throws {
        let sut = DashboardViewModel(context: testingCoreDataStack.context)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_liabilityValue_1(using: testingCoreDataStack.context)
        let expectedResult = 0.0
        let actualResult = sut.getLiabilityValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    /// snapshot with 3 liabilityPositions of value 0.0
    func test_liabilityValue_2() throws {
        let sut = DashboardViewModel(context: testingCoreDataStack.context)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_liabilityValue_2(using: testingCoreDataStack.context)
        let expectedResult = 0.0
        let actualResult = sut.getLiabilityValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    /// snapshot with 5 liabilityPositions of value > 0.0
    func test_liabilityValue_3() throws {
        let sut = DashboardViewModel(context: testingCoreDataStack.context)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_liabilityValue_3(using: testingCoreDataStack.context)
        let expectedResult = 279.34
        let actualResult = sut.getLiabilityValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    /// snapshot with 2 liabilityPositions (one with value 0.0 and one with value > 0.0)
    func test_liabilityValue_4() throws {
        let sut = DashboardViewModel(context: testingCoreDataStack.context)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_liabilityValue_4(using: testingCoreDataStack.context)
        let expectedResult = 10.0
        let actualResult = sut.getLiabilityValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    /// snapshot with 1 liabilityPosition of value 0.0
    func test_liabilityValue_5() throws {
        let sut = DashboardViewModel(context: testingCoreDataStack.context)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_liabilityValue_5(using: testingCoreDataStack.context)
        let expectedResult = 0.0
        let actualResult = sut.getLiabilityValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    /// snapshot with 1 liabilityPosition of value > 0.0
    func test_liabilityValue_6() throws {
        let sut = DashboardViewModel(context: testingCoreDataStack.context)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_liabilityValue_6(using: testingCoreDataStack.context)
        let expectedResult = 17.01
        let actualResult = sut.getLiabilityValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    
    
    /// snapshot with no liabilityPositions
    func test_equityValue_1() throws {
        let sut = DashboardViewModel(context: testingCoreDataStack.context)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_equityValue_1(using: testingCoreDataStack.context)
        let expectedResult = 17.77
        let actualResult = sut.getEquityValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    /// snapshot with no assetPositions
    func test_equityValue_2() throws {
        let sut = DashboardViewModel(context: testingCoreDataStack.context)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_equityValue_2(using: testingCoreDataStack.context)
        let expectedResult = -20.43
        let actualResult = sut.getEquityValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    /// snapshot with 5 assetPositions (value >= 0) and 2 liabilityPositions (value > 0)
    func test_equityValue_3() throws {
        let sut = DashboardViewModel(context: testingCoreDataStack.context)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_equityValue_3(using: testingCoreDataStack.context)
        let expectedResult = 253.91
        let actualResult = sut.getEquityValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult, accuracy: 0.01)
    }
    
    /// snapshot with 10 assetPositions (value > 0) and 7 liabilityPositions (value > 0)
    func test_equityValue_4() throws {
        let sut = DashboardViewModel(context: testingCoreDataStack.context)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_equityValue_4(using: testingCoreDataStack.context)
        let expectedResult = 876.79
        let actualResult = sut.getEquityValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult, accuracy: 0.01)
    }
    
    
    
    /// several asset-/liabilityPools with multipe members
    func test_computeValueByPool_1() throws {
        let sut = DashboardViewModel(context: testingCoreDataStack.context)
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
        let sut = DashboardViewModel(context: testingCoreDataStack.context)
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
        let sut = DashboardViewModel(context: testingCoreDataStack.context)
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
        let sut = DashboardViewModel(context: testingCoreDataStack.context)
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
        let sut = DashboardViewModel(context: testingCoreDataStack.context)
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
        let sut = DashboardViewModel(context: testingCoreDataStack.context)
        sut.selectedTimeHorizon = .threeMonths
        let (threeMonthSnapshots, sixMonthSnapshots, eighteenMonthSnapshots, allScopeSnapshots) = testDataProvider.createAndPersistTestObjects_filteredSnapshots_1(using: testingCoreDataStack.context)
        
        sut.selectedTimeHorizon = .threeMonths
        var expectedSnapshots = threeMonthSnapshots
        var actualSnapshots = sut.filteredSnapshots
        XCTAssertEqual(Set(expectedSnapshots), Set(actualSnapshots))
        
        sut.selectedTimeHorizon = .sixMonths
        expectedSnapshots = threeMonthSnapshots + sixMonthSnapshots
        actualSnapshots = sut.filteredSnapshots
        XCTAssertEqual(Set(expectedSnapshots), Set(actualSnapshots))
        
        sut.selectedTimeHorizon = .eighteenMonths
        expectedSnapshots = threeMonthSnapshots + sixMonthSnapshots + eighteenMonthSnapshots
        actualSnapshots = sut.filteredSnapshots
        XCTAssertEqual(Set(expectedSnapshots), Set(actualSnapshots))
        
        sut.selectedTimeHorizon = .all
        expectedSnapshots = threeMonthSnapshots + sixMonthSnapshots + eighteenMonthSnapshots + allScopeSnapshots
        actualSnapshots = sut.filteredSnapshots
        XCTAssertEqual(Set(expectedSnapshots), Set(actualSnapshots))
    }
    
    /// no snapshots persisted
    func test_filteredSnapshots_2() throws {
        let sut = DashboardViewModel(context: testingCoreDataStack.context)
        let expectedSnapshots: [Snapshot] = []
        let actualSnapshots = sut.filteredSnapshots
        XCTAssertEqual(expectedSnapshots, actualSnapshots)
    }
}
