import XCTest
@testable import EquityLab

final class SnapshotStructureViewModelTests: XCTestCase {
    private var testingCoreDataStack: TestingCoreDataStack!
    private var testingAssetRepository: AssetRepository!
    private var testingLiabilityRepository: LiabilityRepository!
    private let testDataProvider = SnapshotStructureViewModelTestDataProvider()
    
    override func setUpWithError() throws {
        testingCoreDataStack = TestingCoreDataStack()
        testingAssetRepository = AssetRepository(context: testingCoreDataStack.context)
        testingLiabilityRepository = LiabilityRepository(context: testingCoreDataStack.context)
    }
    
    /// create multiple assetPools with multiple Assets and test pools/assets()/assets(for pool)
    func test_assetsAndPools_1() throws {
        let (expectedPools, poolToAssetDictionary, expectedAssets) = testDataProvider.createAndPersistTestObjects_assetsAndPools_1(using: testingCoreDataStack.context)
        
        let sut = SnapshotStructureViewModel(assetRepository: testingAssetRepository, liabilityRepository: testingLiabilityRepository)
        
        let actualPools = sut.assetPools
        XCTAssertTrue(expectedPools ≡ actualPools)
        
        var expectedAssetsForPool: [Asset]
        var actualAssetsForPool: [Asset]
        for pool in actualPools {
            expectedAssetsForPool = poolToAssetDictionary[pool]!
            actualAssetsForPool = sut.getAssetsForAssetPool(pool)
            XCTAssertTrue(expectedAssetsForPool ≡ actualAssetsForPool)
        }
    }
    
    /// create one assetPool with no Assets and test  pools/assets()/assets(for pool)
    func test_assetsAndPools_2() throws {
        let (expectedPools, poolToAssetDictionary, expectedAssets) = testDataProvider.createAndPersistTestObjects_assetsAndPools_2(using: testingCoreDataStack.context)
        
        let sut = SnapshotStructureViewModel(assetRepository: testingAssetRepository, liabilityRepository: testingLiabilityRepository)
        
        let actualPools = sut.assetPools
        XCTAssertTrue(expectedPools ≡ actualPools)
        
        var expectedAssetsForPool: [Asset]
        var actualAssetsForPool: [Asset]
        for pool in actualPools {
            expectedAssetsForPool = poolToAssetDictionary[pool]!
            actualAssetsForPool = sut.getAssetsForAssetPool(pool)
            XCTAssertTrue(expectedAssetsForPool ≡ actualAssetsForPool)
        }
    }
    
    /// create multiple liabilityPools with multiple Liabilities and test pools/liabilities(for pool)
    func test_liabilitiesAndPools_1() throws {
        let (expectedPools, poolToLiabilityDictionary, expectedLiabilities) = testDataProvider.createAndPersistTestObjects_liabilitiesAndPools_1(using: testingCoreDataStack.context)
        
        let sut = SnapshotStructureViewModel(assetRepository: testingAssetRepository, liabilityRepository: testingLiabilityRepository)
        
        let actualPools = sut.liabilityPools
        XCTAssertTrue(expectedPools ≡ actualPools)
        
        var expectedLiabilitiesForPool: [Liability]
        var actualLiabilitiesForPool: [Liability]
        for pool in actualPools {
            expectedLiabilitiesForPool = poolToLiabilityDictionary[pool]!
            actualLiabilitiesForPool = sut.getLiabilitiesForLiabilityPool(pool)
            XCTAssertTrue(expectedLiabilitiesForPool ≡ actualLiabilitiesForPool)
        }
    }
    
    /// create one liabilityPool with no Liabilities and test pools/liabilities(for pool)
    func test_liabilitiesAndPools_2() throws {
        let (expectedPools, poolToLiabilityDictionary, expectedLiabilities) = testDataProvider.createAndPersistTestObjects_liabilitiesAndPools_2(using: testingCoreDataStack.context)
        
        let sut = SnapshotStructureViewModel(assetRepository: testingAssetRepository, liabilityRepository: testingLiabilityRepository)
        
        let actualPools = sut.liabilityPools
        XCTAssertTrue(expectedPools ≡ actualPools)
        
        var expectedLiabilitiesForPool: [Liability]
        var actualLiabilitiesForPool: [Liability]
        for pool in actualPools {
            expectedLiabilitiesForPool = poolToLiabilityDictionary[pool]!
            actualLiabilitiesForPool = sut.getLiabilitiesForLiabilityPool(pool)
            XCTAssertTrue(expectedLiabilitiesForPool ≡ actualLiabilitiesForPool)
        }
    }
    
