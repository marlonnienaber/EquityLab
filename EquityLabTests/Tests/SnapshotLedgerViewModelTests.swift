import XCTest
@testable import EquityLab

/* TODO: test interface providing data to view after CRUD operation on model (ATM it is only tested whether persisted data is correct, not whether the change is reflected in the viewModels data) */
final class SnapshotLedgerViewModelTests: XCTestCase {
    private var testingCoreDataStack: TestingCoreDataStack!
    private var testingSnapshotRepository: SnapshotRepository!
    private let testDataProvider = SnapshotLedgerViewModelTestDataProvider()
    
    override func setUpWithError() throws {
        testingCoreDataStack = TestingCoreDataStack()
        testingSnapshotRepository = SnapshotRepository(context: testingCoreDataStack.context)
    }
    
    
    
    /// one snapshot falling into the year
    func test_getSnapshots_1() throws {
        let sut = SnapshotLedgerViewModel(repository: testingSnapshotRepository)
        let expectedSnapshots = testDataProvider.createAndPersistTestObjects_getSnapshots_1(using: testingCoreDataStack.context)
        let actualSnapshots = sut.getSnapshots(fallingInto: 2002)
        XCTAssertTrue(expectedSnapshots ≡ actualSnapshots)
    }
    
    /// multiple snapshots falling into the year
    func test_getSnapshots_2() throws {
        let sut = SnapshotLedgerViewModel(repository: testingSnapshotRepository)
        let expectedSnapshots = testDataProvider.createAndPersistTestObjects_getSnapshots_2(using: testingCoreDataStack.context)
        let actualSnapshots = sut.getSnapshots(fallingInto: 2002)
        XCTAssertTrue(expectedSnapshots ≡ actualSnapshots)
    }
    
    /// no snapshots falling into the year
    func test_getSnapshots_3() throws {
        let sut = SnapshotLedgerViewModel(repository: testingSnapshotRepository)
        let expectedSnapshots = testDataProvider.createAndPersistTestObjects_getSnapshots_3(using: testingCoreDataStack.context)
        let actualSnapshots = sut.getSnapshots(fallingInto: 2002)
        XCTAssertTrue(expectedSnapshots ≡ actualSnapshots)
    }
    
    
    
    /// multiple snapshots in year
    func test_deleteSnapshotsInYear_1() throws {
        let sut = SnapshotLedgerViewModel(repository: testingSnapshotRepository)
        let (year, indexSet, expectedRemainingSnapshots) = testDataProvider.createAndPersistTestObjects_deleteSnapshotsInYear_1(using: testingCoreDataStack.context)
        sut.deleteSnapshots(in: year, for: indexSet)
        let actualRemainingSnapshots = testingSnapshotRepository.getSnapshots()
        XCTAssertTrue(expectedRemainingSnapshots ≡ actualRemainingSnapshots)
    }
    
    /// no snapshots in year
    func test_deleteSnapshotsInYear_2() throws {
        let sut = SnapshotLedgerViewModel(repository: testingSnapshotRepository)
        let (year, indexSet, expectedRemainingSnapshots) = testDataProvider.createAndPersistTestObjects_deleteSnapshotsInYear_2(using: testingCoreDataStack.context)
        sut.deleteSnapshots(in: year, for: indexSet)
        let actualRemainingSnapshots = testingSnapshotRepository.getSnapshots()
        XCTAssertTrue(expectedRemainingSnapshots ≡ actualRemainingSnapshots)
    }
    
    /// all snapshots in year
    func test_deleteSnapshotsInYear_3() throws {
        let sut = SnapshotLedgerViewModel(repository: testingSnapshotRepository)
        let (year, indexSet, expectedRemainingSnapshots) = testDataProvider.createAndPersistTestObjects_deleteSnapshotsInYear_3(using: testingCoreDataStack.context)
        sut.deleteSnapshots(in: year, for: indexSet)
        let actualRemainingSnapshots = testingSnapshotRepository.getSnapshots()
        XCTAssertTrue(expectedRemainingSnapshots ≡ actualRemainingSnapshots)
    }
    
    
    
    /// no indices
    func test_deleteSnapshotsWithIndices_1() throws {
        let sut = SnapshotLedgerViewModel(repository: testingSnapshotRepository)
        let (indexSet, expectedRemainingSnapshots) = testDataProvider.createAndPersistTestObjects_deleteSnapshotsWithIndices_1(using: testingCoreDataStack.context)
        sut.deleteSnapshots(withIndices: indexSet)
        let actualRemainingSnapshots = testingSnapshotRepository.getSnapshots()
        XCTAssertTrue(expectedRemainingSnapshots ≡ actualRemainingSnapshots)
    }
    
