import XCTest
@testable import EquityLab

final class ChangeChartViewModelTests: XCTestCase {
    private var testingCoreDataStack: TestingCoreDataStack!
    private var testingSnapshotRepository: SnapshotRepository!
    private let testDataProvider = ChangeChartViewModelTestDataProvider()
    
    override func setUpWithError() throws {
        testingCoreDataStack = TestingCoreDataStack()
        testingSnapshotRepository = SnapshotRepository(context: testingCoreDataStack.context)
    }
    
    
    
    /// test whether the Snapshot before the last Snapshot is correctly computed
    func test_computeSnapshotBeforeSelectedSnapshot_1() throws {
        let (expectedBeforeSnapshot,selectedSnapshot) = testDataProvider.createAndPersistTestObjects_computeShotBeforeSelectedShot_1(using: testingCoreDataStack.context)
        let testDashboardViewModel = DashboardViewModel(snapshotRepository: testingSnapshotRepository)
        testDashboardViewModel.selectedSnapshot = selectedSnapshot
        let sut = ChangeChartViewModel(changeChartType: .assetChangeChart, dashboardViewModel: testDashboardViewModel)
        
        let actualBeforeSnapshot = sut.computeSnapshotBeforeSelectedSnapshot()
        
        XCTAssertEqual(expectedBeforeSnapshot, actualBeforeSnapshot)
    }
    
    /// test whether the Snapshot before one of the middle Snapshots is correctly computed
    func test_computeSnapshotBeforeSelectedSnapshot_2() throws {
        let (expectedBeforeSnapshot,selectedSnapshot) = testDataProvider.createAndPersistTestObjects_computeShotBeforeSelectedShot_2(using: testingCoreDataStack.context)
        let testDashboardViewModel = DashboardViewModel(snapshotRepository: testingSnapshotRepository)
        testDashboardViewModel.selectedSnapshot = selectedSnapshot
        let sut = ChangeChartViewModel(changeChartType: .assetChangeChart, dashboardViewModel: testDashboardViewModel)
        
        let actualBeforeSnapshot = sut.computeSnapshotBeforeSelectedSnapshot()
        
        XCTAssertEqual(expectedBeforeSnapshot, actualBeforeSnapshot)
    }
    
    /// test whether computing the Snapshot before the last Snapshot correctly returns nil
    func test_computeSnapshotBeforeSelectedSnapshot_3() throws {
        let selectedSnapshot = testDataProvider.createAndPersistTestObjects_computeShotBeforeSelectedShot_3(using: testingCoreDataStack.context)
        let testDashboardViewModel = DashboardViewModel(snapshotRepository: testingSnapshotRepository)
        testDashboardViewModel.selectedSnapshot = selectedSnapshot
        let sut = ChangeChartViewModel(changeChartType: .assetChangeChart, dashboardViewModel: testDashboardViewModel)
        
        let beforeSnapshot = sut.computeSnapshotBeforeSelectedSnapshot()
        
        XCTAssertNil(beforeSnapshot)
    }
    
    
    
    /// test liability changeCategories/maxChangePercentage for two consecutive Snapshots. The test includes positive, negative and no change  and a case where the category from the earlier snapshot was of value 0
    func test_changeChartCategories_1() throws {
        let (snapshot, expectedChangeCategories, expectedMaxChangePercentage) = testDataProvider.createAndPersistTestObjects_changeChartCategories_1(using: testingCoreDataStack.context)
        let testDashboardViewModel = DashboardViewModel(snapshotRepository: testingSnapshotRepository)
        testDashboardViewModel.selectedSnapshot = snapshot
        let sut = ChangeChartViewModel(changeChartType: .liabilityChangeChart, dashboardViewModel: testDashboardViewModel)
        
        let actualChangeCategories = sut.changeCategories
        let actualMaxChangePercentage = sut.maxChangePercentage
        
        XCTAssertTrue(
            checkEquivalence(of: expectedChangeCategories, and: actualChangeCategories) {
                $0.change == $1.change && $0.name == $1.name
            }
        )
        XCTAssertEqual(expectedMaxChangePercentage, actualMaxChangePercentage)
    }
    
    /// test asset changeCategories/maxChangePercentage for two consecutive Snapshots. The test includes positive, negative and no change and a case where the category from the earlier snapshot was of value 0
    func test_changeChartCategories_2() throws {
        let (snapshot, expectedChangeCategories, expectedMaxChangePercentage) = testDataProvider.createAndPersistTestObjects_changeChartCategories_2(using: testingCoreDataStack.context)
        let testDashboardViewModel = DashboardViewModel(snapshotRepository: testingSnapshotRepository)
        testDashboardViewModel.selectedSnapshot = snapshot
        let sut = ChangeChartViewModel(changeChartType: .assetChangeChart, dashboardViewModel: testDashboardViewModel)
        
        let actualChangeCategories = sut.changeCategories
        let actualMaxChangePercentage = sut.maxChangePercentage
        
        XCTAssertTrue(
            checkEquivalence(of: expectedChangeCategories, and: actualChangeCategories) {
                $0.change == $1.change && $0.name == $1.name
            }
        )
        XCTAssertEqual(expectedMaxChangePercentage, actualMaxChangePercentage)
    }
}

