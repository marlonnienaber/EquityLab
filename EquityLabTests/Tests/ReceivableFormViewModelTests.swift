import XCTest
@testable import EquityLab

final class ReceivableFormViewModelTests: XCTestCase {
    private var testingCoreDataStack: TestingCoreDataStack!
    private var testingAssetRepository: AssetRepository!
    private let testDataProvider = ReceivableFormViewModelTestDataProvider()
    
    override func setUpWithError() throws {
        testingCoreDataStack = TestingCoreDataStack()
        testingAssetRepository = AssetRepository(context: testingCoreDataStack.context)
    }
    
    
    
    /// test whether the getAssetPools() function returns the before persited assetpools
    func test_getAssetPools_1() throws {
        let expectedPools = testDataProvider.createAndPersitsTestObjects_getAssetPools_1(using: testingCoreDataStack.context)

        let sut = ReceivableFormViewModel(repository: testingAssetRepository, dismissSheet: {})

        let actualPools = sut.getAssetPools()
        XCTAssertTrue(expectedPools ≡ actualPools)
    }



    /// update a receivable
    func test_updateReceivable_1() throws {
        var receivable = testDataProvider.createAndPersistTestObjects_updateReceivable_multipurpose(context: testingCoreDataStack.context)

        let sut = ReceivableFormViewModel(receivable: receivable, repository: testingAssetRepository, dismissSheet: {})

        let expectedName = "Rote Sonne"
        let expectedDebtor = "Philipp"
        let expectedGrantDate = DateParser.shared.date(from: "2024-07-23T00:00:00")!
        let expectedInitialAmount: Decimal = 200.0
        let expectedRepaidAmount: Decimal = 40.0
        let expectedAssetPool = DataFactory.createAssetPool(named: "Some other pool", possessions: [], receivables: [], in: testingCoreDataStack.context)

        sut.name = expectedName
        sut.debtor = expectedDebtor
        sut.grantDate = expectedGrantDate
        sut.initialAmount = expectedInitialAmount
        sut.repaidAmount = expectedRepaidAmount
        sut.assetPool = expectedAssetPool
        try sut.saveReceivable()

        let persistedReceivables = testingAssetRepository.fetchReceivables()
        XCTAssertTrue(persistedReceivables.count == 1)
        receivable = try XCTUnwrap(persistedReceivables.first)

        let actualName = receivable.name
        let actualDebtor = receivable.debtor
        let actualGrantDate = receivable.grantDate
        let actualInitialAmount = receivable.initialAmount.decimalValue
        let actualRepaidAmount = receivable.repaidAmount.decimalValue
        let actualAssetPool = receivable.pool

        XCTAssertEqual(expectedName, actualName)
        XCTAssertEqual(expectedDebtor, actualDebtor)
        XCTAssertEqual(expectedGrantDate, actualGrantDate)
        XCTAssertEqual(expectedInitialAmount, actualInitialAmount)
        XCTAssertEqual(expectedRepaidAmount, actualRepaidAmount)
        XCTAssertEqual(expectedAssetPool, actualAssetPool)
    }

    /// update a receivable with an empty name and check whether the correct error is thrown
    func test_updateReceivable_2() throws {
        let receivable = testDataProvider.createAndPersistTestObjects_updateReceivable_multipurpose(context: testingCoreDataStack.context)

        let sut = ReceivableFormViewModel(receivable: receivable, repository: testingAssetRepository, dismissSheet: {})

        sut.name = ""

        XCTAssertThrowsError(try sut.saveReceivable()) { error in
            XCTAssertEqual(error as? ReceivableValidationError, ReceivableValidationError.emptyName)
        }
    }

    /// update a receivable with an debtor and check whether the correct error is thrown
    func test_updateReceivable_3() throws {
        let receivable = testDataProvider.createAndPersistTestObjects_updateReceivable_multipurpose(context: testingCoreDataStack.context)

        let sut = ReceivableFormViewModel(receivable: receivable, repository: testingAssetRepository, dismissSheet: {})

        sut.debtor = ""

        XCTAssertThrowsError(try sut.saveReceivable()) { error in
            XCTAssertEqual(error as? ReceivableValidationError, ReceivableValidationError.emptyDebtor)
        }
    }

