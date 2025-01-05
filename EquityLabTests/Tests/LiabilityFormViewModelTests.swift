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
        
        let sut = LiabilityFormViewModel(repository: testingLiabilityRepository, dismissSheet: {})
        
        let actualPools = sut.getLiabilityPools()
        XCTAssertTrue(expectedPools ≡ actualPools)
    }
    
    
    
    /// create a Liability
    func test_createLiability_1() throws {
        let liabilityPool = testDataProvider.createAndPersistTestObjects_createLiability_1(context: testingCoreDataStack.context)
        
        let sut = LiabilityFormViewModel(repository: testingLiabilityRepository, dismissSheet: {})
        
        let expectedName = "Auto"
        let expectedDate = DateParser.shared.date(from: "2024-04-15T00:00:00")!
        let expectedCreditor = "Papa"
        let expectedInitialAmount: Decimal = 1000.0
        let expectedRepaidAmount: Decimal = 200.0
        
        sut.liabilityName = expectedName
        sut.liabilityGrantDate = expectedDate
        sut.liabilityCreditor = expectedCreditor
        sut.liabilityInitialAmount = expectedInitialAmount
        sut.liabilityRepaidAmount = expectedRepaidAmount
        sut.liabilityPool = liabilityPool
        try sut.saveLiability()
        
        let liabilities = testingLiabilityRepository.getLiabilities()
        XCTAssertTrue(liabilities.count == 1)
        let liability = try XCTUnwrap(liabilities.first)
        
        let actualName = liability.name
        let actualDate = liability.grantDate
        let actualCreditor = liability.creditor
        let actualInitialAmount = liability.initialAmount.decimalValue
        let actualRepaidAmount = liability.repaidAmount.decimalValue
        
        XCTAssertEqual(expectedName, actualName)
        XCTAssertEqual(expectedDate, actualDate)
        XCTAssertEqual(expectedCreditor, actualCreditor)
        XCTAssertEqual(expectedInitialAmount, actualInitialAmount)
        XCTAssertEqual(expectedRepaidAmount, actualRepaidAmount)
    }
    
    /// create a Liability with an empty name and check whether the correct error is thrown
    func test_createLiability_2() throws {
        let liabilityPool = testDataProvider.createAndPersistTestObjects_createLiability_1(context: testingCoreDataStack.context)
        
        let sut = LiabilityFormViewModel(repository: testingLiabilityRepository, dismissSheet: {})
        
        let expectedName = ""
        let expectedDate = DateParser.shared.date(from: "2024-04-15T00:00:00")!
        let expectedCreditor = "Papa"
        let expectedInitialAmount: Decimal = 1000.0
        let expectedRepaidAmount: Decimal = 200.0
        
        sut.liabilityName = expectedName
        sut.liabilityGrantDate = expectedDate
        sut.liabilityCreditor = expectedCreditor
        sut.liabilityInitialAmount = expectedInitialAmount
        sut.liabilityRepaidAmount = expectedRepaidAmount
        sut.liabilityPool = liabilityPool
        XCTAssertThrowsError(try sut.saveLiability()) { error in
            XCTAssertEqual(error as? LiabilityValidationError, LiabilityValidationError.emptyName)
        }
    }
    
    /// create a Liability with an creditor debtor and check whether the correct error is thrown
    func test_createLiability_3() throws {
        let liabilityPool = testDataProvider.createAndPersistTestObjects_createLiability_1(context: testingCoreDataStack.context)
        
        let sut = LiabilityFormViewModel(repository: testingLiabilityRepository, dismissSheet: {})
        
        let expectedName = "Auto"
        let expectedDate = DateParser.shared.date(from: "2024-04-15T00:00:00")!
        let expectedCreditor = ""
        let expectedInitialAmount: Decimal = 1000.0
        let expectedRepaidAmount: Decimal = 200.0
        
        sut.liabilityName = expectedName
        sut.liabilityGrantDate = expectedDate
        sut.liabilityCreditor = expectedCreditor
        sut.liabilityInitialAmount = expectedInitialAmount
        sut.liabilityRepaidAmount = expectedRepaidAmount
        sut.liabilityPool = liabilityPool
        XCTAssertThrowsError(try sut.saveLiability()) { error in
            XCTAssertEqual(error as? LiabilityValidationError, LiabilityValidationError.emptyCreditor)
        }
    }
    
    /// create a Liability where the repaid amount surpasses the  initial amount and check whether the correct error is thrown
    func test_createLiability_4() throws {
        let liabilityPool = testDataProvider.createAndPersistTestObjects_createLiability_1(context: testingCoreDataStack.context)
        
        let sut = LiabilityFormViewModel(repository: testingLiabilityRepository, dismissSheet: {})
        
        let expectedName = "Auto"
        let expectedDate = DateParser.shared.date(from: "2024-04-15T00:00:00")!
        let expectedCreditor = "Papa"
        let expectedInitialAmount: Decimal = 100.0
        let expectedRepaidAmount: Decimal = 200.0
        
        sut.liabilityName = expectedName
        sut.liabilityGrantDate = expectedDate
        sut.liabilityCreditor = expectedCreditor
        sut.liabilityInitialAmount = expectedInitialAmount
        sut.liabilityRepaidAmount = expectedRepaidAmount
        sut.liabilityPool = liabilityPool
        XCTAssertThrowsError(try sut.saveLiability()) { error in
            XCTAssertEqual(error as? LiabilityValidationError, LiabilityValidationError.repaidSurpassesInitialAmount)
        }
    }
    
    /// create a Liability where the initial amount is not strictly positive and check whether the correct error is thrown
    func test_createLiability_5() throws {
        let liabilityPool = testDataProvider.createAndPersistTestObjects_createLiability_1(context: testingCoreDataStack.context)
        
        let sut = LiabilityFormViewModel(repository: testingLiabilityRepository, dismissSheet: {})
        
        let expectedName = "Auto"
        let expectedDate = DateParser.shared.date(from: "2024-04-15T00:00:00")!
        let expectedCreditor = "Papa"
        let expectedInitialAmount: Decimal = 0.0
        let expectedRepaidAmount: Decimal = 0.0
        
        sut.liabilityName = expectedName
        sut.liabilityGrantDate = expectedDate
        sut.liabilityCreditor = expectedCreditor
        sut.liabilityInitialAmount = expectedInitialAmount
        sut.liabilityRepaidAmount = expectedRepaidAmount
        sut.liabilityPool = liabilityPool
        XCTAssertThrowsError(try sut.saveLiability()) { error in
            XCTAssertEqual(error as? LiabilityValidationError, LiabilityValidationError.initialAmountNotStrictlyPositive)
        }
    }
    
    /// create a Liability such that no assetPool is selected and check whether the correct error is thrown
    func test_createLiability_6() throws {
        let sut = LiabilityFormViewModel(repository: testingLiabilityRepository, dismissSheet: {})
        
        let expectedName = "Auto"
        let expectedDate = DateParser.shared.date(from: "2024-04-15T00:00:00")!
        let expectedCreditor = "Papa"
        let expectedInitialAmount: Decimal = 1000.0
        let expectedRepaidAmount: Decimal = 200.0
        
        sut.liabilityName = expectedName
        sut.liabilityGrantDate = expectedDate
        sut.liabilityCreditor = expectedCreditor
        sut.liabilityInitialAmount = expectedInitialAmount
        sut.liabilityRepaidAmount = expectedRepaidAmount
        sut.liabilityPool = nil
        XCTAssertThrowsError(try sut.saveLiability()) { error in
            XCTAssertEqual(error as? LiabilityValidationError, LiabilityValidationError.noLiabilityPoolSelected)
        }
    }
    
    
    
    /// update a Liability
    func test_updateLiability_1() throws {
        let liabilityToUpdate = testDataProvider.createAndPersistTestObjects_updateLiability_1(context: testingCoreDataStack.context)
  
        let sut = LiabilityFormViewModel(liability: liabilityToUpdate, repository: testingLiabilityRepository, dismissSheet: {})
        
        let expectedName = liabilityToUpdate.name
        let expectedDate = DateParser.shared.date(from: "2024-04-14T00:00:00")!
        let expectedCreditor = "Mama"
        let expectedInitialAmount = liabilityToUpdate.initialAmount
        let expectedRepaidAmount: Decimal = 300.0
        let expectedLiabilityPool = DataFactory.createLiabilityPool(named: "Some other pool", liabilities: [], in: testingCoreDataStack.context)
        
        sut.liabilityGrantDate = expectedDate
        sut.liabilityCreditor = expectedCreditor
        sut.liabilityRepaidAmount = expectedRepaidAmount
        sut.liabilityPool = expectedLiabilityPool
        try sut.saveLiability()
        
        let liabilities = testingLiabilityRepository.getLiabilities()
        XCTAssertTrue(liabilities.count == 1)
        let liability = try XCTUnwrap(liabilities.first)
        
        let actualName = liability.name
        let actualDate = liability.grantDate
        let actualCreditor = liability.creditor
        let actualInitialAmount = liability.initialAmount
        let actualRepaidAmount = liability.repaidAmount.decimalValue
        let actualLiabilityPool = liability.pool
        
        XCTAssertEqual(expectedName, actualName)
        XCTAssertEqual(expectedDate, actualDate)
        XCTAssertEqual(expectedCreditor, actualCreditor)
        XCTAssertEqual(expectedInitialAmount, actualInitialAmount)
        XCTAssertEqual(expectedRepaidAmount, actualRepaidAmount)
        XCTAssertEqual(expectedLiabilityPool, actualLiabilityPool)
    }
    
    /// update a Liability with an empty name and check whether the correct error is thrown
    func test_updateLiability_2() throws {
        let liabilityToUpdate = testDataProvider.createAndPersistTestObjects_updateLiability_1(context: testingCoreDataStack.context)
  
        let sut = LiabilityFormViewModel(liability: liabilityToUpdate, repository: testingLiabilityRepository, dismissSheet: {})
        
        sut.liabilityName = ""
        XCTAssertThrowsError(try sut.saveLiability()) { error in
            XCTAssertEqual(error as? LiabilityValidationError, LiabilityValidationError.emptyName)
        }
    }
    
    /// update a Liability with an creditor and check whether the correct error is thrown
    func test_updateLiability_3() throws {
        let liabilityToUpdate = testDataProvider.createAndPersistTestObjects_updateLiability_1(context: testingCoreDataStack.context)
  
        let sut = LiabilityFormViewModel(liability: liabilityToUpdate, repository: testingLiabilityRepository, dismissSheet: {})
        
        sut.liabilityCreditor = ""
        XCTAssertThrowsError(try sut.saveLiability()) { error in
            XCTAssertEqual(error as? LiabilityValidationError, LiabilityValidationError.emptyCreditor)
        }
    }
    
    /// update a Liability with an initial amount which is not strictly positive and check whether the correct error is thrown
    func test_updateLiability_4() throws {
        let liabilityToUpdate = testDataProvider.createAndPersistTestObjects_updateLiability_1(context: testingCoreDataStack.context)
  
        let sut = LiabilityFormViewModel(liability: liabilityToUpdate, repository: testingLiabilityRepository, dismissSheet: {})
        
        sut.liabilityInitialAmount = 0.0
        sut.liabilityRepaidAmount = 0.0
        
        XCTAssertThrowsError(try sut.saveLiability()) { error in
            XCTAssertEqual(error as? LiabilityValidationError, LiabilityValidationError.initialAmountNotStrictlyPositive)
        }
    }
    
    /// update a Liability such that the repaid amount is bigger than the repaid amount and check whether the correct error is thrown
    func test_updateLiability_5() throws {
        let liabilityToUpdate = testDataProvider.createAndPersistTestObjects_updateLiability_1(context: testingCoreDataStack.context)
  
        let sut = LiabilityFormViewModel(liability: liabilityToUpdate, repository: testingLiabilityRepository, dismissSheet: {})
        
        sut.liabilityInitialAmount = 5.0
        sut.liabilityRepaidAmount = 10.0
        
        XCTAssertThrowsError(try sut.saveLiability()) { error in
            XCTAssertEqual(error as? LiabilityValidationError, LiabilityValidationError.repaidSurpassesInitialAmount)
        }
    }
    
    /// update a Liability such that no liabilityPool is selected and check whether the correct error is thrown
    func test_updateLiability_6() throws {
        let liabilityToUpdate = testDataProvider.createAndPersistTestObjects_updateLiability_1(context: testingCoreDataStack.context)
  
        let sut = LiabilityFormViewModel(liability: liabilityToUpdate, repository: testingLiabilityRepository, dismissSheet: {})
        
        sut.liabilityPool = nil
        
        XCTAssertThrowsError(try sut.saveLiability()) { error in
            XCTAssertEqual(error as? LiabilityValidationError, LiabilityValidationError.noLiabilityPoolSelected)
        }
    }
    
    
    
    /// delete one liability and test viewModel interface providing data to view as well as persisted data
    func test_deleteLiability_1() throws {
        let (liabilityToDelete, expectedLiabilities) = testDataProvider.createAndPersistTestObjects_deleteLiabilities_1(using: testingCoreDataStack.context)
        
        let sut = LiabilityFormViewModel(repository: testingLiabilityRepository, dismissSheet: {})
        sut.liability = liabilityToDelete
        sut.deleteLiability()
        
        let actualLiabilities = testingLiabilityRepository.getLiabilities()
        XCTAssertTrue(expectedLiabilities ≡ actualLiabilities)
    }
}
