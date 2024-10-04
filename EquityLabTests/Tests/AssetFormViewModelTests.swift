import XCTest
@testable import EquityLab

final class AssetFormViewModelTests: XCTestCase {
    private var testingCoreDataStack: TestingCoreDataStack!
    private var testingAssetRepository: AssetRepository!
    private let testDataProvider = AssetFormViewModelTestDataProvider()
    
    override func setUpWithError() throws {
        testingCoreDataStack = TestingCoreDataStack()
        testingAssetRepository = AssetRepository(context: testingCoreDataStack.context)
    }
    
    /// update a Receivable
    func test_saveAsset_1() throws {
        var receivable = testDataProvider.createAndPersistTestObjects_saveAsset_1(context: testingCoreDataStack.context)
        
        let sut = AssetFormViewModel(asset: receivable, repository: testingAssetRepository, dismissSheet: {})
        
        let expectedName = "Rote Sonne"
        let expectedDebtor = "Philipp"
        let expectedGrantDate = DateParser.shared.date(from: "2024-07-23T00:00:00")!
        let expectedInitialAmount = 200.0
        let expectedRepaidAmount = 40.0
        
        sut.assetName = expectedName
        sut.receivableDebtor = expectedDebtor
        sut.receivableGrantDate = expectedGrantDate
        sut.receivableInitialAmount = expectedInitialAmount
        sut.receivableRepaidAmount = expectedRepaidAmount
        sut.saveAsset()
        
        let persistedAssets = testingAssetRepository.fetchAssets()
        XCTAssertTrue(persistedAssets.count == 1)
        receivable = try XCTUnwrap(persistedAssets.first as? Receivable)
        
        let actualName = receivable.name
        let actualDebtor = receivable.debtor
        let actualGrantDate = receivable.grantDate
        let actualInitialAmount = receivable.initialAmount
        let actualRepaidAmount = receivable.repaidAmount
        
        XCTAssertEqual(expectedName, actualName)
        XCTAssertEqual(expectedDebtor, actualDebtor)
        XCTAssertEqual(expectedGrantDate, actualGrantDate)
        XCTAssertEqual(expectedInitialAmount, actualInitialAmount)
        XCTAssertEqual(expectedRepaidAmount, actualRepaidAmount)
    }
    
    /// update a Possession
    func test_saveAsset_2() throws {
        var possession = testDataProvider.createAndPersistTestObjects_saveAsset_2(context: testingCoreDataStack.context)
        
        let sut = AssetFormViewModel(asset: possession, repository: testingAssetRepository, dismissSheet: {})
        
        let expectedName = "Commerzbank Konto"
        let expectedIsVolatile = false
        
        sut.assetName = expectedName
        sut.possessionIsVolatile = expectedIsVolatile
        sut.saveAsset()
        
        let persistedAssets = testingAssetRepository.fetchAssets()
        XCTAssertTrue(persistedAssets.count == 1)
        possession = try XCTUnwrap(persistedAssets.first as? Possession)
        
        let actualName = possession.name
        let actualIsVolatile = possession.volatile
        
        XCTAssertEqual(expectedName, actualName)
        XCTAssertEqual(expectedIsVolatile, actualIsVolatile)
    }
    
    /// create a Receivable
    func test_saveAsset_3() throws {
        let assetPool = testDataProvider.createAndPersistTestObjects_multiPurpose_1(context: testingCoreDataStack.context)
        
        let sut = AssetFormViewModel(pool: assetPool, repository: testingAssetRepository, dismissSheet: {})
        
        let expectedName = "Rote Sonne"
        let expectedDebtor = "Philipp"
        let expectedGrantDate = DateParser.shared.date(from: "2024-07-23T00:00:00")!
        let expectedInitialAmount = 200.0
        let expectedRepaidAmount = 40.0
        
        sut.assetName = expectedName
        sut.receivableDebtor = expectedDebtor
        sut.receivableGrantDate = expectedGrantDate
        sut.receivableInitialAmount = expectedInitialAmount
        sut.receivableRepaidAmount = expectedRepaidAmount
        sut.selectedAssetType = .receivable
        sut.saveAsset()
        
        let persistedAssets = testingAssetRepository.fetchAssets()
        XCTAssertTrue(persistedAssets.count == 1)
        let receivable = try XCTUnwrap(persistedAssets.first as? Receivable)
        
        let actualName = receivable.name
        let actualDebtor = receivable.debtor
        let actualGrantDate = receivable.grantDate
        let actualInitialAmount = receivable.initialAmount
        let actualRepaidAmount = receivable.repaidAmount
        
        XCTAssertEqual(expectedName, actualName)
        XCTAssertEqual(expectedDebtor, actualDebtor)
        XCTAssertEqual(expectedGrantDate, actualGrantDate)
        XCTAssertEqual(expectedInitialAmount, actualInitialAmount)
        XCTAssertEqual(expectedRepaidAmount, actualRepaidAmount)
    }
    