    /// update a receivable with an initial amount which is not strictly positive and check whether the correct error is thrown
    func test_updateReceivable_4() throws {
        let receivable = testDataProvider.createAndPersistTestObjects_updateReceivable_multipurpose(context: testingCoreDataStack.context)

        let sut = ReceivableFormViewModel(receivable: receivable, repository: testingAssetRepository, dismissSheet: {})

        sut.initialAmount = 0.0
        sut.repaidAmount = 0.0

        XCTAssertThrowsError(try sut.saveReceivable()) { error in
            XCTAssertEqual(error as? ReceivableValidationError, ReceivableValidationError.initialAmountNotStrictlyPositive)
        }
    }

    /// update a receivable such that the repaid amount is bigger than the repaid amount and check whether the correct error is thrown
    func test_updateReceivable_5() throws {
        let receivable = testDataProvider.createAndPersistTestObjects_updateReceivable_multipurpose(context: testingCoreDataStack.context)

        let sut = ReceivableFormViewModel(receivable: receivable, repository: testingAssetRepository, dismissSheet: {})

        sut.initialAmount = 10.0
        sut.repaidAmount = 20.0

        XCTAssertThrowsError(try sut.saveReceivable()) { error in
            XCTAssertEqual(error as? ReceivableValidationError, ReceivableValidationError.repaidSurpassesInitialAmount)
        }
    }

    /// update a receivable such that no assetPool is selected and check whether the correct error is thrown
    func test_updateReceivable_6() throws {
        let receivable = testDataProvider.createAndPersistTestObjects_updateReceivable_multipurpose(context: testingCoreDataStack.context)

        let sut = ReceivableFormViewModel(receivable: receivable, repository: testingAssetRepository, dismissSheet: {})

        sut.assetPool = nil

        XCTAssertThrowsError(try sut.saveReceivable()) { error in
            XCTAssertEqual(error as? ReceivableValidationError, ReceivableValidationError.noAssetPoolSelected)
        }
    }



    /// create a Receivable
    func test_createReceivable_1() throws {
        let assetPool = testDataProvider.createAndPersistTestObjects_createReceivable_multipurpose(context: testingCoreDataStack.context)

        let sut = ReceivableFormViewModel(repository: testingAssetRepository, dismissSheet: {})

        let expectedName = "Rote Sonne"
        let expectedDebtor = "Philipp"
        let expectedGrantDate = DateParser.shared.date(from: "2024-07-23T00:00:00")!
        let expectedInitialAmount: Decimal = 200.0
        let expectedRepaidAmount: Decimal = 40.0

        sut.name = expectedName
        sut.debtor = expectedDebtor
        sut.grantDate = expectedGrantDate
        sut.initialAmount = expectedInitialAmount
        sut.repaidAmount = expectedRepaidAmount
        sut.assetPool = assetPool
        try sut.saveReceivable()

        let persistedReceivables = testingAssetRepository.fetchReceivables()
        XCTAssertTrue(persistedReceivables.count == 1)
        let receivable = try XCTUnwrap(persistedReceivables.first)

        let actualName = receivable.name
        let actualDebtor = receivable.debtor
        let actualGrantDate = receivable.grantDate
        let actualInitialAmount = receivable.initialAmount.decimalValue
        let actualRepaidAmount = receivable.repaidAmount.decimalValue

        XCTAssertEqual(expectedName, actualName)
        XCTAssertEqual(expectedDebtor, actualDebtor)
        XCTAssertEqual(expectedGrantDate, actualGrantDate)
        XCTAssertEqual(expectedInitialAmount, actualInitialAmount)
        XCTAssertEqual(expectedRepaidAmount, actualRepaidAmount)
    }

    /// create a Receivable with an empty name and check whether the correct error is thrown
    func test_createReceivable_2() throws {
        let assetPool = testDataProvider.createAndPersistTestObjects_createReceivable_multipurpose(context: testingCoreDataStack.context)

        let sut = ReceivableFormViewModel(repository: testingAssetRepository, dismissSheet: {})

        let expectedName = ""
        let expectedDebtor = "Philipp"
        let expectedGrantDate = DateParser.shared.date(from: "2024-07-23T00:00:00")!
        let expectedInitialAmount: Decimal = 200.0
        let expectedRepaidAmount: Decimal = 40.0

        sut.name = expectedName
        sut.debtor = expectedDebtor
        sut.grantDate = expectedGrantDate
        sut.initialAmount = expectedInitialAmount
        sut.repaidAmount = expectedRepaidAmount
        sut.assetPool = assetPool
        XCTAssertThrowsError(try sut.saveReceivable()) { error in
            XCTAssertEqual(error as? ReceivableValidationError, ReceivableValidationError.emptyName)
        }
    }

