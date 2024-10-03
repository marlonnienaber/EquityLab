import XCTest
@testable import EquityLab

final class AssetLedgerViewModelTests: XCTestCase {
    private var testingCoreDataStack: TestingCoreDataStack!
    private var testingAssetRepository: AssetRepository!
    private let testDataProvider = AssetLedgerViewModelTestDataProvider()
    
    override func setUpWithError() throws {
        testingCoreDataStack = TestingCoreDataStack()
        testingAssetRepository = AssetRepository(context: testingCoreDataStack.context)
    }
    
    /// create multiple assetPools with multiple Assets and test  pools/assets()/assets(for pool)
    func test_assetsAndPools_1() throws {
        let (expectedPools, poolToAssetDictionary, expectedAssets) = testDataProvider.createAndPersistTestObjects_assetsAndPools_1(using: testingCoreDataStack.context)
        
        let sut = AssetLedgerViewModel(repository: testingAssetRepository)
        
        let actualPools = sut.pools
        XCTAssertTrue(expectedPools ≡ actualPools)
        
        var expectedAssetsForPool: [Asset]
        var actualAssetsForPool: [Asset]
        for pool in actualPools {
            expectedAssetsForPool = poolToAssetDictionary[pool]!
            actualAssetsForPool = sut.assets(for: pool)
            XCTAssertTrue(expectedAssetsForPool ≡ actualAssetsForPool)
        }
        
        let actualAssets = sut.assets()
        XCTAssertTrue(expectedAssets ≡ actualAssets)
    }
    
    /// create one assetPool with no Assets and test  pools/assets()/assets(for pool)
    func test_assetsAndPools_2() throws {
        let (expectedPools, poolToAssetDictionary, expectedAssets) = testDataProvider.createAndPersistTestObjects_assetsAndPools_1(using: testingCoreDataStack.context)
        
        let sut = AssetLedgerViewModel(repository: testingAssetRepository)
        
        let actualPools = sut.pools
        XCTAssertTrue(expectedPools ≡ actualPools)
        
        var expectedAssetsForPool: [Asset]
        var actualAssetsForPool: [Asset]
        for pool in actualPools {
            expectedAssetsForPool = poolToAssetDictionary[pool]!
            actualAssetsForPool = sut.assets(for: pool)
            XCTAssertTrue(expectedAssetsForPool ≡ actualAssetsForPool)
        }
        
        let actualAssets = sut.assets()
        XCTAssertTrue(expectedAssets ≡ actualAssets)
    }
    
    /// delete one asset and test viewModel interface providing data to view as well as persisted data
    func test_deleteAsset_1() throws {
        let (expectedPools, poolToAssetDictionary, expectedAssets) = testDataProvider.createAndPersistTestObjects_assetsAndPools_1(using: testingCoreDataStack.context)
        
        let sut = AssetLedgerViewModel(repository: testingAssetRepository)
        
        let actualPools = sut.pools
        XCTAssertTrue(expectedPools ≡ actualPools)
        
        var expectedAssetsForPool: [Asset]
        var actualAssetsForPool: [Asset]
        for pool in actualPools {
            expectedAssetsForPool = poolToAssetDictionary[pool]!
            actualAssetsForPool = sut.assets(for: pool)
            XCTAssertTrue(expectedAssetsForPool ≡ actualAssetsForPool)
        }
        
        let actualViewModelAssets = sut.assets()
        XCTAssertTrue(expectedAssets ≡ actualViewModelAssets)
        let actualPersistedAssets = testingAssetRepository.fetchAssets()
        XCTAssertTrue(expectedAssets ≡ actualPersistedAssets)
    }
    
