import XCTest
@testable import EquityLab

final class LoanManagementViewModelTests: XCTestCase {
    private var testingCoreDataStack: TestingCoreDataStack!
    private var testingAssetRepository: AssetRepository!
    private var testingLiabilityRepository: LiabilityRepository!
    private let testDataProvider = LoanManagementViewModelTestDataProvider()
    
    override func setUpWithError() throws {
        testingCoreDataStack = TestingCoreDataStack()
        testingAssetRepository = AssetRepository(context: testingCoreDataStack.context)
        testingLiabilityRepository = LiabilityRepository(context: testingCoreDataStack.context)
    }
    
    
    
    /// no indices
    func test_deleteReceivablesWithIndices_1() throws {
        let sut = LoanManagementViewModel(assetRepository: testingAssetRepository, liabilityRepository: testingLiabilityRepository)
        let (indexSet, expectedRemainingReceivables) = testDataProvider.createAndPersistTestObjects_deleteReceivablesWithIndices_1(using: testingCoreDataStack.context)
        sut.deleteReceivables(for: indexSet)
        let actualRemainingReceivables = testingAssetRepository.getReceivables()
        XCTAssertTrue(expectedRemainingReceivables ≡ actualRemainingReceivables)
    }
    
    /// first index
    func test_deleteReceivablesWithIndices_2() throws {
        let (indexSet, expectedRemainingReceivables) = testDataProvider.createAndPersistTestObjects_deleteReceivablesWithIndices_2(using: testingCoreDataStack.context)
        let sut = LoanManagementViewModel(assetRepository: testingAssetRepository, liabilityRepository: testingLiabilityRepository)
        sut.deleteReceivables(for: indexSet)
        let actualRemainingReceivables = testingAssetRepository.getReceivables()
        XCTAssertTrue(expectedRemainingReceivables ≡ actualRemainingReceivables)
    }
    
    /// last index
    func test_deleteReceivablesWithIndices_3() throws {
        let (indexSet, expectedRemainingReceivables) = testDataProvider.createAndPersistTestObjects_deleteReceivablesWithIndices_3(using: testingCoreDataStack.context)
        let sut = LoanManagementViewModel(assetRepository: testingAssetRepository, liabilityRepository: testingLiabilityRepository)
        sut.deleteReceivables(for: indexSet)
        let actualRemainingReceivables = testingAssetRepository.getReceivables()
        XCTAssertTrue(expectedRemainingReceivables ≡ actualRemainingReceivables)
    }
    
    /// some middle index
    func test_deleteReceivablesWithIndices_4() throws {
        let (indexSet, expectedRemainingReceivables) = testDataProvider.createAndPersistTestObjects_deleteReceivablesWithIndices_4(using: testingCoreDataStack.context)
        let sut = LoanManagementViewModel(assetRepository: testingAssetRepository, liabilityRepository: testingLiabilityRepository)
        sut.deleteReceivables(for: indexSet)
        let actualRemainingReceivables = testingAssetRepository.getReceivables()
        XCTAssertTrue(expectedRemainingReceivables ≡ actualRemainingReceivables)
    }
    
    /// multiple indices
    func test_deleteReceivablesWithIndices_5() throws {
        let (indexSet, expectedRemainingReceivables) = testDataProvider.createAndPersistTestObjects_deleteReceivablesWithIndices_5(using: testingCoreDataStack.context)
        let sut = LoanManagementViewModel(assetRepository: testingAssetRepository, liabilityRepository: testingLiabilityRepository)
        sut.deleteReceivables(for: indexSet)
        let actualRemainingReceivables = testingAssetRepository.getReceivables()
        XCTAssertTrue(expectedRemainingReceivables ≡ actualRemainingReceivables)
    }
    
    /// all indices
    func test_deleteReceivablesWithIndices_6() throws {
        let (indexSet, expectedRemainingReceivables) = testDataProvider.createAndPersistTestObjects_deleteReceivablesWithIndices_6(using: testingCoreDataStack.context)
        let sut = LoanManagementViewModel(assetRepository: testingAssetRepository, liabilityRepository: testingLiabilityRepository)
        sut.deleteReceivables(for: indexSet)
        let actualRemainingReceivables = testingAssetRepository.getReceivables()
        XCTAssertTrue(expectedRemainingReceivables ≡ actualRemainingReceivables)
    }
    
    
    
    /// no indices
    func test_deleteLiabilitiesWithIndices_1() throws {
        let sut = LoanManagementViewModel(assetRepository: testingAssetRepository, liabilityRepository: testingLiabilityRepository)
        let (indexSet, expectedRemainingLiabilities) = testDataProvider.createAndPersistTestObjects_deleteLiabilitiesWithIndices_1(using: testingCoreDataStack.context)
        sut.deleteLiabilities(for: indexSet)
        let actualRemainingLiabilities = testingLiabilityRepository.getLiabilities()
        XCTAssertTrue(expectedRemainingLiabilities ≡ actualRemainingLiabilities)
    }
    