    /// create a Receivable without debtor and check whether the correct error is thrown
    func test_createReceivable_3() throws {
        let assetPool = testDataProvider.createAndPersistTestObjects_createReceivable_multipurpose(context: testingCoreDataStack.context)

        let sut = ReceivableFormViewModel(repository: testingAssetRepository, dismissSheet: {})

        let expectedName = "Some name"
        let expectedGrantDate = DateParser.shared.date(from: "2024-07-23T00:00:00")!
        let expectedInitialAmount: Decimal = 200.0
        let expectedRepaidAmount: Decimal = 40.0

        sut.name = expectedName
        sut.grantDate = expectedGrantDate
        sut.initialAmount = expectedInitialAmount
        sut.repaidAmount = expectedRepaidAmount
        sut.assetPool = assetPool
        XCTAssertThrowsError(try sut.saveReceivable()) { error in
            XCTAssertEqual(error as? ReceivableValidationError, ReceivableValidationError.emptyDebtor)
        }
    }

    /// create a Receivable where the repaid amount surpasses the  initial amount and check whether the correct error is thrown
    func test_createReceivable_4() throws {
        let assetPool = testDataProvider.createAndPersistTestObjects_createReceivable_multipurpose(context: testingCoreDataStack.context)

        let sut = ReceivableFormViewModel(repository: testingAssetRepository, dismissSheet: {})

        let expectedName = "Some name"
        let expectedDebtor = "Someone"
        let expectedGrantDate = DateParser.shared.date(from: "2024-07-23T00:00:00")!
        let expectedInitialAmount: Decimal = 40.0
        let expectedRepaidAmount: Decimal = 200.0

        sut.name = expectedName
        sut.debtor = expectedDebtor
        sut.grantDate = expectedGrantDate
        sut.initialAmount = expectedInitialAmount
        sut.repaidAmount = expectedRepaidAmount
        sut.assetPool = assetPool
        XCTAssertThrowsError(try sut.saveReceivable()) { error in
            XCTAssertEqual(error as? ReceivableValidationError, ReceivableValidationError.repaidSurpassesInitialAmount)
        }
    }

    /// create a Receivable where the initial amount is not strictly positive and check whether the correct error is thrown
    func test_createReceivable_5() throws {
        let assetPool = testDataProvider.createAndPersistTestObjects_createReceivable_multipurpose(context: testingCoreDataStack.context)

        let sut = ReceivableFormViewModel(repository: testingAssetRepository, dismissSheet: {})

        let expectedName = "Some name"
        let expectedDebtor = "Someone"
        let expectedGrantDate = DateParser.shared.date(from: "2024-07-23T00:00:00")!
        let expectedInitialAmount: Decimal = 0.0
        let expectedRepaidAmount: Decimal = 0.0

        sut.name = expectedName
        sut.debtor = expectedDebtor
        sut.grantDate = expectedGrantDate
        sut.initialAmount = expectedInitialAmount
        sut.repaidAmount = expectedRepaidAmount
        sut.assetPool = assetPool
        XCTAssertThrowsError(try sut.saveReceivable()) { error in
            XCTAssertEqual(error as? ReceivableValidationError, ReceivableValidationError.initialAmountNotStrictlyPositive)
        }
    }

    /// create a Receivable such that no assetPool is selected and check whether the correct error is thrown
    func test_createReceivable_6() throws {
        let sut = ReceivableFormViewModel(repository: testingAssetRepository, dismissSheet: {})

        let expectedName = "Some name"
        let expectedDebtor = "Someone"
        let expectedGrantDate = DateParser.shared.date(from: "2024-07-23T00:00:00")!
        let expectedInitialAmount: Decimal = 20.0
        let expectedRepaidAmount: Decimal = 0.0

        sut.name = expectedName
        sut.debtor = expectedDebtor
        sut.grantDate = expectedGrantDate
        sut.initialAmount = expectedInitialAmount
        sut.repaidAmount = expectedRepaidAmount
        sut.assetPool = nil
        XCTAssertThrowsError(try sut.saveReceivable()) { error in
            XCTAssertEqual(error as? ReceivableValidationError, ReceivableValidationError.noAssetPoolSelected)
        }
    }



