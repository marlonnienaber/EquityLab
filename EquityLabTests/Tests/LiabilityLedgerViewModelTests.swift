import XCTest
@testable import EquityLab

final class LiabilityLedgerViewModelTests: XCTestCase {
    private var testingCoreDataStack: TestingCoreDataStack!
    private var testingLiabilityRepository: LiabilityRepository!
    private let testDataProvider = LiabilityLedgerViewModelTestDataProvider()
    
    override func setUpWithError() throws {
        testingCoreDataStack = TestingCoreDataStack()
        testingLiabilityRepository = LiabilityRepository(context: testingCoreDataStack.context)
    }
    
    /// create multiple liabilityPools with multiple Liabilities and test  pools/assets()/assets(for pool)
    func test_liabilitiesAndPools_1() throws {
        let (expectedPools, poolToLiabilitiesDictionary, expectedLiabilities) = testDataProvider.createAndPersistTestObjects_liabilitiesAndPools_1(using: testingCoreDataStack.context)
        
        let sut = LiabilityLedgerViewModel(repository: testingLiabilityRepository)
        
        let actualPools = sut.pools
        XCTAssertTrue(expectedPools ≡ actualPools)
        
        var expectedLiabilitiesForPool: [Liability]
        var actualLiabilitiesForPool: [Liability]
        for pool in actualPools {
            expectedLiabilitiesForPool = poolToLiabilitiesDictionary[pool]!
            actualLiabilitiesForPool = sut.liabilities(for: pool)
            XCTAssertTrue(expectedLiabilitiesForPool ≡ actualLiabilitiesForPool)
        }
        
        let actualLiabilities = sut.liabilities()
        XCTAssertTrue(expectedLiabilities ≡ actualLiabilities)
    }
}
