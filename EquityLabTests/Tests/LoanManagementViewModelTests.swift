import XCTest
@testable import EquityLab

final class LoanManagementViewModelTests: XCTestCase {
    private var testingCoreDataStack: TestingCoreDataStack!
    private var testingAssetRepository: AssetRepository!
    private var testingLiabilityRepository: LiabilityRepository!
    private let testDataProvider = LoanManagementViewModelTestDataProvider()
    
    override func setUpWithError() throws {
        testingCoreDataStack = TestingCoreDataStack()
        testingAssetRepository = AssetRepository(context: testingCoreDataStack.context)
        testingLiabilityRepository = LiabilityRepository(context: testingCoreDataStack.context)
    }
    
    /// no indices
    func test_deleteReceivablesWithIndices_1() throws {
        let sut = LoanManagementViewModel(assetRepository: testingAssetRepository, liabilityRepository: testingLiabilityRepository)
        let (indexSet, expectedRemainingReceivables) = testDataProvider.createAndPersistTestObjects_deleteReceivablesWithIndices_1(using: testingCoreDataStack.context)
        sut.deleteReceivables(for: indexSet)
        let actualRemainingSnapshots = testingAssetRepository.fetchReceivables()
        XCTAssertTrue(expectedRemainingReceivables ≡ actualRemainingSnapshots)
    }
}
