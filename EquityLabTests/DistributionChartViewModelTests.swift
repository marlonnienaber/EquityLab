import XCTest
@testable import EquityLab

final class DistributionChartViewModelTests: XCTestCase {
    private var testingCoreDataStack: TestingCoreDataStack!
    private var testingSnapshotRepository: SnapshotRepository!
    private let testDataProvider = TestDataProvider()
    
    override func setUpWithError() throws {
        testingCoreDataStack = TestingCoreDataStack()
        testingSnapshotRepository = SnapshotRepository(context: testingCoreDataStack.context)
    }
    
    
    
    /// selected snapshot with 3 asset pool and 2 liability pools containing one position each (each position  making up >= 5% of respective total value)
    func test_distributionCategories_1() throws {
        let (assetCategories, liabilityCategories) = testDataProvider.createAndPersistTestObjects_distributionCategories_1(using: testingCoreDataStack.context)
        
        let dashboardViewModel = DashboardViewModel(repository: testingSnapshotRepository)
        var sut = DistributionChartViewModel(distributionChartType: .assetDistributionChart,
                                             dashboardViewModel: dashboardViewModel,
                                             repository: testingSnapshotRepository)
        
        let expectedAssetCategories = assetCategories
        let actualAssetCategories = sut.distributionCategories
        
        for category in actualAssetCategories {
            XCTAssertTrue(expectedAssetCategories.contains(where: {$0 == category}))
        }
        XCTAssertEqual(expectedAssetCategories.count, actualAssetCategories.count)
        
        sut = DistributionChartViewModel(distributionChartType: .liabilityDistributionChart,
                                         dashboardViewModel: dashboardViewModel,
                                         repository: testingSnapshotRepository)
        
        let expectedLiabilityCategories = liabilityCategories
        let actualLiabilityCategories = sut.distributionCategories
        
        for category in actualLiabilityCategories {
            XCTAssertTrue(expectedLiabilityCategories.contains(where: {$0 == category}))
        }
        XCTAssertEqual(expectedLiabilityCategories.count, actualLiabilityCategories.count)
    }
    
    /// selected snapshot with 3 asset pools and 2 liability pools containing >= 1 position each (each pool making up >= 3% of respective total value)
    func test_distributionCategories_2() throws {
        let (assetCategories, liabilityCategories) = testDataProvider.createAndPersistTestObjects_distributionCategories_2(using: testingCoreDataStack.context)
        
        let dashboardViewModel = DashboardViewModel(repository: testingSnapshotRepository)
        var sut = DistributionChartViewModel(distributionChartType: .assetDistributionChart,
                                             dashboardViewModel: dashboardViewModel,
                                             repository: testingSnapshotRepository)
        
        let expectedAssetCategories = assetCategories
        let actualAssetCategories = sut.distributionCategories
        
        for category in actualAssetCategories {
            XCTAssertTrue(expectedAssetCategories.contains(where: {$0 == category}))
        }
        XCTAssertEqual(expectedAssetCategories.count, actualAssetCategories.count)
        
        sut = DistributionChartViewModel(distributionChartType: .liabilityDistributionChart,
                                         dashboardViewModel: dashboardViewModel,
                                         repository: testingSnapshotRepository)
        
        let expectedLiabilityCategories = liabilityCategories
        let actualLiabilityCategories = sut.distributionCategories
        
        for category in actualLiabilityCategories {
            XCTAssertTrue(expectedLiabilityCategories.contains(where: {$0 == category}))
        }
        XCTAssertEqual(expectedLiabilityCategories.count, actualLiabilityCategories.count)
    }
    
