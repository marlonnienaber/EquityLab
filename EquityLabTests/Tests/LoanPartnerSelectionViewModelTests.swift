import XCTest
@testable import EquityLab

final class LoanPartnerSelectionViewModelTests: XCTestCase {
    private var testingCoreDataStack: TestingCoreDataStack!
    private var testingLoanPartnerRepository: LoanPartnerRepository!
    private let testDataProvider = LoanPartnerSelectionViewModelTestDataProvider()
    
    override func setUpWithError() throws {
        testingCoreDataStack = TestingCoreDataStack()
        testingLoanPartnerRepository = LoanPartnerRepository(context: testingCoreDataStack.context)
    }
    
    /// create a LoanPartner
    func test_createLoanPartner() throws {
        let sut = LoanPartnerSelectionViewModel(loanPartnerRepository: testingLoanPartnerRepository, selectedLoanPartner: nil, onDismiss: {_ in})
        
        let expectedName = "Marlon"
        
        sut.newLoanPartnerName = expectedName
        try sut.createLoanPartner()
        
        let loanPartners = testingLoanPartnerRepository.getLoanPartners()
        XCTAssertTrue(loanPartners.count == 1)
        
        let loanParnter = try XCTUnwrap(loanPartners.first)
        let actualName = loanParnter.name
        XCTAssertEqual(expectedName, actualName)
    }
    
    /// create a LoanPartner with empty name and check whether the correct error is thrown
    func test_createLoanPartnerEmptyName() throws {
        let sut = LoanPartnerSelectionViewModel(loanPartnerRepository: testingLoanPartnerRepository, selectedLoanPartner: nil, onDismiss: {_ in})
        
        sut.newLoanPartnerName = ""
        XCTAssertThrowsError(try sut.createLoanPartner()) { error in
            XCTAssertEqual(error as? LoanPartnerValidationError, LoanPartnerValidationError.emptyName)
        }
    }
    
    /// create a LoanPartner with a name of an already existing other LoanPartner and check whether the correct error is thrown
    func test_createLoanPartnerOccupiedName() throws {
        let occupiedName = testDataProvider.createAndPersistTestObjects_createLoanPartnerOccupiedName(context: testingCoreDataStack.context)
        let sut = LoanPartnerSelectionViewModel(loanPartnerRepository: testingLoanPartnerRepository, selectedLoanPartner: nil, onDismiss: {_ in})
        
        sut.newLoanPartnerName = occupiedName
        XCTAssertThrowsError(try sut.createLoanPartner()) { error in
            XCTAssertEqual(error as? LoanPartnerValidationError, LoanPartnerValidationError.loanPartnerWithSameNameAlreadyExists)
        }
    }
}