    /// create empty assetPool and test viewModel interface providing data to view as well as persisted data
    func test_createAssetPool_1() throws {
        let sut = SnapshotStructureViewModel(assetRepository: testingAssetRepository, liabilityRepository: testingLiabilityRepository)
        let expectedAssetPoolName = "test pool"
        sut.alertPoolName = expectedAssetPoolName
        try sut.createAssetPool()
        
        let viewModelPools = sut.assetPools
        XCTAssertTrue(viewModelPools.count == 1)
        let actualViewModelAssetPoolName = (try XCTUnwrap(viewModelPools.first)).name
        XCTAssertEqual(expectedAssetPoolName, actualViewModelAssetPoolName)
        
        var expectedAssetsForPool: [Asset]
        var actualAssetsForPool: [Asset]
        for pool in viewModelPools {
            expectedAssetsForPool = []
            actualAssetsForPool = sut.getAssetsForAssetPool(pool)
            XCTAssertTrue(expectedAssetsForPool ≡ actualAssetsForPool)
        }
        
        let persistedPools = testingAssetRepository.fetchAssetPools()
        XCTAssertTrue(persistedPools.count == 1)
        let actualPersistedAssetPoolName = (try XCTUnwrap(viewModelPools.first)).name
        XCTAssertEqual(expectedAssetPoolName, actualPersistedAssetPoolName)
    }
    
    /// delete pool with multiple assets, then test viewModel interface providing data to view as well as persisted data
    func test_deleteAssetPool_1() throws {
        let (poolToDelete, expectedPools, poolToAssetDictionary, expectedAssets) = testDataProvider.createAndPersistTestObjects_deleteAssetPool_1(using: testingCoreDataStack.context)
        
        let sut = SnapshotStructureViewModel(assetRepository: testingAssetRepository, liabilityRepository: testingLiabilityRepository)
        sut.delete(assetPool: poolToDelete)
        
        let actualViewModelPools = sut.assetPools
        XCTAssertTrue(expectedPools ≡ actualViewModelPools)
        let actualPersistedPools = testingAssetRepository.fetchAssetPools()
        XCTAssertTrue(expectedPools ≡ actualPersistedPools)
        
        var expectedAssetsForPool: [Asset]
        var actualAssetsForPool: [Asset]
        for pool in actualViewModelPools {
            expectedAssetsForPool = poolToAssetDictionary[pool]!
            actualAssetsForPool = sut.getAssetsForAssetPool(pool)
            XCTAssertTrue(expectedAssetsForPool ≡ actualAssetsForPool)
        }
        let expectedAssetsForPoolToDelete = [Asset]()
        let actualAssetsForPoolToDelete = sut.getAssetsForAssetPool(poolToDelete)
        XCTAssertEqual(expectedAssetsForPoolToDelete,actualAssetsForPoolToDelete)
    }
    
    /// update pool and test viewModel interface providing data to view as well as persisted data
    func test_updateAssetPool_1() throws {
        let (poolToUpdate, expectedPoolNames, poolNameToAssetDictionary, expectedAssets) = testDataProvider.createAndPersistTestObjects_updateAssetPool_1(using: testingCoreDataStack.context)
        
        let sut = SnapshotStructureViewModel(assetRepository: testingAssetRepository, liabilityRepository: testingLiabilityRepository)
        sut.assetPoolToEdit = poolToUpdate
        sut.alertPoolName = "Cash"
        try sut.updateAssetPool()
        
        let actualViewModelPoolNames = sut.assetPools.map{ $0.name }
        XCTAssertTrue(expectedPoolNames ≡ actualViewModelPoolNames)
        let actualPersistedPoolNames = testingAssetRepository.fetchAssetPools().map { $0.name }
        XCTAssertTrue(expectedPoolNames ≡ actualPersistedPoolNames)
        
        let actualViewModelPools = sut.assetPools
        var expectedAssetsForPool: [Asset]
        var actualAssetsForPool: [Asset]
        for pool in actualViewModelPools {
            expectedAssetsForPool = poolNameToAssetDictionary[pool.name]!
            actualAssetsForPool = sut.getAssetsForAssetPool(pool)
            XCTAssertTrue(expectedAssetsForPool ≡ actualAssetsForPool)
        }
    }
    