    /// selected snapshot with 3 asset pool and 2 liability pools containing >= 1 position each (for both assets/liabilities only one pool making up less than 3% of respective value)
    func test_distributionCategories_3() throws {
        let (assetCategories, liabilityCategories) = testDataProvider.createAndPersistTestObjects_distributionCategories_3(using: testingCoreDataStack.context)
        
        let dashboardViewModel = DashboardViewModel(repository: testingSnapshotRepository)
        var sut = DistributionChartViewModel(distributionChartType: .assetDistributionChart,
                                             dashboardViewModel: dashboardViewModel,
                                             repository: testingSnapshotRepository)
        
        let expectedAssetCategories = assetCategories
        let actualAssetCategories = sut.distributionCategories
        
        for category in actualAssetCategories {
            XCTAssertTrue(expectedAssetCategories.contains(where: {$0 == category}))
        }
        XCTAssertEqual(expectedAssetCategories.count, actualAssetCategories.count)
        
        sut = DistributionChartViewModel(distributionChartType: .liabilityDistributionChart,
                                         dashboardViewModel: dashboardViewModel,
                                         repository: testingSnapshotRepository)
        
        let expectedLiabilityCategories = liabilityCategories
        let actualLiabilityCategories = sut.distributionCategories
        
        for category in actualLiabilityCategories {
            XCTAssertTrue(expectedLiabilityCategories.contains(where: {$0 == category}))
        }
        XCTAssertEqual(expectedLiabilityCategories.count, actualLiabilityCategories.count)
    }
    
    /// selected snapshot with multiple pools making up less than 3% for both liabilities and assets
    func test_distributionCategories_4() throws {
        let (assetCategories, liabilityCategories) = testDataProvider.createAndPersistTestObjects_distributionCategories_4(using: testingCoreDataStack.context)
        
        let dashboardViewModel = DashboardViewModel(repository: testingSnapshotRepository)
        var sut = DistributionChartViewModel(distributionChartType: .assetDistributionChart,
                                             dashboardViewModel: dashboardViewModel,
                                             repository: testingSnapshotRepository)
        
        let expectedAssetCategories = assetCategories
        let actualAssetCategories = sut.distributionCategories
        
        for category in actualAssetCategories {
            XCTAssertTrue(expectedAssetCategories.contains(where: {$0 == category}))
        }
        XCTAssertEqual(expectedAssetCategories.count, actualAssetCategories.count)
        
        sut = DistributionChartViewModel(distributionChartType: .liabilityDistributionChart,
                                         dashboardViewModel: dashboardViewModel,
                                         repository: testingSnapshotRepository)
        
        let expectedLiabilityCategories = liabilityCategories
        let actualLiabilityCategories = sut.distributionCategories
        
        for category in actualLiabilityCategories {
            XCTAssertTrue(expectedLiabilityCategories.contains(where: {$0 == category}))
        }
        XCTAssertEqual(expectedLiabilityCategories.count, actualLiabilityCategories.count)
    }
    
    /// selected snapshot with no asset pools or liability pools
    func test_distributionCategories_5() throws {
        let (assetCategories, liabilityCategories) = testDataProvider.createAndPersistTestObjects_distributionCategories_5(using: testingCoreDataStack.context)
        
        let dashboardViewModel = DashboardViewModel(repository: testingSnapshotRepository)
        var sut = DistributionChartViewModel(distributionChartType: .assetDistributionChart,
                                             dashboardViewModel: dashboardViewModel,
                                             repository: testingSnapshotRepository)
        
        let expectedAssetCategories = assetCategories
        let actualAssetCategories = sut.distributionCategories
        
        for category in actualAssetCategories {
            XCTAssertTrue(expectedAssetCategories.contains(where: {$0 == category}))
        }
        XCTAssertEqual(expectedAssetCategories.count, actualAssetCategories.count)
        
        sut = DistributionChartViewModel(distributionChartType: .liabilityDistributionChart,
                                         dashboardViewModel: dashboardViewModel,
                                         repository: testingSnapshotRepository)
        
        let expectedLiabilityCategories = liabilityCategories
        let actualLiabilityCategories = sut.distributionCategories
        
        for category in actualLiabilityCategories {
            XCTAssertTrue(expectedLiabilityCategories.contains(where: {$0 == category}))
        }
        XCTAssertEqual(expectedLiabilityCategories.count, actualLiabilityCategories.count)
    }
    
    
    