    /// create 2 Receivables of the same name. Only the first one should be persisted
    func test_createReceivablesWithSameName_1() throws {
        let assetPool = testDataProvider.createAndPersistTestObjects_createReceivable_multipurpose(context: testingCoreDataStack.context)

        let sut = ReceivableFormViewModel(repository: testingAssetRepository, dismissSheet: {})

        let firstExpectedName = "Rote Sonne"
        let firstExpectedDebtor = "Philipp"
        let firstExpectedGrantDate = DateParser.shared.date(from: "2024-07-23T00:00:00")!
        let firstExpectedInitialAmount: Decimal = 200.0
        let firstExpectedRepaidAmount: Decimal = 40.0

        sut.name = firstExpectedName
        sut.debtor = firstExpectedDebtor
        sut.grantDate = firstExpectedGrantDate
        sut.initialAmount = firstExpectedInitialAmount
        sut.repaidAmount = firstExpectedRepaidAmount
        sut.assetPool = assetPool
        try sut.saveReceivable()

        let secondExpectedName = "Rote Sonne"
        let secondExpectedDebtor = "Lenni"
        let secondExpectedGrantDate = DateParser.shared.date(from: "2024-07-22T00:00:00")!
        let secondExpectedInitialAmount: Decimal = 100.0
        let secondExpectedRepaidAmount: Decimal = 20.0

        sut.name = secondExpectedName
        sut.debtor = secondExpectedDebtor
        sut.grantDate = secondExpectedGrantDate
        sut.initialAmount = secondExpectedInitialAmount
        sut.repaidAmount = secondExpectedRepaidAmount
        sut.assetPool = assetPool
        XCTAssertThrowsError(try sut.saveReceivable()) { error in
            XCTAssertEqual(error as? ReceivableValidationError, ReceivableValidationError.sameNameAlreadyExists)
        }

        let persistedReceivables = testingAssetRepository.fetchReceivables()
        XCTAssertTrue(persistedReceivables.count == 1)
        let receivable = try XCTUnwrap(persistedReceivables.first)


        let actualName = receivable.name
        let actualDebtor = receivable.debtor
        let actualGrantDate = receivable.grantDate
        let actualInitialAmount = receivable.initialAmount.decimalValue
        let actualRepaidAmount = receivable.repaidAmount.decimalValue

        XCTAssertEqual(firstExpectedName, actualName)
        XCTAssertEqual(firstExpectedDebtor, actualDebtor)
        XCTAssertEqual(firstExpectedGrantDate, actualGrantDate)
        XCTAssertEqual(firstExpectedInitialAmount, actualInitialAmount)
        XCTAssertEqual(firstExpectedRepaidAmount, actualRepaidAmount)
    }

    /// create 1 Possession and then 1 Receivable of the same name. Only the first one created should be persisted
    func test_createReceivablesWithSameName_2() throws {
        let (expectedPossession,assetPool) = testDataProvider.createAndPersistTestObjects_createReceivablesWithSameName_2(context: testingCoreDataStack.context)

        let sut = ReceivableFormViewModel(repository: testingAssetRepository, dismissSheet: {})

        let secondExpectedName = "Commerzbank Konto"
        let secondExpectedDebtor = "Lenni"
        let secondExpectedGrantDate = DateParser.shared.date(from: "2024-07-22T00:00:00")!
        let secondExpectedInitialAmount: Decimal = 100.0
        let secondExpectedRepaidAmount: Decimal = 20.0

        sut.name = secondExpectedName
        sut.debtor = secondExpectedDebtor
        sut.grantDate = secondExpectedGrantDate
        sut.initialAmount = secondExpectedInitialAmount
        sut.repaidAmount = secondExpectedRepaidAmount
        sut.assetPool = assetPool
        XCTAssertThrowsError(try sut.saveReceivable()) { error in
            XCTAssertEqual(error as? ReceivableValidationError, ReceivableValidationError.sameNameAlreadyExists)
        }

        let persistedPossessions = testingAssetRepository.fetchPossessions()
        XCTAssertTrue(persistedPossessions.count == 1)
        let actualPossession = try XCTUnwrap(persistedPossessions.first)

        XCTAssertEqual(expectedPossession.name, actualPossession.name)
        XCTAssertEqual(expectedPossession.volatile, actualPossession.volatile)
    }



    /// delete one asset and test viewModel interface providing data to view as well as persisted data
    func test_deleteReceivable_1() throws {
        let (receivableToDelete, expectedReceivables) = testDataProvider.createAndPersistTestObjects_deleteReceivable_1(using: testingCoreDataStack.context)

        let sut = ReceivableFormViewModel(repository: testingAssetRepository, dismissSheet: {})
        sut.receivable = receivableToDelete
        sut.deleteReceivable()

        let actualReceivables = testingAssetRepository.fetchReceivables()
        XCTAssertTrue(expectedReceivables ≡ actualReceivables)
    }
}