    /// create a Possession
    func test_saveAsset_4() throws {
        let assetPool = testDataProvider.createAndPersistTestObjects_multiPurpose_1(context: testingCoreDataStack.context)
        
        let sut = AssetFormViewModel(pool: assetPool, repository: testingAssetRepository, dismissSheet: {})
        
        let expectedName = "Commerzbank Konto"
        let expectedIsVolatile = false
        
        sut.assetName = expectedName
        sut.possessionIsVolatile = expectedIsVolatile
        sut.selectedAssetType = .possession
        sut.saveAsset()
        
        let persistedAssets = testingAssetRepository.fetchAssets()
        XCTAssertTrue(persistedAssets.count == 1)
        let possession = try XCTUnwrap(persistedAssets.first as? Possession)
        
        let actualName = possession.name
        let actualIsVolatile = possession.volatile
        
        XCTAssertEqual(expectedName, actualName)
        XCTAssertEqual(expectedIsVolatile, actualIsVolatile)
    }
    
    /// create 2 Receivables of the same name. Only the first one should be persisted
    func test_saveAsset_5() throws {
        let assetPool = testDataProvider.createAndPersistTestObjects_multiPurpose_1(context: testingCoreDataStack.context)
        
        let sut = AssetFormViewModel(pool: assetPool, repository: testingAssetRepository, dismissSheet: {})
        
        let firstExpectedName = "Rote Sonne"
        let firstExpectedDebtor = "Philipp"
        let firstExpectedGrantDate = DateParser.shared.date(from: "2024-07-23T00:00:00")!
        let firstExpectedInitialAmount = 200.0
        let firstExpectedRepaidAmount = 40.0
        
        sut.assetName = firstExpectedName
        sut.receivableDebtor = firstExpectedDebtor
        sut.receivableGrantDate = firstExpectedGrantDate
        sut.receivableInitialAmount = firstExpectedInitialAmount
        sut.receivableRepaidAmount = firstExpectedRepaidAmount
        sut.selectedAssetType = .receivable
        sut.saveAsset()
        
        let secondExpectedName = "Rote Sonne"
        let secondExpectedDebtor = "Lenni"
        let secondExpectedGrantDate = DateParser.shared.date(from: "2024-07-22T00:00:00")!
        let secondExpectedInitialAmount = 100.0
        let secondExpectedRepaidAmount = 20.0
        
        sut.assetName = secondExpectedName
        sut.receivableDebtor = secondExpectedDebtor
        sut.receivableGrantDate = secondExpectedGrantDate
        sut.receivableInitialAmount = secondExpectedInitialAmount
        sut.receivableRepaidAmount = secondExpectedRepaidAmount
        sut.selectedAssetType = .receivable
        sut.saveAsset()
        
        let persistedAssets = testingAssetRepository.fetchAssets()
        XCTAssertTrue(persistedAssets.count == 1)
        let receivable = try XCTUnwrap(persistedAssets.first as? Receivable)
        
        let actualName = receivable.name
        let actualDebtor = receivable.debtor
        let actualGrantDate = receivable.grantDate
        let actualInitialAmount = receivable.initialAmount
        let actualRepaidAmount = receivable.repaidAmount
        
        XCTAssertEqual(firstExpectedName, actualName)
        XCTAssertEqual(firstExpectedDebtor, actualDebtor)
        XCTAssertEqual(firstExpectedGrantDate, actualGrantDate)
        XCTAssertEqual(firstExpectedInitialAmount, actualInitialAmount)
        XCTAssertEqual(firstExpectedRepaidAmount, actualRepaidAmount)
    }
    
    /// create 2 Possessions of the same name. Only the first one should be persisted
    func test_saveAsset_6() throws {
        let assetPool = testDataProvider.createAndPersistTestObjects_multiPurpose_1(context: testingCoreDataStack.context)
        
        let sut = AssetFormViewModel(pool: assetPool, repository: testingAssetRepository, dismissSheet: {})
        
        let firstExpectedName = "Commerzbank Konto"
        let firstExpectedIsVolatile = false
        
        sut.assetName = firstExpectedName
        sut.possessionIsVolatile = firstExpectedIsVolatile
        sut.selectedAssetType = .possession
        sut.saveAsset()
        
        let secondExpectedName = "Commerzbank Konto"
        let secondExpectedIsVolatile = true
        
        sut.assetName = secondExpectedName
        sut.possessionIsVolatile = secondExpectedIsVolatile
        sut.selectedAssetType = .possession
        sut.saveAsset()
        
        let persistedAssets = testingAssetRepository.fetchAssets()
        XCTAssertTrue(persistedAssets.count == 1)
        let possession = try XCTUnwrap(persistedAssets.first as? Possession)
        
        let actualName = possession.name
        let actualIsVolatile = possession.volatile
        
        XCTAssertEqual(firstExpectedName, actualName)
        XCTAssertEqual(firstExpectedIsVolatile, actualIsVolatile)
    }
    
