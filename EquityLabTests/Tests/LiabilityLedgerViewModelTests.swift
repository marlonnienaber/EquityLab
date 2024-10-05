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
    
    /// create multiple liabilityPools with multiple Liabilities and test pools/liabilities()/liabilities(for pool)
    func test_liabilitiesAndPools_1() throws {
        let (expectedPools, poolToLiabilityDictionary, expectedLiabilities) = testDataProvider.createAndPersistTestObjects_liabilitiesAndPools_1(using: testingCoreDataStack.context)
        
        let sut = LiabilityLedgerViewModel(repository: testingLiabilityRepository)
        
        let actualPools = sut.pools
        XCTAssertTrue(expectedPools ≡ actualPools)
        
        var expectedLiabilitiesForPool: [Liability]
        var actualLiabilitiesForPool: [Liability]
        for pool in actualPools {
            expectedLiabilitiesForPool = poolToLiabilityDictionary[pool]!
            actualLiabilitiesForPool = sut.liabilities(for: pool)
            XCTAssertTrue(expectedLiabilitiesForPool ≡ actualLiabilitiesForPool)
        }
        
        let actualLiabilities = sut.liabilities()
        XCTAssertTrue(expectedLiabilities ≡ actualLiabilities)
    }
    
    /// create one liabilityPool with no Liabilities and test pools/liabilities()/liabilities(for pool)
    func test_liabilitiesAndPools_2() throws {
        let (expectedPools, poolToLiabilityDictionary, expectedLiabilities) = testDataProvider.createAndPersistTestObjects_liabilitiesAndPools_2(using: testingCoreDataStack.context)
        
        let sut = LiabilityLedgerViewModel(repository: testingLiabilityRepository)
        
        let actualPools = sut.pools
        XCTAssertTrue(expectedPools ≡ actualPools)
        
        var expectedLiabilitiesForPool: [Liability]
        var actualLiabilitiesForPool: [Liability]
        for pool in actualPools {
            expectedLiabilitiesForPool = poolToLiabilityDictionary[pool]!
            actualLiabilitiesForPool = sut.liabilities(for: pool)
            XCTAssertTrue(expectedLiabilitiesForPool ≡ actualLiabilitiesForPool)
        }
        
        let actualLiabilities = sut.liabilities()
        XCTAssertTrue(expectedLiabilities ≡ actualLiabilities)
    }
    
    /// delete one liability and test viewModel interface providing data to view as well as persisted data
    func test_deleteLiability_1() throws {
        let (deletionPool, expectedPools, poolToLiabilityDictionary, expectedLiabilities) = testDataProvider.createAndPersistTestObjects_deleteLiabilities_1(using: testingCoreDataStack.context)
        
        let sut = LiabilityLedgerViewModel(repository: testingLiabilityRepository)
        sut.deleteLiabilities(in: deletionPool, for: IndexSet(integer: 1))
        
        let actualPools = sut.pools
        XCTAssertTrue(expectedPools ≡ actualPools)
        
        var expectedLiabilitiesForPool: [Liability]
        var actualLiabilitiesForPool: [Liability]
        for pool in actualPools {
            expectedLiabilitiesForPool = poolToLiabilityDictionary[pool]!
            actualLiabilitiesForPool = sut.liabilities(for: pool)
            XCTAssertTrue(expectedLiabilitiesForPool ≡ actualLiabilitiesForPool)
        }
        
        let actualViewModelLiabilities = sut.liabilities()
        XCTAssertTrue(expectedLiabilities ≡ actualViewModelLiabilities)
        let actualPersistedLiabilities = testingLiabilityRepository.fetchLiabilities()
        XCTAssertTrue(expectedLiabilities ≡ actualPersistedLiabilities)
    }
    
    /* TODO: write test_deleteLiability_2 where multiple liabilities in one pool are deleted */
    
    /// create empty liabilityPool and test viewModel interface providing data to view as well as persisted data
    func test_createLiabilityPool_1() throws {
        let sut = LiabilityLedgerViewModel(repository: testingLiabilityRepository)
        let expectedLiabilityPoolName = "test pool"
        sut.alertPoolName = expectedLiabilityPoolName
        sut.createLiabilityPool()
        
        let viewModelPools = sut.pools
        XCTAssertTrue(viewModelPools.count == 1)
        let actualViewModelLiabilityPoolName = (try XCTUnwrap(viewModelPools.first)).name
        XCTAssertEqual(expectedLiabilityPoolName, actualViewModelLiabilityPoolName)
        
        var expectedLiabilitiesForPool: [Liability]
        var actualLiabilitiesForPool: [Liability]
        for pool in viewModelPools {
            expectedLiabilitiesForPool = []
            actualLiabilitiesForPool = sut.liabilities(for: pool)
            XCTAssertTrue(expectedLiabilitiesForPool ≡ actualLiabilitiesForPool)
        }
        
        let expectedLiabilities = [Liability]()
        let actualViewModelLiabilities = sut.liabilities()
        XCTAssertTrue(expectedLiabilities ≡ actualViewModelLiabilities)
        
        let persistedPools = testingLiabilityRepository.fetchLiabilityPools()
        XCTAssertTrue(persistedPools.count == 1)
        let actualPersistedLiabilityPoolName = (try XCTUnwrap(viewModelPools.first)).name
        XCTAssertEqual(expectedLiabilityPoolName, actualPersistedLiabilityPoolName)
    }
    
    /// delete pool with multiple liabilities, then test viewModel interface providing data to view as well as persisted data
    func test_deleteLiabilityPool_1() throws {
        let (poolToDelete, expectedPools, poolToLiabilityDictionary, expectedLiabilities) = testDataProvider.createAndPersistTestObjects_deleteLiabilityPool_1(using: testingCoreDataStack.context)
        
        let sut = LiabilityLedgerViewModel(repository: testingLiabilityRepository)
        sut.alertPool = poolToDelete
        sut.deleteLiabilityPool()
        
        let actualViewModelPools = sut.pools
        XCTAssertTrue(expectedPools ≡ actualViewModelPools)
        let actualPersistedPools = testingLiabilityRepository.fetchLiabilityPools()
        XCTAssertTrue(expectedPools ≡ actualPersistedPools)
        
        var expectedLiabilitiesForPool: [Liability]
        var actualLiabilitiesForPool: [Liability]
        for pool in actualViewModelPools {
            expectedLiabilitiesForPool = poolToLiabilityDictionary[pool]!
            actualLiabilitiesForPool = sut.liabilities(for: pool)
            XCTAssertTrue(expectedLiabilitiesForPool ≡ actualLiabilitiesForPool)
        }
        let expectedLiabilitiesForPoolToDelete = [Liability]()
        let actualLiabilitiesForPoolToDelete = sut.liabilities(for: poolToDelete)
        XCTAssertEqual(expectedLiabilitiesForPoolToDelete, actualLiabilitiesForPoolToDelete)
        
        let actualLiabilities = sut.liabilities()
        XCTAssertTrue(expectedLiabilities ≡ actualLiabilities)
    }
    
    /// update pool and test viewModel interface providing data to view as well as persisted data
    func test_updateLiabilityPool_1() throws {
        let (poolToUpdate, expectedPoolNames, poolNameToLiabilityDictionary, expectedLiabilities) = testDataProvider.createAndPersistTestObjects_updateLiabilityPool_1(using: testingCoreDataStack.context)
        
        let sut = LiabilityLedgerViewModel(repository: testingLiabilityRepository)
        sut.alertPool = poolToUpdate
        sut.alertPoolName = "Familie"
        sut.updateLiabilityPool()
        
        let actualViewModelPoolNames = sut.pools.map{ $0.name }
        XCTAssertTrue(expectedPoolNames ≡ actualViewModelPoolNames)
        let actualPersistedPoolNames = testingLiabilityRepository.fetchLiabilityPools().map { $0.name }
        XCTAssertTrue(expectedPoolNames ≡ actualPersistedPoolNames)
        
        let actualViewModelPools = sut.pools
        var expectedLiabilitiesForPool: [Liability]
        var actualLiabilitiesForPool: [Liability]
        for pool in actualViewModelPools {
            expectedLiabilitiesForPool = poolNameToLiabilityDictionary[pool.name]!
            actualLiabilitiesForPool = sut.liabilities(for: pool)
            XCTAssertTrue(expectedLiabilitiesForPool ≡ actualLiabilitiesForPool)
        }
        
        let actualLiabilities = sut.liabilities()
        XCTAssertTrue(expectedLiabilities ≡ actualLiabilities)
    }
}
