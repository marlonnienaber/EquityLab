import XCTest
@testable import EquityLab

final class LoanPartnerSelectionViewModelTests: XCTestCase {
    private var testingCoreDataStack: TestingCoreDataStack!
    private var testingLoanPartnerRepository: LoanPartnerRepository!
    private var testingAssetRepository: AssetRepository!
    private var testingLiabilityRepository: LiabilityRepository!
    private let testDataProvider = LoanPartnerSelectionViewModelTestDataProvider()
    
    override func setUpWithError() throws {
        testingCoreDataStack = TestingCoreDataStack()
        testingLoanPartnerRepository = LoanPartnerRepository(context: testingCoreDataStack.context)
        testingAssetRepository = AssetRepository(context: testingCoreDataStack.context)
        testingLiabilityRepository = LiabilityRepository(context: testingCoreDataStack.context)
    }
    
    /// create a LoanPartner
    func test_createLoanPartner() throws {
        let sut = LoanPartnerSelectionViewModel(
            loanPartnerRepository: testingLoanPartnerRepository,
            assetRepository: testingAssetRepository,
            liabilityRepository: testingLiabilityRepository,
            selectedLoanPartner: nil,
            onDismiss: {_ in}
        )
        
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
        let sut = LoanPartnerSelectionViewModel(
            loanPartnerRepository: testingLoanPartnerRepository,
            assetRepository: testingAssetRepository,
            liabilityRepository: testingLiabilityRepository,
            selectedLoanPartner: nil,
            onDismiss: {_ in}
        )
        
        sut.newLoanPartnerName = ""
        XCTAssertThrowsError(try sut.createLoanPartner()) { error in
            XCTAssertEqual(error as? LoanPartnerValidationError, LoanPartnerValidationError.emptyName)
        }
    }
    
    /// create a LoanPartner with a name of an already existing other LoanPartner and check whether the correct error is thrown
    func test_createLoanPartnerOccupiedName() throws {
        let occupiedName = testDataProvider.createAndPersistTestObjects_createLoanPartnerOccupiedName(context: testingCoreDataStack.context)
        
        let sut = LoanPartnerSelectionViewModel(
            loanPartnerRepository: testingLoanPartnerRepository,
            assetRepository: testingAssetRepository,
            liabilityRepository: testingLiabilityRepository,
            selectedLoanPartner: nil,
            onDismiss: {_ in}
        )
        
        sut.newLoanPartnerName = occupiedName
        XCTAssertThrowsError(try sut.createLoanPartner()) { error in
            XCTAssertEqual(error as? LoanPartnerValidationError, LoanPartnerValidationError.loanPartnerWithSameNameAlreadyExists)
        }
    }
    
    /// delete a LoanPartner
    func test_deleteLoanPartner() throws {
        testDataProvider.createAndPersistTestObjects_deleteLoanPartner(context: testingCoreDataStack.context)
        
        let sut = LoanPartnerSelectionViewModel(
            loanPartnerRepository: testingLoanPartnerRepository,
            assetRepository: testingAssetRepository,
            liabilityRepository: testingLiabilityRepository,
            selectedLoanPartner: nil,
            onDismiss: {_ in}
        )
        
        try sut.deleteLoanPartners(withIndices: IndexSet(integer: 0))
        
        let persistedLoanPartners = testingLoanPartnerRepository.getLoanPartners()
        XCTAssertTrue(persistedLoanPartners.isEmpty)
        
        let sutLoanPartners = sut.loanPartners
        XCTAssertTrue(sutLoanPartners.isEmpty)
    }
    
    /// batch-delete LoanPartners. The operation should have no effect since only single deletions should be supported.
    func test_batchDeleteLoanPartner() throws {
        testDataProvider.createAndPersistTestObjects_deleteLoanPartner(context: testingCoreDataStack.context)
        
        let sut = LoanPartnerSelectionViewModel(
            loanPartnerRepository: testingLoanPartnerRepository,
            assetRepository: testingAssetRepository,
            liabilityRepository: testingLiabilityRepository,
            selectedLoanPartner: nil,
            onDismiss: {_ in}
        )
        
        try sut.deleteLoanPartners(withIndices: IndexSet(0...3))
        
        let persistedLoanPartners = testingLoanPartnerRepository.getLoanPartners()
        XCTAssertTrue(persistedLoanPartners.count == 1)
        
        let sutLoanPartners = sut.loanPartners
        XCTAssertTrue(sutLoanPartners.count == 1)
    }
    
    /// delete LoanPartner which is still associated with a loan and check whether correct error is thrown
    func test_deleteUndeletableLoanPartner() throws {
        testDataProvider.createAndPersistTestObjects_deleteUndeletableLoanPartner(context: testingCoreDataStack.context)
        
        let sut = LoanPartnerSelectionViewModel(
            loanPartnerRepository: testingLoanPartnerRepository,
            assetRepository: testingAssetRepository,
            liabilityRepository: testingLiabilityRepository,
            selectedLoanPartner: nil,
            onDismiss: {_ in}
        )
        
        XCTAssertThrowsError(try sut.deleteLoanPartners(withIndices: IndexSet(integer: 0))) { error in
            XCTAssertEqual(error as? LoanPartnerValidationError, LoanPartnerValidationError.canNotBeDeleted)
        }
        
        let persistedLoanPartners = testingLoanPartnerRepository.getLoanPartners()
        XCTAssertTrue(persistedLoanPartners.count == 1)
        
        let sutLoanPartners = sut.loanPartners
        XCTAssertTrue(sutLoanPartners.count == 1)
    }
}