    /// snapshot with only one asset/liability pool containing one position respectively
    func test_computeTotalValue_1() throws {
        let (snapshot, expectedTotalAssetValue, expectedTotalLiabilityValue) = testDataProvider.createAndPersistTestObjects_computeTotalValue_1(using: testingCoreDataStack.context)
        
        let dashboardViewModel = DashboardViewModel(repository: testingSnapshotRepository)
        
        var sut = DistributionChartViewModel(distributionChartType: .assetDistributionChart,
                                             dashboardViewModel: dashboardViewModel,
                                             repository: testingSnapshotRepository)
        let actualTotalAssetValue = sut.computeTotalValue(for: snapshot)
        XCTAssertEqual(expectedTotalAssetValue, actualTotalAssetValue, accuracy: 0.01)
        
        sut = DistributionChartViewModel(distributionChartType: .liabilityDistributionChart,
                                         dashboardViewModel: dashboardViewModel,
                                         repository: testingSnapshotRepository)
        let actualTotalLiabilityValue = sut.computeTotalValue(for: snapshot)
        XCTAssertEqual(expectedTotalLiabilityValue, actualTotalLiabilityValue, accuracy: 0.01)
    }
    
    /// snapshot with only one asset/liability pool containing multiple position respectively
    func test_computeTotalValue_2() throws {
        let (snapshot, expectedTotalAssetValue, expectedTotalLiabilityValue) = testDataProvider.createAndPersistTestObjects_computeTotalValue_2(using: testingCoreDataStack.context)
        
        let dashboardViewModel = DashboardViewModel(repository: testingSnapshotRepository)
        
        var sut = DistributionChartViewModel(distributionChartType: .assetDistributionChart,
                                             dashboardViewModel: dashboardViewModel,
                                             repository: testingSnapshotRepository)
        let actualTotalAssetValue = sut.computeTotalValue(for: snapshot)
        XCTAssertEqual(expectedTotalAssetValue, actualTotalAssetValue, accuracy: 0.01)
        
        sut = DistributionChartViewModel(distributionChartType: .liabilityDistributionChart,
                                         dashboardViewModel: dashboardViewModel,
                                         repository: testingSnapshotRepository)
        let actualTotalLiabilityValue = sut.computeTotalValue(for: snapshot)
        XCTAssertEqual(expectedTotalLiabilityValue, actualTotalLiabilityValue, accuracy: 0.01)
    }
    
    /// snapshot with multiple asset/liability pool containing multiple position respectively
    func test_computeTotalValue_3() throws {
        let (snapshot, expectedTotalAssetValue, expectedTotalLiabilityValue) = testDataProvider.createAndPersistTestObjects_computeTotalValue_3(using: testingCoreDataStack.context)
        
        let dashboardViewModel = DashboardViewModel(repository: testingSnapshotRepository)
        
        var sut = DistributionChartViewModel(distributionChartType: .assetDistributionChart,
                                             dashboardViewModel: dashboardViewModel,
                                             repository: testingSnapshotRepository)
        let actualTotalAssetValue = sut.computeTotalValue(for: snapshot)
        XCTAssertEqual(expectedTotalAssetValue, actualTotalAssetValue, accuracy: 0.01)
        
        sut = DistributionChartViewModel(distributionChartType: .liabilityDistributionChart,
                                         dashboardViewModel: dashboardViewModel,
                                         repository: testingSnapshotRepository)
        let actualTotalLiabilityValue = sut.computeTotalValue(for: snapshot)
        XCTAssertEqual(expectedTotalLiabilityValue, actualTotalLiabilityValue, accuracy: 0.01)
    }
    
    /// snapshot with multiple asset/liability pool containing multiple position respectively. At least one pool has value 0.
    func test_computeTotalValue_4() throws {
        let (snapshot, expectedTotalAssetValue, expectedTotalLiabilityValue) = testDataProvider.createAndPersistTestObjects_computeTotalValue_4(using: testingCoreDataStack.context)
        
        let dashboardViewModel = DashboardViewModel(repository: testingSnapshotRepository)
        
        var sut = DistributionChartViewModel(distributionChartType: .assetDistributionChart,
                                             dashboardViewModel: dashboardViewModel,
                                             repository: testingSnapshotRepository)
        let actualTotalAssetValue = sut.computeTotalValue(for: snapshot)
        XCTAssertEqual(expectedTotalAssetValue, actualTotalAssetValue, accuracy: 0.01)
        
        sut = DistributionChartViewModel(distributionChartType: .liabilityDistributionChart,
                                         dashboardViewModel: dashboardViewModel,
                                         repository: testingSnapshotRepository)
        let actualTotalLiabilityValue = sut.computeTotalValue(for: snapshot)
        XCTAssertEqual(expectedTotalLiabilityValue, actualTotalLiabilityValue, accuracy: 0.01)
    }
    
