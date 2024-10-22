import XCTest
@testable import EquityLab

final class SnapshotFormViewModelTests: XCTestCase {
    private var testingCoreDataStack: TestingCoreDataStack!
    private var testingSnapshotRepository: SnapshotRepository!
    private var testingAssetRepository: AssetRepository!
    private var testingLiabilityRepository: LiabilityRepository!
    private let testDataProvider = SnapshotFormViewModelTestDataProvider()
    
    override func setUpWithError() throws {
        testingCoreDataStack = TestingCoreDataStack()
        testingSnapshotRepository = SnapshotRepository(context: testingCoreDataStack.context)
        testingAssetRepository = AssetRepository(context: testingCoreDataStack.context)
        testingLiabilityRepository = LiabilityRepository(context: testingCoreDataStack.context)
    }
    
    
    
    /// create multiple pools with multiple assets/liabilities and test viewModel properties (no snapshot passed into SUT)
    func test_poolNames_1() throws {
        let (
            expectedDate,
            expectedAssetPoolNames,
            expectedLiabilityPoolNames,
            expectedAssetProxies,
            expectedLiabilityProxies
        ) = testDataProvider.createAndPersistTestObjects_poolNames_1(using: testingCoreDataStack.context)
        
        let sut = SnapshotFormViewModel(snapshotRepository: testingSnapshotRepository,
                                        assetRepository: testingAssetRepository,
                                        liabilityRepository: testingLiabilityRepository,
                                        dismissSheet: {})
        
        let actualDate = sut.date
        XCTAssertEqual(expectedDate, actualDate)
        
        let actutalAssetPoolNames = sut.assetPoolNames
        XCTAssertTrue(expectedAssetPoolNames ≡ actutalAssetPoolNames)
        
        let actutalLiabilityPoolNames = sut.liabilityPoolNames
        XCTAssertTrue(expectedLiabilityPoolNames ≡ actutalLiabilityPoolNames)
        
        let actualAssetProxies = sut.assetProxies
        XCTAssertTrue(expectedAssetProxies ≡ actualAssetProxies)
        
        let actualLiabilityProxies = sut.liabilityProxies
        XCTAssertTrue(expectedLiabilityProxies ≡ actualLiabilityProxies)
    }
    
    /// create multiple pools with multiple assets/liabilities, then delete some pools and assets/liabilities and test viewModel properties (no snapshot passed into SUT)
    func test_poolNames_2() throws {
        let (
            expectedDate,
            expectedAssetPoolNames,
            expectedLiabilityPoolNames,
            expectedAssetProxies,
            expectedLiabilityProxies
        ) = testDataProvider.createAndPersistTestObjects_poolNames_2(using: testingCoreDataStack.context)
        
        let sut = SnapshotFormViewModel(snapshotRepository: testingSnapshotRepository,
                                        assetRepository: testingAssetRepository,
                                        liabilityRepository: testingLiabilityRepository,
                                        dismissSheet: {})
        
        let actualDate = sut.date
        XCTAssertEqual(expectedDate, actualDate)
        
        let actutalAssetPoolNames = sut.assetPoolNames
        XCTAssertTrue(expectedAssetPoolNames ≡ actutalAssetPoolNames)
        
        let actutalLiabilityPoolNames = sut.liabilityPoolNames
        XCTAssertTrue(expectedLiabilityPoolNames ≡ actutalLiabilityPoolNames)
        
        let actualAssetProxies = sut.assetProxies
        XCTAssertTrue(expectedAssetProxies ≡ actualAssetProxies)
        
        let actualLiabilityProxies = sut.liabilityProxies
        XCTAssertTrue(expectedLiabilityProxies ≡ actualLiabilityProxies)
    }
    
    /// create snapshot with multiple positions and test viewModel properties
    func test_poolNames_3() throws {
        let (
            testSnapshot,
            expectedDate,
            expectedAssetPoolNames,
            expectedLiabilityPoolNames,
            expectedAssetProxies,
            expectedLiabilityProxies
        ) = testDataProvider.createAndPersistTestObjects_poolNames_3(using: testingCoreDataStack.context)
        
        let sut = SnapshotFormViewModel(snapshot: testSnapshot,
                                        snapshotRepository: testingSnapshotRepository,
                                        assetRepository: testingAssetRepository,
                                        liabilityRepository: testingLiabilityRepository,
                                        dismissSheet: {})
        
        let actualDate = sut.date
        XCTAssertEqual(expectedDate, actualDate)
        
        let actutalAssetPoolNames = sut.assetPoolNames
        XCTAssertTrue(expectedAssetPoolNames ≡ actutalAssetPoolNames)
        
        let actutalLiabilityPoolNames = sut.liabilityPoolNames
        XCTAssertTrue(expectedLiabilityPoolNames ≡ actutalLiabilityPoolNames)
        
        let actualAssetProxies = sut.assetProxies
        XCTAssertTrue(expectedAssetProxies ≡ actualAssetProxies)
        
        let actualLiabilityProxies = sut.liabilityProxies
        XCTAssertTrue(expectedLiabilityProxies ≡ actualLiabilityProxies)
    }
    