    /// create 1 Receivables and then 1 Possession of the same name. Only the first one created should be persisted
    func test_saveAsset_7() throws {
        let assetPool = testDataProvider.createAndPersistTestObjects_multiPurpose_1(context: testingCoreDataStack.context)
        
        let sut = AssetFormViewModel(pool: assetPool, repository: testingAssetRepository, dismissSheet: {})
        
        let firstExpectedName = "Rote Sonne"
        let firstExpectedDebtor = "Philipp"
        let firstExpectedGrantDate = DateParser.shared.date(from: "2024-07-23T00:00:00")!
        let firstExpectedInitialAmount = 200.0
        let firstExpectedRepaidAmount = 40.0
        
        sut.assetName = firstExpectedName
        sut.receivableDebtor = firstExpectedDebtor
        sut.receivableGrantDate = firstExpectedGrantDate
        sut.receivableInitialAmount = firstExpectedInitialAmount
        sut.receivableRepaidAmount = firstExpectedRepaidAmount
        sut.selectedAssetType = .receivable
        sut.saveAsset()
        
        let secondExpectedName = "Rote Sonne"
        let secondExpectedIsVolatile = true
        
        sut.assetName = secondExpectedName
        sut.possessionIsVolatile = secondExpectedIsVolatile
        sut.selectedAssetType = .possession
        sut.saveAsset()
        
        let persistedAssets = testingAssetRepository.fetchAssets()
        XCTAssertTrue(persistedAssets.count == 1)
        let receivable = try XCTUnwrap(persistedAssets.first as? Receivable)
        
        let actualName = receivable.name
        let actualDebtor = receivable.debtor
        let actualGrantDate = receivable.grantDate
        let actualInitialAmount = receivable.initialAmount
        let actualRepaidAmount = receivable.repaidAmount
        
        XCTAssertEqual(firstExpectedName, actualName)
        XCTAssertEqual(firstExpectedDebtor, actualDebtor)
        XCTAssertEqual(firstExpectedGrantDate, actualGrantDate)
        XCTAssertEqual(firstExpectedInitialAmount, actualInitialAmount)
        XCTAssertEqual(firstExpectedRepaidAmount, actualRepaidAmount)
    }
    
    /// create 1 Possession and then 1 Receivable of the same name. Only the first one created should be persisted
    func test_saveAsset_8() throws {
        let assetPool = testDataProvider.createAndPersistTestObjects_multiPurpose_1(context: testingCoreDataStack.context)
        
        let sut = AssetFormViewModel(pool: assetPool, repository: testingAssetRepository, dismissSheet: {})
        
        let firstExpectedName = "Commerzbank Konto"
        let firstExpectedIsVolatile = false
        
        sut.assetName = firstExpectedName
        sut.possessionIsVolatile = firstExpectedIsVolatile
        sut.selectedAssetType = .possession
        sut.saveAsset()
        
        let secondExpectedName = "Commerzbank Konto"
        let secondExpectedDebtor = "Lenni"
        let secondExpectedGrantDate = DateParser.shared.date(from: "2024-07-22T00:00:00")!
        let secondExpectedInitialAmount = 100.0
        let secondExpectedRepaidAmount = 20.0
        
        sut.assetName = secondExpectedName
        sut.receivableDebtor = secondExpectedDebtor
        sut.receivableGrantDate = secondExpectedGrantDate
        sut.receivableInitialAmount = secondExpectedInitialAmount
        sut.receivableRepaidAmount = secondExpectedRepaidAmount
        sut.selectedAssetType = .receivable
        sut.saveAsset()
        
        let persistedAssets = testingAssetRepository.fetchAssets()
        XCTAssertTrue(persistedAssets.count == 1)
        let possession = try XCTUnwrap(persistedAssets.first as? Possession)
        
        let actualName = possession.name
        let actualIsVolatile = possession.volatile
        
        XCTAssertEqual(firstExpectedName, actualName)
        XCTAssertEqual(firstExpectedIsVolatile, actualIsVolatile)
    }

}
