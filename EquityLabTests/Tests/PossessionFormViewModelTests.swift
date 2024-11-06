import XCTest
@testable import EquityLab

final class PossessionFormViewModelTests: XCTestCase {
    private var testingCoreDataStack: TestingCoreDataStack!
    private var testingAssetRepository: AssetRepository!
    private let testDataProvider = PossessionFormViewModelTestDataProvider()
    
    override func setUpWithError() throws {
        testingCoreDataStack = TestingCoreDataStack()
        testingAssetRepository = AssetRepository(context: testingCoreDataStack.context)
    }
    
    
    
    /// test whether the getAssetPools() function returns the before persited assetpools
    func test_getAssetPools_1() throws {
        let expectedPools = testDataProvider.createAndPersitsTestObjects_getAssetPools_1(using: testingCoreDataStack.context)

        let sut = PossessionFormViewModel(repository: testingAssetRepository, dismissSheet: {})

        let actualPools = sut.getAssetPools()
        XCTAssertTrue(expectedPools ≡ actualPools)
    }

    
    
    /// update a Possession
    func test_updatePossession_1() throws {
        var possession = testDataProvider.createAndPersistTestObjects_updatePossession_multipurpose(context: testingCoreDataStack.context)

        let sut = PossessionFormViewModel(possession: possession, repository: testingAssetRepository, dismissSheet: {})

        let expectedName = "Commerzbank Konto"
        let expectedIsVolatile = false
        let expectedAssetPool = DataFactory.createAssetPool(named: "Some other pool", possessions: [], receivables: [], in: testingCoreDataStack.context)

        sut.name = expectedName
        sut.isVolatile = expectedIsVolatile
        sut.assetPool = expectedAssetPool
        try sut.savePossession()

        let persistedPossessions = testingAssetRepository.fetchPossessions()
        XCTAssertTrue(persistedPossessions.count == 1)
        possession = try XCTUnwrap(persistedPossessions.first)

        let actualName = possession.name
        let actualIsVolatile = possession.volatile
        let actualAssetPool = possession.pool

        XCTAssertEqual(expectedName, actualName)
        XCTAssertEqual(expectedIsVolatile, actualIsVolatile)
        XCTAssertEqual(expectedAssetPool, actualAssetPool)
    }

    /// update a possession with an empty name and check whether the correct error is thrown
    func test_updatePossession_2() throws {
        let possession = testDataProvider.createAndPersistTestObjects_updatePossession_multipurpose(context: testingCoreDataStack.context)

        let sut = PossessionFormViewModel(possession: possession, repository: testingAssetRepository, dismissSheet: {})

        sut.name = ""
        XCTAssertThrowsError(try sut.savePossession()) { error in
            XCTAssertEqual(error as? PossessionValidationError, PossessionValidationError.emptyName)
        }
    }

    /// update a possession such that no assetPool is selected and check whether the correct error is thrown
    func test_updatePossession_3() throws {
        let possession = testDataProvider.createAndPersistTestObjects_updatePossession_multipurpose(context: testingCoreDataStack.context)

        let sut = PossessionFormViewModel(possession: possession, repository: testingAssetRepository, dismissSheet: {})

        sut.assetPool = nil
        XCTAssertThrowsError(try sut.savePossession()) { error in
            XCTAssertEqual(error as? PossessionValidationError, PossessionValidationError.noAssetPoolSelected)
        }
    }



    /// create a Possession
    func test_createPossession_1() throws {
        let assetPool = testDataProvider.createAndPersistTestObjects_createPossessions_multipurpose(context: testingCoreDataStack.context)

        let sut = PossessionFormViewModel(repository: testingAssetRepository, dismissSheet: {})

        let expectedName = "Commerzbank Konto"
        let expectedIsVolatile = false

        sut.name = expectedName
        sut.isVolatile = expectedIsVolatile
        sut.assetPool = assetPool
        try sut.savePossession()

        let persistedPossessions = testingAssetRepository.fetchPossessions()
        XCTAssertTrue(persistedPossessions.count == 1)
        let possession = try XCTUnwrap(persistedPossessions.first)

        let actualName = possession.name
        let actualIsVolatile = possession.volatile

        XCTAssertEqual(expectedName, actualName)
        XCTAssertEqual(expectedIsVolatile, actualIsVolatile)
    }

