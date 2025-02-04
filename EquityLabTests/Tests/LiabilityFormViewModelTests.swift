import XCTest
@testable import EquityLab

final class LiabilityFormViewModelTests: XCTestCase {
    private var testingCoreDataStack: TestingCoreDataStack!
    private var testingLiabilityRepository: LiabilityRepository!
    private let testDataProvider = LiabilityFormViewModelTestDataProvider()
    
    override func setUpWithError() throws {
        testingCoreDataStack = TestingCoreDataStack()
        testingLiabilityRepository = LiabilityRepository(context: testingCoreDataStack.context)
    }
    
    
    
    /// test whether the getLiabilityPools() function returns the before persited assetpools
    func test_getLiabilityPools_1() throws {
        let expectedPools = testDataProvider.createAndPersistTestObjects_getLiabilityPools_1(using: testingCoreDataStack.context)
        
        let sut = LiabilityFormViewModel(liabilityRepository: testingLiabilityRepository, dismissSheet: {})
        
        let actualPools = sut.getLiabilityPools()
        XCTAssertTrue(expectedPools ≡ actualPools)
    }
    
    
    
    /// create a Liability
    func test_createLiability_1() throws {
        let (liabilityPool,creditor) = testDataProvider.createAndPersistTestObjects_createLiability_1(context: testingCoreDataStack.context)
        
        let sut = LiabilityFormViewModel(liabilityRepository: testingLiabilityRepository, dismissSheet: {})
        
        let expectedName = "Auto"
        let expectedCreditor = creditor
        let expectedPool = liabilityPool
        let expectedDisbursedAmount: Decimal = 1000.0
        let expectedDate = DateParser.shared.date(from: "2024-04-15T00:00:00")!
        
        sut.name = expectedName
        sut.grantDate = expectedDate
        sut.creditor = expectedCreditor
        sut.disbursedAmount = expectedDisbursedAmount
        sut.liabilityPool = liabilityPool
        try sut.saveLiability()
        
        let liabilities = testingLiabilityRepository.getLiabilities()
        XCTAssertTrue(liabilities.count == 1)
        let liability = try XCTUnwrap(liabilities.first)
        
        let actualName = liability.name
        let actualCreditor = liability.creditor
        let actualPool = liability.pool
        XCTAssertEqual(expectedName, actualName)
        XCTAssertEqual(expectedCreditor, actualCreditor)
        XCTAssertEqual(expectedPool, actualPool)
        
        let transactions = testingLiabilityRepository.getTransactions()
        XCTAssertTrue(transactions.count == 1)
        let transaction = try XCTUnwrap(transactions.filter{ $0.liability == liability }.first)
        let actualDisbursedAmount = transaction.amount.decimalValue
        let actualDate = transaction.date
        XCTAssertEqual(expectedDisbursedAmount, actualDisbursedAmount)
        XCTAssertEqual(expectedDate, actualDate)
    }
    
    /// create a Liability with an empty name and check whether the correct error is thrown
    func test_createLiability_2() throws {
        let (liabilityPool,creditor) = testDataProvider.createAndPersistTestObjects_createLiability_1(context: testingCoreDataStack.context)
        
        let sut = LiabilityFormViewModel(liabilityRepository: testingLiabilityRepository, dismissSheet: {})
        
        sut.name = ""
        sut.grantDate = DateParser.shared.date(from: "2024-04-15T00:00:00")!
        sut.creditor = creditor
        sut.disbursedAmount = 1000.0
        sut.liabilityPool = liabilityPool
        XCTAssertThrowsError(try sut.saveLiability()) { error in
            XCTAssertEqual(error as? LiabilityValidationError, LiabilityValidationError.emptyName)
        }
    }
    
