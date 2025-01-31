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

        let sut = ReceivableFormViewModel(assetRepository: testingAssetRepository, dismissSheet: {})

        let actualPools = sut.getAssetPools()
        XCTAssertTrue(expectedPools ≡ actualPools)
    }



    /// create a Receivable
    func test_createReceivable_1() throws {
        let (assetPool,debtor) = testDataProvider.createAndPersistTestObjects_createReceivable_multipurpose(context: testingCoreDataStack.context)

        let sut = ReceivableFormViewModel(assetRepository: testingAssetRepository, dismissSheet: {})

        
        let expectedName = "Rote Sonne"
        let expectedDebtor = debtor
        let expectedPool = assetPool
        let expectedDisbursedAmount: Decimal = 200.0
        let expectedDate = DateParser.shared.date(from: "2024-07-23T00:00:00")!

        sut.name = expectedName
        sut.debtor = expectedDebtor
        sut.assetPool = expectedPool
        sut.disbursedAmount = expectedDisbursedAmount
        sut.grantDate = expectedDate
        try sut.saveReceivable()

        let persistedReceivables = testingAssetRepository.getReceivables()
        XCTAssertTrue(persistedReceivables.count == 1)
        let receivable = try XCTUnwrap(persistedReceivables.first)

        let actualName = receivable.name
        let actualDebtor = receivable.debtor
        let actualPool = receivable.pool

        XCTAssertEqual(expectedName, actualName)
        XCTAssertEqual(expectedDebtor, actualDebtor)
        XCTAssertEqual(expectedPool, actualPool)
        
        let transactions = testingAssetRepository.getTransactions()
        XCTAssertTrue(transactions.count == 1)
        let transaction = try XCTUnwrap(transactions.filter{ $0.receivable == receivable }.first)
        let actualDisbursedAmount = transaction.amount.decimalValue
        let actualDate = transaction.date
        XCTAssertEqual(expectedDisbursedAmount, actualDisbursedAmount)
        XCTAssertEqual(expectedDate, actualDate)
    }

    /// create a Receivable with an empty name and check whether the correct error is thrown
    func test_createReceivable_2() throws {
        let (assetPool,debtor) = testDataProvider.createAndPersistTestObjects_createReceivable_multipurpose(context: testingCoreDataStack.context)

        let sut = ReceivableFormViewModel(assetRepository: testingAssetRepository, dismissSheet: {})

        
        let expectedName = ""
        let expectedDebtor = debtor
        let expectedPool = assetPool
        let expectedDisbursedAmount: Decimal = 200.0
        let expectedDate = DateParser.shared.date(from: "2024-07-23T00:00:00")!

        sut.name = expectedName
        sut.debtor = expectedDebtor
        sut.assetPool = expectedPool
        sut.disbursedAmount = expectedDisbursedAmount
        sut.grantDate = expectedDate
        XCTAssertThrowsError(try sut.saveReceivable()) { error in
            XCTAssertEqual(error as? ReceivableValidationError, ReceivableValidationError.emptyName)
        }
    }

    /// create a Receivable without debtor and check whether the correct error is thrown
    func test_createReceivable_3() throws {
        let (assetPool,_) = testDataProvider.createAndPersistTestObjects_createReceivable_multipurpose(context: testingCoreDataStack.context)

        let sut = ReceivableFormViewModel(assetRepository: testingAssetRepository, dismissSheet: {})

        
        let expectedName = "Rote Sonne"
        let expectedPool = assetPool
        let expectedDisbursedAmount: Decimal = 200.0
        let expectedDate = DateParser.shared.date(from: "2024-07-23T00:00:00")!

        sut.name = expectedName
        sut.assetPool = expectedPool
        sut.disbursedAmount = expectedDisbursedAmount
        sut.grantDate = expectedDate
        XCTAssertThrowsError(try sut.saveReceivable()) { error in
            XCTAssertEqual(error as? ReceivableValidationError, ReceivableValidationError.noDebtorSelected)
        }
    }

    /// create a Receivable where the disbursed amount is not strictly positive and check whether the correct error is thrown
    func test_createReceivable_5() throws {
        let (assetPool,debtor) = testDataProvider.createAndPersistTestObjects_createReceivable_multipurpose(context: testingCoreDataStack.context)

        let sut = ReceivableFormViewModel(assetRepository: testingAssetRepository, dismissSheet: {})

        
        let expectedName = "Rote Sonne"
        let expectedDebtor = debtor
        let expectedPool = assetPool
        let expectedDisbursedAmount: Decimal = 0
        let expectedDate = DateParser.shared.date(from: "2024-07-23T00:00:00")!

        sut.name = expectedName
        sut.debtor = expectedDebtor
        sut.assetPool = expectedPool
        sut.disbursedAmount = expectedDisbursedAmount
        sut.grantDate = expectedDate
        XCTAssertThrowsError(try sut.saveReceivable()) { error in
            XCTAssertEqual(error as? ReceivableValidationError, ReceivableValidationError.disbursedAmountNotStrictlyPositive)
        }
    }

    /// create a Receivable such that no assetPool is selected and check whether the correct error is thrown
    func test_createReceivable_6() throws {
        let (_,debtor) = testDataProvider.createAndPersistTestObjects_createReceivable_multipurpose(context: testingCoreDataStack.context)

        let sut = ReceivableFormViewModel(assetRepository: testingAssetRepository, dismissSheet: {})

        
        let expectedName = "Rote Sonne"
        let expectedDebtor = debtor
        let expectedDisbursedAmount: Decimal = 200.0
        let expectedDate = DateParser.shared.date(from: "2024-07-23T00:00:00")!

        sut.name = expectedName
        sut.debtor = expectedDebtor
        sut.disbursedAmount = expectedDisbursedAmount
        sut.grantDate = expectedDate
        XCTAssertThrowsError(try sut.saveReceivable()) { error in
            XCTAssertEqual(error as? ReceivableValidationError, ReceivableValidationError.noAssetPoolSelected)
        }
    }
    
    /// create a Receivable with a name that is already taken by a different Receivable
    func test_createReceivable_7() throws {
        let occupiedName = testDataProvider.createAndPersistTestObjects_createReceivablesWithSameName_1(context: testingCoreDataStack.context)
        
        let sut = ReceivableFormViewModel(assetRepository: testingAssetRepository, dismissSheet: {})
        
        sut.name = occupiedName
        sut.grantDate = DateParser.shared.date(from: "2024-04-15T00:00:00")!
        sut.debtor = DataFactory.createLoanPartner(name: "Papa", context: testingCoreDataStack.context)
        sut.disbursedAmount = 100
        sut.assetPool = DataFactory.createAssetPool(named: "Privat", possessions: [], receivables: [], in: testingCoreDataStack.context)
        XCTAssertThrowsError(try sut.saveReceivable()) { error in
            XCTAssertEqual(error as? ReceivableValidationError, ReceivableValidationError.sameNameAlreadyExists)
        }
    }

    /// create a Receivable with a name that is already taken by a Possession
    func test_createReceivable_8() throws {
        let occupiedName = testDataProvider.createAndPersistTestObjects_createReceivablesWithSameName_2(context: testingCoreDataStack.context)

        let sut = ReceivableFormViewModel(assetRepository: testingAssetRepository, dismissSheet: {})
        
        sut.name = occupiedName
        sut.grantDate = DateParser.shared.date(from: "2024-04-15T00:00:00")!
        sut.debtor = DataFactory.createLoanPartner(name: "Papa", context: testingCoreDataStack.context)
        sut.disbursedAmount = 100
        sut.assetPool = DataFactory.createAssetPool(named: "Privat", possessions: [], receivables: [], in: testingCoreDataStack.context)
        XCTAssertThrowsError(try sut.saveReceivable()) { error in
            XCTAssertEqual(error as? ReceivableValidationError, ReceivableValidationError.sameNameAlreadyExists)
        }

    }
    
    
    
    /// update a Receivable
    func test_updateReceivable_1() throws {
        var receivable = testDataProvider.createAndPersistTestObjects_updateReceivable_multipurpose(context: testingCoreDataStack.context)

        let sut = ReceivableFormViewModel(assetRepository: testingAssetRepository, receivable: receivable, dismissSheet: {})

        let expectedName = "Rote Sonne"
        let expectedDebtor = DataFactory.createLoanPartner(name: "Philipp", context: testingCoreDataStack.context)
        let expectedAssetPool = DataFactory.createAssetPool(named: "Some other pool", possessions: [], receivables: [], in: testingCoreDataStack.context)

        sut.name = expectedName
        sut.debtor = expectedDebtor
        sut.assetPool = expectedAssetPool
        try sut.saveReceivable()
        
        let persistedReceivables = testingAssetRepository.getReceivables()
        XCTAssertTrue(persistedReceivables.count == 1)
        receivable = try XCTUnwrap(persistedReceivables.first)

        let actualName = receivable.name
        let actualDebtor = receivable.debtor
        let actualAssetPool = receivable.pool

        XCTAssertEqual(expectedName, actualName)
        XCTAssertEqual(expectedDebtor, actualDebtor)
        XCTAssertEqual(expectedAssetPool, actualAssetPool)
    }

    /// update a Receivable with an empty name and check whether the correct error is thrown
    func test_updateReceivable_2() throws {
        let receivable = testDataProvider.createAndPersistTestObjects_updateReceivable_multipurpose(context: testingCoreDataStack.context)

        let sut = ReceivableFormViewModel(assetRepository: testingAssetRepository, receivable: receivable, dismissSheet: {})

        let expectedDebtor = DataFactory.createLoanPartner(name: "Philipp", context: testingCoreDataStack.context)
        let expectedAssetPool = DataFactory.createAssetPool(named: "Some other pool", possessions: [], receivables: [], in: testingCoreDataStack.context)

        sut.name = ""
        sut.debtor = expectedDebtor
        sut.assetPool = expectedAssetPool
        XCTAssertThrowsError(try sut.saveReceivable()) { error in
            XCTAssertEqual(error as? ReceivableValidationError, ReceivableValidationError.emptyName)
        }
    }

    /// update a Receivable with a non-selected debtor and check whether the correct error is thrown
    func test_updateReceivable_3() throws {
        let receivable = testDataProvider.createAndPersistTestObjects_updateReceivable_multipurpose(context: testingCoreDataStack.context)

        let sut = ReceivableFormViewModel(assetRepository: testingAssetRepository, receivable: receivable, dismissSheet: {})

        let expectedName = "Rote Sonne"
        let expectedAssetPool = DataFactory.createAssetPool(named: "Some other pool", possessions: [], receivables: [], in: testingCoreDataStack.context)

        sut.name = expectedName
        sut.debtor = nil
        sut.assetPool = expectedAssetPool
        XCTAssertThrowsError(try sut.saveReceivable()) { error in
            XCTAssertEqual(error as? ReceivableValidationError, ReceivableValidationError.noDebtorSelected)
        }
    }

    /// update a Receivable such that no assetPool is selected and check whether the correct error is thrown
    func test_updateReceivable_6() throws {
        let receivable = testDataProvider.createAndPersistTestObjects_updateReceivable_multipurpose(context: testingCoreDataStack.context)

        let sut = ReceivableFormViewModel(assetRepository: testingAssetRepository, receivable: receivable, dismissSheet: {})

        let expectedName = "Rote Sonne"
        let expectedDebtor = DataFactory.createLoanPartner(name: "Philipp", context: testingCoreDataStack.context)

        sut.name = expectedName
        sut.debtor = expectedDebtor
        sut.assetPool = nil
        XCTAssertThrowsError(try sut.saveReceivable()) { error in
            XCTAssertEqual(error as? ReceivableValidationError, ReceivableValidationError.noAssetPoolSelected)
        }
    }
    
    /// update a Receivable with a name that already exists and check whether the correct error is thrown
    func test_updateLiability_7() throws {
        let (receivable,occupiedName) = testDataProvider.createAndPersistTestObjects_updateReceivablesWithSameName_1(context: testingCoreDataStack.context)
  
        let sut = ReceivableFormViewModel(assetRepository: testingAssetRepository, receivable: receivable, dismissSheet: {})
        
        sut.name = occupiedName
        XCTAssertThrowsError(try sut.saveReceivable()) { error in
            XCTAssertEqual(error as? ReceivableValidationError, ReceivableValidationError.sameNameAlreadyExists)
        }
    }
    
    /// update a Receivable with its previous name and check that no error is thrown
    func test_updateLiability_8() throws {
        let (receivable,occupiedName) = testDataProvider.createAndPersistTestObjects_updateReceivablesWithSameName_2(context: testingCoreDataStack.context)
  
        let sut = ReceivableFormViewModel(assetRepository: testingAssetRepository, receivable: receivable, dismissSheet: {})
        
        sut.name = occupiedName
        XCTAssertThrowsError(try sut.saveReceivable()) { error in
            XCTAssertEqual(error as? ReceivableValidationError, ReceivableValidationError.sameNameAlreadyExists)
        }
    }
    
    
    
    /// delete a Receivable
    func test_deleteReceivable() throws {
        let receivableToDelete = testDataProvider.createAndPersistTestObjects_updateReceivable_multipurpose(context: testingCoreDataStack.context)
  
        let sut = ReceivableFormViewModel(assetRepository: testingAssetRepository, receivable: receivableToDelete, dismissSheet: {})
        
        sut.deleteReceivable()
        
        let receivables = testingAssetRepository.getReceivables()
        XCTAssertTrue(receivables.isEmpty)
    }
}