    /// create multiple pools with multiple assets/liabilities and test getAssetProxies()/getLiabilityProxies() methods (no snapshot passed into SUT)
    func test_getProxies_1() throws {
        let (poolNameToAssetProxyDictionary,poolNameToLiabilityProxyDictionary) = testDataProvider.createAndPersistTestObjects_getProxies_1(using: testingCoreDataStack.context)
        
        let sut = SnapshotFormViewModel(snapshotRepository: testingSnapshotRepository,
                                        assetRepository: testingAssetRepository,
                                        liabilityRepository: testingLiabilityRepository,
                                        dismissSheet: {})
        
        var expectedProxies = poolNameToAssetProxyDictionary["Bargeld"]!
        var actualProxies = sut.getAssetProxies(for: "Bargeld")
        XCTAssertTrue(expectedProxies ≡ actualProxies)
        
        expectedProxies = poolNameToAssetProxyDictionary["Bank"]!
        actualProxies = sut.getAssetProxies(for: "Bank")
        XCTAssertTrue(expectedProxies ≡ actualProxies)
        
        expectedProxies = poolNameToAssetProxyDictionary["Wertpapiere"]!
        actualProxies = sut.getAssetProxies(for: "Wertpapiere")
        XCTAssertTrue(expectedProxies ≡ actualProxies)
        
        expectedProxies = poolNameToAssetProxyDictionary["Geliehen"]!
        actualProxies = sut.getAssetProxies(for: "Geliehen")
        XCTAssertTrue(expectedProxies ≡ actualProxies)
        
        expectedProxies = poolNameToLiabilityProxyDictionary["Privat"]!
        actualProxies = sut.getLiabilityProxies(for: "Privat")
        XCTAssertTrue(expectedProxies ≡ actualProxies)
        
        expectedProxies = poolNameToLiabilityProxyDictionary["Staatlich"]!
        actualProxies = sut.getLiabilityProxies(for: "Staatlich")
        XCTAssertTrue(expectedProxies ≡ actualProxies)
    }
    
    /// create snapshot with multiple positions and test getAssetProxies()/getLiabilityProxies() methods
    func test_getProxies_2() throws {
        let (snapshot, poolNameToAssetProxyDictionary,poolNameToLiabilityProxyDictionary) = testDataProvider.createAndPersistTestObjects_getProxies_2(using: testingCoreDataStack.context)
        
        let sut = SnapshotFormViewModel(snapshot: snapshot,
                                        snapshotRepository: testingSnapshotRepository,
                                        assetRepository: testingAssetRepository,
                                        liabilityRepository: testingLiabilityRepository,
                                        dismissSheet: {})
        
        var expectedProxies = poolNameToAssetProxyDictionary["Bargeld"]!
        var actualProxies = sut.getAssetProxies(for: "Bargeld")
        XCTAssertTrue(expectedProxies ≡ actualProxies)
        
        expectedProxies = poolNameToAssetProxyDictionary["Bank"]!
        actualProxies = sut.getAssetProxies(for: "Bank")
        XCTAssertTrue(expectedProxies ≡ actualProxies)
        
        expectedProxies = poolNameToAssetProxyDictionary["Wertpapiere"]!
        actualProxies = sut.getAssetProxies(for: "Wertpapiere")
        XCTAssertTrue(expectedProxies ≡ actualProxies)
        
        expectedProxies = poolNameToLiabilityProxyDictionary["Privat"]!
        actualProxies = sut.getLiabilityProxies(for: "Privat")
        XCTAssertTrue(expectedProxies ≡ actualProxies)
        
        expectedProxies = poolNameToLiabilityProxyDictionary["Staatlich"]!
        actualProxies = sut.getLiabilityProxies(for: "Staatlich")
        XCTAssertTrue(expectedProxies ≡ actualProxies)
        
        expectedProxies = poolNameToLiabilityProxyDictionary["Bank"]!
        actualProxies = sut.getLiabilityProxies(for: "Bank")
        XCTAssertTrue(expectedProxies ≡ actualProxies)
    }
    