    /// create a Liability with non-selected creditor  and check whether the correct error is thrown
    func test_createLiability_3() throws {
        let (liabilityPool,_) = testDataProvider.createAndPersistTestObjects_createLiability_1(context: testingCoreDataStack.context)
        
        let sut = LiabilityFormViewModel(liabilityRepository: testingLiabilityRepository, dismissSheet: {})
        
        sut.name = "Auto"
        sut.grantDate = DateParser.shared.date(from: "2024-04-15T00:00:00")!
        sut.disbursedAmount = 1000.0
        sut.liabilityPool = liabilityPool
        XCTAssertThrowsError(try sut.saveLiability()) { error in
            XCTAssertEqual(error as? LiabilityValidationError, LiabilityValidationError.noCreditorSelected)
        }
    }
    
    /// create a Liability where the disbursed amount is not strictly positive and check whether the correct error is thrown
    func test_createLiability_5() throws {
        let (liabilityPool,creditor) = testDataProvider.createAndPersistTestObjects_createLiability_1(context: testingCoreDataStack.context)
        
        let sut = LiabilityFormViewModel(liabilityRepository: testingLiabilityRepository, dismissSheet: {})
        
        sut.name = "Papa"
        sut.grantDate = DateParser.shared.date(from: "2024-04-15T00:00:00")!
        sut.creditor = creditor
        sut.disbursedAmount = 0
        sut.liabilityPool = liabilityPool
        XCTAssertThrowsError(try sut.saveLiability()) { error in
            XCTAssertEqual(error as? LiabilityValidationError, LiabilityValidationError.disbursedAmountNotStrictlyPositive)
        }
    }
    
    /// create a Liability such that no liabilityPool is selected and check whether the correct error is thrown
    func test_createLiability_6() throws {
        let (_,creditor) = testDataProvider.createAndPersistTestObjects_createLiability_1(context: testingCoreDataStack.context)
        
        let sut = LiabilityFormViewModel(liabilityRepository: testingLiabilityRepository, dismissSheet: {})
        
        sut.name = "Papa"
        sut.grantDate = DateParser.shared.date(from: "2024-04-15T00:00:00")!
        sut.creditor = creditor
        sut.disbursedAmount = 1000
        XCTAssertThrowsError(try sut.saveLiability()) { error in
            XCTAssertEqual(error as? LiabilityValidationError, LiabilityValidationError.noLiabilityPoolSelected)
        }
    }
    
    /// create a Liability with a name that is already taken by a different liability
    func test_createLiability_7() throws {
        let occupiedName = testDataProvider.createAndPersistTestObjects_createLiability_2(using: testingCoreDataStack.context)
        
        let sut = LiabilityFormViewModel(liabilityRepository: testingLiabilityRepository, dismissSheet: {})
        
        sut.name = occupiedName
        sut.grantDate = DateParser.shared.date(from: "2024-04-15T00:00:00")!
        sut.creditor = DataFactory.createLoanPartner(name: "Papa", context: testingCoreDataStack.context)
        sut.disbursedAmount = 100
        sut.liabilityPool = DataFactory.createLiabilityPool(named: "Privat", liabilities: [], in: testingCoreDataStack.context)
        XCTAssertThrowsError(try sut.saveLiability()) { error in
            XCTAssertEqual(error as? LiabilityValidationError, LiabilityValidationError.sameNameAlreadyExists)
        }
    }
    
    
    
    /// update a Liability
    func test_updateLiability_1() throws {
        let liabilityToUpdate = testDataProvider.createAndPersistTestObjects_updateOrDeleteLiability_1(context: testingCoreDataStack.context)
  
        let sut = LiabilityFormViewModel(liabilityRepository: testingLiabilityRepository, liability: liabilityToUpdate, dismissSheet: {})
        
        let expectedName = "Motorrad"
        let expectedCreditor = DataFactory.createLoanPartner(name: "Mama", context: testingCoreDataStack.context)
        let expectedLiabilityPool = DataFactory.createLiabilityPool(named: "Some other pool", liabilities: [], in: testingCoreDataStack.context)
        
        sut.name = expectedName
        sut.creditor = expectedCreditor
        sut.liabilityPool = expectedLiabilityPool
        try sut.saveLiability()
        
        let liabilities = testingLiabilityRepository.getLiabilities()
        XCTAssertTrue(liabilities.count == 1)
        let liability = try XCTUnwrap(liabilities.first)
        
        let actualName = liability.name
        let actualCreditor = liability.creditor
        let actualLiabilityPool = liability.pool
        
        XCTAssertEqual(expectedName, actualName)
        XCTAssertEqual(expectedCreditor, actualCreditor)
        XCTAssertEqual(expectedLiabilityPool, actualLiabilityPool)
    }
    