    /// create empty liabilityPool and test viewModel interface providing data to view as well as persisted data
    func test_createLiabilityPool_1() throws {
        let sut = SnapshotStructureViewModel(assetRepository: testingAssetRepository, liabilityRepository: testingLiabilityRepository)
        let expectedLiabilityPoolName = "test pool"
        sut.alertPoolName = expectedLiabilityPoolName
        try sut.createLiabilityPool()
        
        let viewModelPools = sut.liabilityPools
        XCTAssertTrue(viewModelPools.count == 1)
        let actualViewModelLiabilityPoolName = (try XCTUnwrap(viewModelPools.first)).name
        XCTAssertEqual(expectedLiabilityPoolName, actualViewModelLiabilityPoolName)
        
        var expectedLiabilitiesForPool: [Liability]
        var actualLiabilitiesForPool: [Liability]
        for pool in viewModelPools {
            expectedLiabilitiesForPool = []
            actualLiabilitiesForPool = sut.getLiabilitiesForLiabilityPool(pool)
            XCTAssertTrue(expectedLiabilitiesForPool ≡ actualLiabilitiesForPool)
        }
        
        let persistedPools = testingLiabilityRepository.fetchLiabilityPools()
        XCTAssertTrue(persistedPools.count == 1)
        let actualPersistedLiabilityPoolName = (try XCTUnwrap(viewModelPools.first)).name
        XCTAssertEqual(expectedLiabilityPoolName, actualPersistedLiabilityPoolName)
    }
    
    /// delete pool with multiple liabilities, then test viewModel interface providing data to view as well as persisted data
    func test_deleteLiabilityPool_1() throws {
        let (poolToDelete, expectedPools, poolToLiabilityDictionary, expectedLiabilities) = testDataProvider.createAndPersistTestObjects_deleteLiabilityPool_1(using: testingCoreDataStack.context)
        
        let sut = SnapshotStructureViewModel(assetRepository: testingAssetRepository, liabilityRepository: testingLiabilityRepository)
        sut.delete(liabilityPool: poolToDelete)
        
        let actualViewModelPools = sut.liabilityPools
        XCTAssertTrue(expectedPools ≡ actualViewModelPools)
        let actualPersistedPools = testingLiabilityRepository.fetchLiabilityPools()
        XCTAssertTrue(expectedPools ≡ actualPersistedPools)
        
        var expectedLiabilitiesForPool: [Liability]
        var actualLiabilitiesForPool: [Liability]
        for pool in actualViewModelPools {
            expectedLiabilitiesForPool = poolToLiabilityDictionary[pool]!
            actualLiabilitiesForPool = sut.getLiabilitiesForLiabilityPool(pool)
            XCTAssertTrue(expectedLiabilitiesForPool ≡ actualLiabilitiesForPool)
        }
        let expectedLiabilitiesForPoolToDelete = [Liability]()
        let actualLiabilitiesForPoolToDelete = sut.getLiabilitiesForLiabilityPool(poolToDelete)
        XCTAssertEqual(expectedLiabilitiesForPoolToDelete, actualLiabilitiesForPoolToDelete)
    }
    
    /// update pool and test viewModel interface providing data to view as well as persisted data
    func test_updateLiabilityPool_1() throws {
        let (poolToUpdate, expectedPoolNames, poolNameToLiabilityDictionary, expectedLiabilities) = testDataProvider.createAndPersistTestObjects_updateLiabilityPool_1(using: testingCoreDataStack.context)
        
        let sut = SnapshotStructureViewModel(assetRepository: testingAssetRepository, liabilityRepository: testingLiabilityRepository)
        sut.liabilityPoolToEdit = poolToUpdate
        sut.alertPoolName = "Familie"
        try sut.updateLiabilityPool()
        
        let actualViewModelPoolNames = sut.liabilityPools.map{ $0.name }
        XCTAssertTrue(expectedPoolNames ≡ actualViewModelPoolNames)
        let actualPersistedPoolNames = testingLiabilityRepository.fetchLiabilityPools().map { $0.name }
        XCTAssertTrue(expectedPoolNames ≡ actualPersistedPoolNames)
        
        let actualViewModelPools = sut.liabilityPools
        var expectedLiabilitiesForPool: [Liability]
        var actualLiabilitiesForPool: [Liability]
        for pool in actualViewModelPools {
            expectedLiabilitiesForPool = poolNameToLiabilityDictionary[pool.name]!
            actualLiabilitiesForPool = sut.getLiabilitiesForLiabilityPool(pool)
            XCTAssertTrue(expectedLiabilitiesForPool ≡ actualLiabilitiesForPool)
        }
    }
}