    /// test whether SUT creates snapshot correctly
    func test_saveSnapshot_1() throws {
        testDataProvider.createAndPersistTestObjects_saveSnapshot_1(using: testingCoreDataStack.context)
        
        let sut = SnapshotFormViewModel(snapshotRepository: testingSnapshotRepository,
                                        assetRepository: testingAssetRepository,
                                        liabilityRepository: testingLiabilityRepository,
                                        dismissSheet: {})
        
        let expectedSnapshotDate = DateParser.shared.date(from: "2024-04-15T00:00:00")!
        let expectedAssetPositionProperties = [("Geldbeutel", 200.0), ("Konto Sparkasse",320.0),("Konto Commerzbank", 111.4)]
        let expectedLiabilityPositionProperties = [("Auto", 200.0), ("Studium", 250.0)]
        
        sut.date = expectedSnapshotDate
        let assetProxy1 = try XCTUnwrap(sut.assetProxies.first(where: {$0.name == "Geldbeutel"}))
        assetProxy1.value = 200.0
        let assetProxy2 = try XCTUnwrap(sut.assetProxies.first(where: {$0.name == "Konto Sparkasse"}))
        assetProxy2.value = 320.0
        let assetProxy3 = try XCTUnwrap(sut.assetProxies.first(where: {$0.name == "Konto Commerzbank"}))
        assetProxy3.value = 111.4
        let liabilityProxy1 = try XCTUnwrap(sut.liabilityProxies.first(where: {$0.name == "Auto"}))
        liabilityProxy1.value = 200.0
        let liabilityProxy2 = try XCTUnwrap(sut.liabilityProxies.first(where: {$0.name == "Studium"}))
        liabilityProxy2.value = 250.0
        
        try sut.saveSnapshot()
        
        let snapshots = testingSnapshotRepository.fetchSnapshots()
        let snapshot = try XCTUnwrap(snapshots.first)
        
        let actualSnapshotDate = snapshot.date
        let actualAssetPositionProperties = testingSnapshotRepository.fetchAssetPositions(of: snapshot).map{ ($0.name, $0.value) }
        let actualLiabilityPositionProperties = testingSnapshotRepository.fetchLiabilityPositions(of: snapshot).map{ ($0.name, $0.value) }
        
        XCTAssertEqual(expectedSnapshotDate, actualSnapshotDate)
        XCTAssertTrue(expectedAssetPositionProperties ≡ actualAssetPositionProperties)
        XCTAssertTrue(expectedLiabilityPositionProperties ≡ actualLiabilityPositionProperties)
        XCTAssertTrue(snapshots.count == 1)
    }
    
    /// test whether SUT updates snapshot correctly
    func test_saveSnapshot_2() throws {
        var snapshot = testDataProvider.createAndPersistTestObjects_saveSnapshot_2(using: testingCoreDataStack.context)
        
        let sut = SnapshotFormViewModel(snapshot: snapshot,
                                        snapshotRepository: testingSnapshotRepository,
                                        assetRepository: testingAssetRepository,
                                        liabilityRepository: testingLiabilityRepository,
                                        dismissSheet: {})
        
        let expectedSnapshotDate = Date.now.startOfDay
        let expectedAssetPositionProperties = [("Geldbeutel", 50.0), ("Konto Sparkasse",200.0),("Konto Commerzbank", 300.0),("FNZ",0.0)]
        let expectedLiabilityPositionProperties = [("Auto Papa", 800.0), ("Booth", 100.0),("Studium", 5000.0),("Kaution", 1000.0)]
        
        sut.date = expectedSnapshotDate
        let assetProxy1 = try XCTUnwrap(sut.assetProxies.first(where: {$0.name == "Geldbeutel"}))
        assetProxy1.value = 50.0
        let assetProxy2 = try XCTUnwrap(sut.assetProxies.first(where: {$0.name == "Konto Sparkasse"}))
        assetProxy2.value = 200.0
        let assetProxy3 = try XCTUnwrap(sut.assetProxies.first(where: {$0.name == "Konto Commerzbank"}))
        assetProxy3.value = 300.0
        let liabilityProxy1 = try XCTUnwrap(sut.liabilityProxies.first(where: {$0.name == "Auto Papa"}))
        liabilityProxy1.value = 800.0
        let liabilityProxy2 = try XCTUnwrap(sut.liabilityProxies.first(where: {$0.name == "Booth"}))
        liabilityProxy2.value = 100.0
        
        try sut.saveSnapshot()
        
        let snapshots = testingSnapshotRepository.fetchSnapshots()
        snapshot = try XCTUnwrap(snapshots.first)
        
        let actualSnapshotDate = snapshot.date
        let actualAssetPositionProperties = testingSnapshotRepository.fetchAssetPositions(of: snapshot).map{ ($0.name, $0.value) }
        let actualLiabilityPositionProperties = testingSnapshotRepository.fetchLiabilityPositions(of: snapshot).map{ ($0.name, $0.value) }
        
        XCTAssertEqual(expectedSnapshotDate, actualSnapshotDate)
        XCTAssertTrue(expectedAssetPositionProperties ≡ actualAssetPositionProperties)
        XCTAssertTrue(expectedLiabilityPositionProperties ≡ actualLiabilityPositionProperties)
        XCTAssertTrue(snapshots.count == 1)
    }
    
    /* TODO: add test that tests whether it is possible to create two snapshots of the same date */

}