    /// create empty assetPool and test viewModel interface providing data to view as well as persisted data
    func test_createAssetPool_1() throws {
        let sut = AssetLedgerViewModel(repository: testingAssetRepository)
        let expectedAssetPoolName = "test pool"
        sut.alertPoolName = expectedAssetPoolName
        sut.createAssetPool()
        
        let viewModelPools = sut.pools
        XCTAssertTrue(viewModelPools.count == 1)
        let actualViewModelAssetPoolName = (try XCTUnwrap(viewModelPools.first)).name
        XCTAssertEqual(expectedAssetPoolName, actualViewModelAssetPoolName)
        
        var expectedAssetsForPool: [Asset]
        var actualAssetsForPool: [Asset]
        for pool in viewModelPools {
            expectedAssetsForPool = []
            actualAssetsForPool = sut.assets(for: pool)
            XCTAssertTrue(expectedAssetsForPool ≡ actualAssetsForPool)
        }
        
        let expectedAssets = [Asset]()
        let actualViewModelAssets = sut.assets()
        XCTAssertTrue(expectedAssets ≡ actualViewModelAssets)
        
        let persistedPools = testingAssetRepository.fetchAssetPools()
        XCTAssertTrue(persistedPools.count == 1)
        let actualPersistedAssetPoolName = (try XCTUnwrap(viewModelPools.first)).name
        XCTAssertEqual(expectedAssetPoolName, actualPersistedAssetPoolName)
    }
    
    /// delete pool with multiple assets, then test viewModel interface providing data to view as well as persisted data
    func test_deleteAssetPool_1() throws {
        let (poolToDelete, expectedPools, poolToAssetDictionary, expectedAssets) = testDataProvider.createAndPersistTestObjects_deleteAssetPool_1(using: testingCoreDataStack.context)
        
        let sut = AssetLedgerViewModel(repository: testingAssetRepository)
        sut.alertPool = poolToDelete
        sut.deleteAssetPool()
        
        let actualViewModelPools = sut.pools
        XCTAssertTrue(expectedPools ≡ actualViewModelPools)
        let actualPersistedPools = testingAssetRepository.fetchAssetPools()
        XCTAssertTrue(expectedPools ≡ actualPersistedPools)
        
        var expectedAssetsForPool: [Asset]
        var actualAssetsForPool: [Asset]
        for pool in actualViewModelPools {
            expectedAssetsForPool = poolToAssetDictionary[pool]!
            actualAssetsForPool = sut.assets(for: pool)
            XCTAssertTrue(expectedAssetsForPool ≡ actualAssetsForPool)
        }
        let expectedAssetsForPoolToDelete = [Asset]()
        let actualAssetsForPoolToDelete = sut.assets(for: poolToDelete)
        XCTAssertEqual(expectedAssetsForPoolToDelete,actualAssetsForPoolToDelete)
        
        let actualAssets = sut.assets()
        XCTAssertTrue(expectedAssets ≡ actualAssets)
    }
    
    /// update pool and test viewModel interface providing data to view as well as persisted data
    func test_updateAssetPool_1() throws {
        let (poolToUpdate, expectedPoolNames, poolNameToAssetDictionary, expectedAssets) = testDataProvider.createAndPersistTestObjects_updateAssetPool_1(using: testingCoreDataStack.context)
        
        let sut = AssetLedgerViewModel(repository: testingAssetRepository)
        sut.alertPool = poolToUpdate
        sut.alertPoolName = "Cash"
        sut.updateAssetPool()
        
        let actualViewModelPoolNames = sut.pools.map{ $0.name }
        XCTAssertTrue(expectedPoolNames ≡ actualViewModelPoolNames)
        let actualPersistedPoolNames = testingAssetRepository.fetchAssetPools().map { $0.name }
        XCTAssertTrue(expectedPoolNames ≡ actualPersistedPoolNames)
        
        let actualViewModelPools = sut.pools
        var expectedAssetsForPool: [Asset]
        var actualAssetsForPool: [Asset]
        for pool in actualViewModelPools {
            expectedAssetsForPool = poolNameToAssetDictionary[pool.name]!
            actualAssetsForPool = sut.assets(for: pool)
            XCTAssertTrue(expectedAssetsForPool ≡ actualAssetsForPool)
        }
        
        let actualAssets = sut.assets()
        XCTAssertTrue(expectedAssets ≡ actualAssets)
    }
}