    /// first index
    func test_deleteSnapshotsWithIndices_2() throws {
        let sut = SnapshotLedgerViewModel(repository: testingSnapshotRepository)
        let (indexSet, expectedRemainingSnapshots) = testDataProvider.createAndPersistTestObjects_deleteSnapshotsWithIndices_2(using: testingCoreDataStack.context)
        sut.deleteSnapshots(withIndices: indexSet)
        let actualRemainingSnapshots = testingSnapshotRepository.getSnapshots()
        XCTAssertTrue(expectedRemainingSnapshots ≡ actualRemainingSnapshots)
    }
    
    /// last index
    func test_deleteSnapshotsWithIndices_3() throws {
        let sut = SnapshotLedgerViewModel(repository: testingSnapshotRepository)
        let (indexSet, expectedRemainingSnapshots) = testDataProvider.createAndPersistTestObjects_deleteSnapshotsWithIndices_3(using: testingCoreDataStack.context)
        sut.deleteSnapshots(withIndices: indexSet)
        let actualRemainingSnapshots = testingSnapshotRepository.getSnapshots()
        XCTAssertTrue(expectedRemainingSnapshots ≡ actualRemainingSnapshots)
    }
    
    /// some middle index
    func test_deleteSnapshotsWithIndices_4() throws {
        let sut = SnapshotLedgerViewModel(repository: testingSnapshotRepository)
        let (indexSet, expectedRemainingSnapshots) = testDataProvider.createAndPersistTestObjects_deleteSnapshotsWithIndices_4(using: testingCoreDataStack.context)
        sut.deleteSnapshots(withIndices: indexSet)
        let actualRemainingSnapshots = testingSnapshotRepository.getSnapshots()
        XCTAssertTrue(expectedRemainingSnapshots ≡ actualRemainingSnapshots)
    }
    
    /// multiple indices
    func test_deleteSnapshotsWithIndices_5() throws {
        let sut = SnapshotLedgerViewModel(repository: testingSnapshotRepository)
        let (indexSet, expectedRemainingSnapshots) = testDataProvider.createAndPersistTestObjects_deleteSnapshotsWithIndices_5(using: testingCoreDataStack.context)
        sut.deleteSnapshots(withIndices: indexSet)
        let actualRemainingSnapshots = testingSnapshotRepository.getSnapshots()
        XCTAssertTrue(expectedRemainingSnapshots ≡ actualRemainingSnapshots)
    }
    
    /// all indices
    func test_deleteSnapshotsWithIndices_6() throws {
        let sut = SnapshotLedgerViewModel(repository: testingSnapshotRepository)
        let (indexSet, expectedRemainingSnapshots) = testDataProvider.createAndPersistTestObjects_deleteSnapshotsWithIndices_6(using: testingCoreDataStack.context)
        sut.deleteSnapshots(withIndices: indexSet)
        let actualRemainingSnapshots = testingSnapshotRepository.getSnapshots()
        XCTAssertTrue(expectedRemainingSnapshots ≡ actualRemainingSnapshots)
    }
    
    
    
    /// snapshot with no liabilityPositions
    func test_getEquityValue_1() throws {
        let sut = SnapshotLedgerViewModel(repository: testingSnapshotRepository)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_getEquityValue_1(using: testingCoreDataStack.context)
        let expectedResult = 17.77
        let actualResult = sut.getEquityValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult.doubleValue)
    }
    
    /// snapshot with no assetPositions
    func test_getEquityValue_2() throws {
        let sut = SnapshotLedgerViewModel(repository: testingSnapshotRepository)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_getEquityValue_2(using: testingCoreDataStack.context)
        let expectedResult = -20.43
        let actualResult = sut.getEquityValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult.doubleValue)
    }
    
    /// snapshot with 5 assetPositions (value >= 0) and 2 liabilityPositions (value > 0)
    func test_getEquityValue_3() throws {
        let sut = SnapshotLedgerViewModel(repository: testingSnapshotRepository)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_getEquityValue_3(using: testingCoreDataStack.context)
        let expectedResult = 253.91
        let actualResult = sut.getEquityValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult.doubleValue, accuracy: 0.01)
    }
    
    /// snapshot with 10 assetPositions (value > 0) and 7 liabilityPositions (value > 0)
    func test_getEquityValue_4() throws {
        let sut = SnapshotLedgerViewModel(repository: testingSnapshotRepository)
        let testSnapshot = testDataProvider.createAndPersistTestObjects_getEquityValue_4(using: testingCoreDataStack.context)
        let expectedResult = 876.79
        let actualResult = sut.getEquityValue(of: testSnapshot)
        XCTAssertEqual(expectedResult, actualResult.doubleValue, accuracy: 0.01)
    }
}