    /// update a Liability with an empty name and check whether the correct error is thrown
    func test_updateLiability_2() throws {
        let liabilityToUpdate = testDataProvider.createAndPersistTestObjects_updateOrDeleteLiability_1(context: testingCoreDataStack.context)
  
        let sut = LiabilityFormViewModel(liabilityRepository: testingLiabilityRepository, liability: liabilityToUpdate, dismissSheet: {})
        
        sut.name = ""
        XCTAssertThrowsError(try sut.saveLiability()) { error in
            XCTAssertEqual(error as? LiabilityValidationError, LiabilityValidationError.emptyName)
        }
    }
    
    /// update a Liability with non-selected creditor and check whether the correct error is thrown
    func test_updateLiability_3() throws {
        let liabilityToUpdate = testDataProvider.createAndPersistTestObjects_updateOrDeleteLiability_1(context: testingCoreDataStack.context)
  
        let sut = LiabilityFormViewModel(liabilityRepository: testingLiabilityRepository, liability: liabilityToUpdate, dismissSheet: {})
        
        sut.creditor = nil
        XCTAssertThrowsError(try sut.saveLiability()) { error in
            XCTAssertEqual(error as? LiabilityValidationError, LiabilityValidationError.noCreditorSelected)
        }
    }
    
    /// update a Liability such that no liabilityPool is selected and check whether the correct error is thrown
    func test_updateLiability_6() throws {
        let liabilityToUpdate = testDataProvider.createAndPersistTestObjects_updateOrDeleteLiability_1(context: testingCoreDataStack.context)
  
        let sut = LiabilityFormViewModel(liabilityRepository: testingLiabilityRepository, liability: liabilityToUpdate, dismissSheet: {})
        
        sut.liabilityPool = nil
        XCTAssertThrowsError(try sut.saveLiability()) { error in
            XCTAssertEqual(error as? LiabilityValidationError, LiabilityValidationError.noLiabilityPoolSelected)
        }
    }
    
    /// update a Liability with a name that already exists and check whether the correct error is thrown
    func test_updateLiability_7() throws {
        let (liabilityToUpdate,occupiedName) = testDataProvider.createAndPersistTestObjects_updateLiability_2(context: testingCoreDataStack.context)
  
        let sut = LiabilityFormViewModel(liabilityRepository: testingLiabilityRepository, liability: liabilityToUpdate, dismissSheet: {})
        
        sut.name = occupiedName
        XCTAssertThrowsError(try sut.saveLiability()) { error in
            XCTAssertEqual(error as? LiabilityValidationError, LiabilityValidationError.sameNameAlreadyExists)
        }
    }
    
    /// update a Liability with its previous name and check that no error is thrown
    func test_updateLiability_8() throws {
        let liabilityToUpdate = testDataProvider.createAndPersistTestObjects_updateOrDeleteLiability_1(context: testingCoreDataStack.context)
  
        let sut = LiabilityFormViewModel(liabilityRepository: testingLiabilityRepository, liability: liabilityToUpdate, dismissSheet: {})
        
        try sut.saveLiability()
    }
    
    
    
    /// delete a Liability
    func test_deleteLiability() throws {
        let liabilityToDelete = testDataProvider.createAndPersistTestObjects_updateOrDeleteLiability_1(context: testingCoreDataStack.context)
  
        let sut = LiabilityFormViewModel(liabilityRepository: testingLiabilityRepository, liability: liabilityToDelete, dismissSheet: {})
        
        sut.deleteLiability()
        
        let liabilities = testingLiabilityRepository.getLiabilities()
        XCTAssertTrue(liabilities.isEmpty)
    }
}
