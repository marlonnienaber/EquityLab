import XCTest
@testable import EquityLab

final class LiabilityDetailViewModelTests: XCTestCase {
    private var testingCoreDataStack: TestingCoreDataStack!
    private var testingLiabilityRepository: LiabilityRepository!
    private let testDataProvider = LiabilityDetailViewModelTestDataProvider()
    
    override func setUpWithError() throws {
        testingCoreDataStack = TestingCoreDataStack()
        testingLiabilityRepository = LiabilityRepository(context: testingCoreDataStack.context)
    }
    
    
    
    /// test monthYears
    func test_monthYears() throws {
        let (creditor,liability,expectedMonthYears) = testDataProvider.createAndPersistTestObjects_monthYears(context: testingCoreDataStack.context)
        let sut = LiabilityDetailViewModel(liabilityRepository: testingLiabilityRepository, liability: liability, creditor: creditor)
        let actualMonthYears = sut.monthYears
        XCTAssertEqual(expectedMonthYears, actualMonthYears)
    }
    
    /// test getTransactionFalling(intoInto: )
    func test_getTransactionFallingIntoMonthYear() throws {
        let (creditor,liability,monthYearsToTransactionsDictionary) = testDataProvider.createAndPersistTestObjects_getTransactionFallingIntoMonthYear(context: testingCoreDataStack.context)
        let sut = LiabilityDetailViewModel(liabilityRepository: testingLiabilityRepository, liability: liability, creditor: creditor)
        for monthYear in monthYearsToTransactionsDictionary.keys {
            let expectedTransactions = monthYearsToTransactionsDictionary[monthYear]!
            let actualTransactions = sut.getTransactions(fallingInto: monthYear)
            XCTAssertEqual(expectedTransactions, actualTransactions)
        }
    }
    
    
    
    /// delete all transactions from within a MonthYear and check whether the correct transactions are persisted and whether the interface of the sut has updates accordingly
    func test_deleteTransactions_1() throws {
        let (creditor,liability,expectedTransactions) = testDataProvider.createAndPersistTestObjects_deleteTransactions_1(context: testingCoreDataStack.context)
        let sut = LiabilityDetailViewModel(liabilityRepository: testingLiabilityRepository, liability: liability, creditor: creditor)
        sut.deleteTransactions(at: IndexSet(0...1), for: MonthYear(month: .april, year: 2024))
        let actualPersitedTransactions = testingLiabilityRepository.getTransactions()
        XCTAssertTrue(expectedTransactions ≡ actualPersitedTransactions)
        let actualSutTransactions = sut.monthYears.map{ sut.getTransactions(fallingInto: $0) }.reduce([], +)
        XCTAssertTrue(expectedTransactions ≡ actualSutTransactions)
    }
    
    /// delete one transaction within a MonthYear and check whether the correct transactions are persisted and whether the interface of the sut has updates accordingly
    func test_deleteTransactions_2() throws {
        let (creditor,liability,expectedTransactions) = testDataProvider.createAndPersistTestObjects_deleteTransactions_2(context: testingCoreDataStack.context)
        let sut = LiabilityDetailViewModel(liabilityRepository: testingLiabilityRepository, liability: liability, creditor: creditor)
        sut.deleteTransactions(at: IndexSet(integer: 0), for: MonthYear(month: .april, year: 2024))
        let actualPersitedTransactions = testingLiabilityRepository.getTransactions()
        XCTAssertTrue(expectedTransactions ≡ actualPersitedTransactions)
        let actualSutTransactions = sut.monthYears.map{ sut.getTransactions(fallingInto: $0) }.reduce([], +)
        XCTAssertTrue(expectedTransactions ≡ actualSutTransactions)
    }
}