    /// create a possession with an empty name and check whether the correct error is thrown
    func test_createPossession_2() throws {
        let assetPool = testDataProvider.createAndPersistTestObjects_createPossessions_multipurpose(context: testingCoreDataStack.context)

        let sut = PossessionFormViewModel(repository: testingAssetRepository, dismissSheet: {})

        let expectedName = ""
        let expectedIsVolatile = false

        sut.name = expectedName
        sut.isVolatile = expectedIsVolatile
        sut.assetPool = assetPool
        XCTAssertThrowsError(try sut.savePossession()) { error in
            XCTAssertEqual(error as? PossessionValidationError, PossessionValidationError.emptyName)
        }
    }

    /// create a possession such that no assetPool is selected and check whether the correct error is thrown
    func test_createPossession_3() throws {
        let sut = PossessionFormViewModel(repository: testingAssetRepository, dismissSheet: {})

        let expectedName = "Commerzbank Konto"
        let expectedIsVolatile = false

        sut.name = expectedName
        sut.isVolatile = expectedIsVolatile
        sut.assetPool = nil
        XCTAssertThrowsError(try sut.savePossession()) { error in
            XCTAssertEqual(error as? PossessionValidationError, PossessionValidationError.noAssetPoolSelected)
        }
    }



    /// create 2 Possessions of the same name. Only the first one should be persisted
    func test_createPossessionsWithSameName_1() throws {
        let assetPool = testDataProvider.createAndPersistTestObjects_createPossessions_multipurpose(context: testingCoreDataStack.context)

        let sut = PossessionFormViewModel(repository: testingAssetRepository, dismissSheet: {})

        let firstExpectedName = "Commerzbank Konto"
        let firstExpectedIsVolatile = false

        sut.name = firstExpectedName
        sut.isVolatile = firstExpectedIsVolatile
        sut.assetPool = assetPool
        try sut.savePossession()

        let secondExpectedName = "Commerzbank Konto"
        let secondExpectedIsVolatile = true

        sut.name = secondExpectedName
        sut.isVolatile = secondExpectedIsVolatile
        sut.assetPool = assetPool
        XCTAssertThrowsError(try sut.savePossession()) { error in
            XCTAssertEqual(error as? PossessionValidationError, PossessionValidationError.sameNameAlreadyExists)
        }

        let persistedPossessions = testingAssetRepository.fetchPossessions()
        XCTAssertTrue(persistedPossessions.count == 1)
        let possession = try XCTUnwrap(persistedPossessions.first)

        let actualName = possession.name
        let actualIsVolatile = possession.volatile

        XCTAssertEqual(firstExpectedName, actualName)
        XCTAssertEqual(firstExpectedIsVolatile, actualIsVolatile)
    }

    /// create 1 Possession when a receivable of the same name already exists. The correct error should be thrown
    func test_createPossessionsWithSameName_2() throws {
        let (expectedReceivable,assetPool) = testDataProvider.createAndPersistTestObjects_createPossessionsWithSameName_2(context: testingCoreDataStack.context)

        let sut = PossessionFormViewModel(repository: testingAssetRepository, dismissSheet: {})
        
        sut.name = "Rote Sonne"
        sut.isVolatile = true
        sut.assetPool = assetPool
        XCTAssertThrowsError(try sut.savePossession()) { error in
            XCTAssertEqual(error as? PossessionValidationError, PossessionValidationError.sameNameAlreadyExists)
        }

        let persistedReceivables = testingAssetRepository.fetchReceivables()
        XCTAssertTrue(persistedReceivables.count == 1)
        let actualReceivable = try XCTUnwrap(persistedReceivables.first)

        XCTAssertEqual(expectedReceivable.name, actualReceivable.name)
        XCTAssertEqual(expectedReceivable.debtor, actualReceivable.debtor)
        XCTAssertEqual(expectedReceivable.grantDate, actualReceivable.grantDate)
        XCTAssertEqual(expectedReceivable.initialAmount, actualReceivable.initialAmount)
        XCTAssertEqual(expectedReceivable.repaidAmount, actualReceivable.repaidAmount)
    }



    /// delete one possession and test viewModel interface providing data to view as well as persisted data
    func test_deletePossession_1() throws {
        let (possessionToDelete, expectedPossessions) = testDataProvider.createAndPersistTestObjects_deletePossession_1(using: testingCoreDataStack.context)

        let sut = PossessionFormViewModel(repository: testingAssetRepository, dismissSheet: {})
        sut.possession = possessionToDelete
        sut.deletePossession()

        let actualPossessions = testingAssetRepository.fetchPossessions()
        XCTAssertTrue(expectedPossessions ≡ actualPossessions)
    }
}

