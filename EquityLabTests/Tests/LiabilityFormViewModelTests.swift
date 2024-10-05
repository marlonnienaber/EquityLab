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
    
    func test_createLiability_1() throws {
        let liabilityPool = testDataProvider.createAndPersistTestObjects_createLiability_1(context: testingCoreDataStack.context)
        
        let sut = LiabilityFormViewModel(pool: liabilityPool, repository: testingLiabilityRepository, dismissSheet: {})
        
        let expectedName = "Auto"
        let expectedDate = DateParser.shared.date(from: "2024-04-15T00:00:00")!
        let expectedCreditor = "Papa"
        let expectedInitialAmount = 1000.0
        let expectedRepaidAmount = 200.0
        
        sut.liabilityName = expectedName
        sut.liabilityGrantDate = expectedDate
        sut.liabilityCreditor = expectedCreditor
        sut.liabilityInitialAmount = expectedInitialAmount
        sut.liabilityRepaidAmount = expectedRepaidAmount
        sut.createLiability()
        
        let liabilities = testingLiabilityRepository.fetchLiabilities()
        XCTAssertTrue(liabilities.count == 1)
        let liability = try XCTUnwrap(liabilities.first)
        
        let actualName = liability.name
        let actualDate = liability.grantDate
        let actualCreditor = liability.creditor
        let actualInitialAmount = liability.initialAmount
        let actualRepaidAmount = liability.repaidAmount
        
        XCTAssertEqual(expectedName, actualName)
        XCTAssertEqual(expectedDate, actualDate)
        XCTAssertEqual(expectedCreditor, actualCreditor)
        XCTAssertEqual(expectedInitialAmount, actualInitialAmount)
        XCTAssertEqual(expectedRepaidAmount, actualRepaidAmount)
    }
    
    func test_updateLiability_1() throws {
        let liabilityToUpdate = testDataProvider.createAndPersistTestObjects_updateLiability_1(context: testingCoreDataStack.context)
  
        let sut = LiabilityFormViewModel(liability: liabilityToUpdate, repository: testingLiabilityRepository, dismissSheet: {})
        
        let expectedName = liabilityToUpdate.name
        let expectedDate = DateParser.shared.date(from: "2024-04-14T00:00:00")!
        let expectedCreditor = "Mama"
        let expectedInitialAmount = liabilityToUpdate.initialAmount
        let expectedRepaidAmount = 300.0
        
        sut.liabilityGrantDate = expectedDate
        sut.liabilityCreditor = expectedCreditor
        sut.liabilityRepaidAmount = expectedRepaidAmount
        sut.updateLiability(liability: liabilityToUpdate)
        
        let liabilities = testingLiabilityRepository.fetchLiabilities()
        XCTAssertTrue(liabilities.count == 1)
        let liability = try XCTUnwrap(liabilities.first)
        
        let actualName = liability.name
        let actualDate = liability.grantDate
        let actualCreditor = liability.creditor
        let actualInitialAmount = liability.initialAmount
        let actualRepaidAmount = liability.repaidAmount
        
        XCTAssertEqual(expectedName, actualName)
        XCTAssertEqual(expectedDate, actualDate)
        XCTAssertEqual(expectedCreditor, actualCreditor)
        XCTAssertEqual(expectedInitialAmount, actualInitialAmount)
        XCTAssertEqual(expectedRepaidAmount, actualRepaidAmount)
    }
}
