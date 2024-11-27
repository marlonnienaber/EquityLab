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
        let actualRemainingReceivables = testingAssetRepository.receivables
        XCTAssertTrue(expectedRemainingReceivables ≡ actualRemainingReceivables)
    }
    
    /// first index
    func test_deleteReceivablesWithIndices_2() throws {
        let (indexSet, expectedRemainingReceivables) = testDataProvider.createAndPersistTestObjects_deleteReceivablesWithIndices_2(using: testingCoreDataStack.context)
        let sut = LoanManagementViewModel(assetRepository: testingAssetRepository, liabilityRepository: testingLiabilityRepository)
        sut.deleteReceivables(for: indexSet)
        let actualRemainingReceivables = testingAssetRepository.receivables
        XCTAssertTrue(expectedRemainingReceivables ≡ actualRemainingReceivables)
    }
    
    /// last index
    func test_deleteReceivablesWithIndices_3() throws {
        let (indexSet, expectedRemainingReceivables) = testDataProvider.createAndPersistTestObjects_deleteReceivablesWithIndices_3(using: testingCoreDataStack.context)
        let sut = LoanManagementViewModel(assetRepository: testingAssetRepository, liabilityRepository: testingLiabilityRepository)
        sut.deleteReceivables(for: indexSet)
        let actualRemainingReceivables = testingAssetRepository.receivables
        XCTAssertTrue(expectedRemainingReceivables ≡ actualRemainingReceivables)
    }
    
    /// some middle index
    func test_deleteReceivablesWithIndices_4() throws {
        let (indexSet, expectedRemainingReceivables) = testDataProvider.createAndPersistTestObjects_deleteReceivablesWithIndices_4(using: testingCoreDataStack.context)
        let sut = LoanManagementViewModel(assetRepository: testingAssetRepository, liabilityRepository: testingLiabilityRepository)
        sut.deleteReceivables(for: indexSet)
        let actualRemainingReceivables = testingAssetRepository.receivables
        XCTAssertTrue(expectedRemainingReceivables ≡ actualRemainingReceivables)
    }
    
    /// multiple indices
    func test_deleteReceivablesWithIndices_5() throws {
        let (indexSet, expectedRemainingReceivables) = testDataProvider.createAndPersistTestObjects_deleteReceivablesWithIndices_5(using: testingCoreDataStack.context)
        let sut = LoanManagementViewModel(assetRepository: testingAssetRepository, liabilityRepository: testingLiabilityRepository)
        sut.deleteReceivables(for: indexSet)
        let actualRemainingReceivables = testingAssetRepository.receivables
        XCTAssertTrue(expectedRemainingReceivables ≡ actualRemainingReceivables)
    }
    
    /// all indices
    func test_deleteReceivablesWithIndices_6() throws {
        let (indexSet, expectedRemainingReceivables) = testDataProvider.createAndPersistTestObjects_deleteReceivablesWithIndices_6(using: testingCoreDataStack.context)
        let sut = LoanManagementViewModel(assetRepository: testingAssetRepository, liabilityRepository: testingLiabilityRepository)
        sut.deleteReceivables(for: indexSet)
        let actualRemainingReceivables = testingAssetRepository.receivables
        XCTAssertTrue(expectedRemainingReceivables ≡ actualRemainingReceivables)
    }
    
    
    
    /// no indices
    func test_deleteLiabilitiesWithIndices_1() throws {
        let sut = LoanManagementViewModel(assetRepository: testingAssetRepository, liabilityRepository: testingLiabilityRepository)
        let (indexSet, expectedRemainingLiabilities) = testDataProvider.createAndPersistTestObjects_deleteLiabilitiesWithIndices_1(using: testingCoreDataStack.context)
        sut.deleteLiabilities(for: indexSet)
        let actualRemainingLiabilities = testingLiabilityRepository.liabilities
        XCTAssertTrue(expectedRemainingLiabilities ≡ actualRemainingLiabilities)
    }
    
    /// first index
    func test_deleteLiabilitiesWithIndices_2() throws {
        let (indexSet, expectedRemainingLiabilities) = testDataProvider.createAndPersistTestObjects_deleteLiabilitiesWithIndices_2(using: testingCoreDataStack.context)
        let sut = LoanManagementViewModel(assetRepository: testingAssetRepository, liabilityRepository: testingLiabilityRepository)
        sut.deleteLiabilities(for: indexSet)
        let actualRemainingLiabilities = testingLiabilityRepository.liabilities
        XCTAssertTrue(expectedRemainingLiabilities ≡ actualRemainingLiabilities)
    }
    
    /// last index
    func test_deleteLiabilitiesWithIndices_3() throws {
        let (indexSet, expectedRemainingLiabilities) = testDataProvider.createAndPersistTestObjects_deleteLiabilitiesWithIndices_3(using: testingCoreDataStack.context)
        let sut = LoanManagementViewModel(assetRepository: testingAssetRepository, liabilityRepository: testingLiabilityRepository)
        sut.deleteLiabilities(for: indexSet)
        let actualRemainingLiabilities = testingLiabilityRepository.liabilities
        XCTAssertTrue(expectedRemainingLiabilities ≡ actualRemainingLiabilities)
    }
    
    /// some middle index
    func test_deleteLiabilitiesWithIndices_4() throws {
        let (indexSet, expectedRemainingLiabilities) = testDataProvider.createAndPersistTestObjects_deleteLiabilitiesWithIndices_4(using: testingCoreDataStack.context)
        let sut = LoanManagementViewModel(assetRepository: testingAssetRepository, liabilityRepository: testingLiabilityRepository)
        sut.deleteLiabilities(for: indexSet)
        let actualRemainingLiabilities = testingLiabilityRepository.liabilities
        XCTAssertTrue(expectedRemainingLiabilities ≡ actualRemainingLiabilities)
    }
    
    /// multiple indices
    func test_deleteLiabilitiesWithIndices_5() throws {
        let (indexSet, expectedRemainingLiabilities) = testDataProvider.createAndPersistTestObjects_deleteLiabilitiesWithIndices_5(using: testingCoreDataStack.context)
        let sut = LoanManagementViewModel(assetRepository: testingAssetRepository, liabilityRepository: testingLiabilityRepository)
        sut.deleteLiabilities(for: indexSet)
        let actualRemainingLiabilities = testingLiabilityRepository.liabilities
        XCTAssertTrue(expectedRemainingLiabilities ≡ actualRemainingLiabilities)
    }
    
    /// all indices
    func test_deleteLiabilitiesWithIndices_6() throws {
        let (indexSet, expectedRemainingLiabilities) = testDataProvider.createAndPersistTestObjects_deleteLiabilitiesWithIndices_6(using: testingCoreDataStack.context)
        let sut = LoanManagementViewModel(assetRepository: testingAssetRepository, liabilityRepository: testingLiabilityRepository)
        sut.deleteLiabilities(for: indexSet)
        let actualRemainingLiabilities = testingLiabilityRepository.liabilities
        XCTAssertTrue(expectedRemainingLiabilities ≡ actualRemainingLiabilities)
    }
}