    /// first index
    func test_deleteLiabilitiesWithIndices_2() throws {
        let (indexSet, expectedRemainingLiabilities) = testDataProvider.createAndPersistTestObjects_deleteLiabilitiesWithIndices_2(using: testingCoreDataStack.context)
        let sut = LoanManagementViewModel(assetRepository: testingAssetRepository, liabilityRepository: testingLiabilityRepository)
        sut.deleteLiabilities(for: indexSet)
        let actualRemainingLiabilities = testingLiabilityRepository.getLiabilities()
        print("expectedRemainingLiabilities")
        expectedRemainingLiabilities.forEach{ print($0.name) }
        print("actualRemainingLiabilities")
        actualRemainingLiabilities.forEach{ print($0.name) }
        XCTAssertTrue(expectedRemainingLiabilities ≡ actualRemainingLiabilities)
    }
    
    /// last index
    func test_deleteLiabilitiesWithIndices_3() throws {
        let (indexSet, expectedRemainingLiabilities) = testDataProvider.createAndPersistTestObjects_deleteLiabilitiesWithIndices_3(using: testingCoreDataStack.context)
        let sut = LoanManagementViewModel(assetRepository: testingAssetRepository, liabilityRepository: testingLiabilityRepository)
        sut.deleteLiabilities(for: indexSet)
        let actualRemainingLiabilities = testingLiabilityRepository.getLiabilities()
        XCTAssertTrue(expectedRemainingLiabilities ≡ actualRemainingLiabilities)
    }
    
    /// some middle index
    func test_deleteLiabilitiesWithIndices_4() throws {
        let (indexSet, expectedRemainingLiabilities) = testDataProvider.createAndPersistTestObjects_deleteLiabilitiesWithIndices_4(using: testingCoreDataStack.context)
        let sut = LoanManagementViewModel(assetRepository: testingAssetRepository, liabilityRepository: testingLiabilityRepository)
        sut.deleteLiabilities(for: indexSet)
        let actualRemainingLiabilities = testingLiabilityRepository.getLiabilities()
        XCTAssertTrue(expectedRemainingLiabilities ≡ actualRemainingLiabilities)
    }
    
    /// multiple indices
    func test_deleteLiabilitiesWithIndices_5() throws {
        let (indexSet, expectedRemainingLiabilities) = testDataProvider.createAndPersistTestObjects_deleteLiabilitiesWithIndices_5(using: testingCoreDataStack.context)
        let sut = LoanManagementViewModel(assetRepository: testingAssetRepository, liabilityRepository: testingLiabilityRepository)
        sut.deleteLiabilities(for: indexSet)
        let actualRemainingLiabilities = testingLiabilityRepository.getLiabilities()
        XCTAssertTrue(expectedRemainingLiabilities ≡ actualRemainingLiabilities)
    }
    
    /// all indices
    func test_deleteLiabilitiesWithIndices_6() throws {
        let (indexSet, expectedRemainingLiabilities) = testDataProvider.createAndPersistTestObjects_deleteLiabilitiesWithIndices_6(using: testingCoreDataStack.context)
        let sut = LoanManagementViewModel(assetRepository: testingAssetRepository, liabilityRepository: testingLiabilityRepository)
        sut.deleteLiabilities(for: indexSet)
        let actualRemainingLiabilities = testingLiabilityRepository.getLiabilities()
        XCTAssertTrue(expectedRemainingLiabilities ≡ actualRemainingLiabilities)
    }
    
    
    
    /// test disbursed amount string for receivable
    func test_getDisbursedAmountString_receivable() throws {
        let (receivable, expectedAmountString) = testDataProvider.createAndPersistTestObjects_getDisbursedAmountString_1(context: testingCoreDataStack.context)
        let sut = LoanManagementViewModel(assetRepository: testingAssetRepository, liabilityRepository: testingLiabilityRepository)
        let actualLocalizedCurrencyFormattedString = sut.getDisbursedAmountString(for: receivable)
        let actualAmountString = actualLocalizedCurrencyFormattedString!.dropLast(2).string
        XCTAssertEqual(expectedAmountString, actualAmountString)
    }
    
    /// test repayment percentage for receivable
    func test_getRepaymentPercentage_receivable() throws {
        let (receivable, expectedPercentage) = testDataProvider.createAndPersistTestObjects_getRepaymentPercentage_1(context: testingCoreDataStack.context)
        let sut = LoanManagementViewModel(assetRepository: testingAssetRepository, liabilityRepository: testingLiabilityRepository)
        let actualPercentage = sut.getRepaymentPercentage(for: receivable)
        XCTAssertEqual(expectedPercentage, actualPercentage)
    }
    
    /// test disbursed amount string for liability
    func test_getDisbursedAmountString_liability() throws {
        let (liability, expectedAmountString) = testDataProvider.createAndPersistTestObjects_getDisbursedAmountString_2(context: testingCoreDataStack.context)
        let sut = LoanManagementViewModel(assetRepository: testingAssetRepository, liabilityRepository: testingLiabilityRepository)
        let actualLocalizedCurrencyFormattedString = sut.getDisbursedAmountString(for: liability)
        let actualAmountString = actualLocalizedCurrencyFormattedString!.dropLast(2).string
        XCTAssertEqual(expectedAmountString, actualAmountString)
    }
    
    /// test repayment percentage for liability
    func test_getRepaymentPercentage_liability() throws {
        let (liability, expectedPercentage) = testDataProvider.createAndPersistTestObjects_getRepaymentPercentage_2(context: testingCoreDataStack.context)
        let sut = LoanManagementViewModel(assetRepository: testingAssetRepository, liabilityRepository: testingLiabilityRepository)
        let actualPercentage = sut.getRepaymentPercentage(for: liability)
        XCTAssertEqual(expectedPercentage, actualPercentage)
    }
}