    /// snapshot with multiple no positions at all
    func test_computeTotalValue_5() throws {
        let (snapshot, expectedTotalAssetValue, expectedTotalLiabilityValue) = testDataProvider.createAndPersistTestObjects_computeTotalValue_5(using: testingCoreDataStack.context)
        
        let dashboardViewModel = DashboardViewModel(repository: testingSnapshotRepository)
        
        var sut = DistributionChartViewModel(distributionChartType: .assetDistributionChart,
                                             dashboardViewModel: dashboardViewModel,
                                             repository: testingSnapshotRepository)
        let actualTotalAssetValue = sut.computeTotalValue(for: snapshot)
        XCTAssertEqual(expectedTotalAssetValue, actualTotalAssetValue, accuracy: 0.01)
        
        sut = DistributionChartViewModel(distributionChartType: .liabilityDistributionChart,
                                         dashboardViewModel: dashboardViewModel,
                                         repository: testingSnapshotRepository)
        let actualTotalLiabilityValue = sut.computeTotalValue(for: snapshot)
        XCTAssertEqual(expectedTotalLiabilityValue, actualTotalLiabilityValue)
    }
    
    
    
    /// cumulative value falling well within the range that should be attributed to the according category (far away from borders of range)
    func test_setSelectedCategoryForNewCumulativeValue_1() throws {
        let (expectedAssetSelectedCategory, expectedLiabilitySelectedCategory) = testDataProvider.createAndPersistTestObjects_setSelectedCategoryForNewCumulativeValue_1(using: testingCoreDataStack.context)
        
        let dashboardViewModel = DashboardViewModel(repository: testingSnapshotRepository)
        var sut = DistributionChartViewModel(distributionChartType: .assetDistributionChart,
                                             dashboardViewModel: dashboardViewModel,
                                             repository: testingSnapshotRepository)
        
        sut.setSelectedCategoryForNewCumulativeValue(cumulativeValue: 39.71)
        let actualAssetSelectedCategory = sut.selectedCategory
        XCTAssertEqual(expectedAssetSelectedCategory, actualAssetSelectedCategory)
        
        sut = DistributionChartViewModel(distributionChartType: .liabilityDistributionChart,
                                         dashboardViewModel: dashboardViewModel,
                                         repository: testingSnapshotRepository)
        
        sut.setSelectedCategoryForNewCumulativeValue(cumulativeValue: 27.11)
        let actualLiabilitySelectedCategory = sut.selectedCategory
        XCTAssertEqual(expectedLiabilitySelectedCategory, actualLiabilitySelectedCategory)
    }
    
    /// last cumulative value that should be attributed to the first category
    func test_setSelectedCategoryForNewCumulativeValue_2() throws {
        let (expectedAssetSelectedCategory, expectedLiabilitySelectedCategory) = testDataProvider.createAndPersistTestObjects_setSelectedCategoryForNewCumulativeValue_2(using: testingCoreDataStack.context)
        
        let dashboardViewModel = DashboardViewModel(repository: testingSnapshotRepository)
        var sut = DistributionChartViewModel(distributionChartType: .assetDistributionChart,
                                             dashboardViewModel: dashboardViewModel,
                                             repository: testingSnapshotRepository)
        
        sut.setSelectedCategoryForNewCumulativeValue(cumulativeValue: 20.0)
        let actualAssetSelectedCategory = sut.selectedCategory
        XCTAssertEqual(expectedAssetSelectedCategory, actualAssetSelectedCategory)
        
        sut = DistributionChartViewModel(distributionChartType: .liabilityDistributionChart,
                                         dashboardViewModel: dashboardViewModel,
                                         repository: testingSnapshotRepository)
        
        sut.setSelectedCategoryForNewCumulativeValue(cumulativeValue: 40.0)
        let actualLiabilitySelectedCategory = sut.selectedCategory
        XCTAssertEqual(expectedLiabilitySelectedCategory, actualLiabilitySelectedCategory)
    }
}
