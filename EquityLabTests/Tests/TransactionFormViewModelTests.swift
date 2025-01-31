import XCTest
@testable import EquityLab

final class TransactionFormViewModelTests: XCTestCase {
    private var testingCoreDataStack: TestingCoreDataStack!
    private var testingAssetRepository: AssetRepository!
    private var testingLiabilityRepository: LiabilityRepository!
    private let testDataProvider = TransactionFormViewModelTestDataProvider()
    
    override func setUpWithError() throws {
        testingCoreDataStack = TestingCoreDataStack()
        testingAssetRepository = AssetRepository(context: testingCoreDataStack.context)
        testingLiabilityRepository = LiabilityRepository(context: testingCoreDataStack.context)
    }
    
    
    
    /// create a transaction for a Liability
    func test_createTransaction_liability() throws {
        let (loanPartner,liability) = testDataProvider.createAndPersistTestObjects_createTransaction_liability(context: testingCoreDataStack.context)
        let sut = TransactionFormViewModel(
            assetRepository: testingAssetRepository,
            liabilityRepository: testingLiabilityRepository,
            loanPartner: loanPartner,
            transactionAssociate: .liability(liability),
            dismissSheet: {}
        )
        
        let expectedValue: Decimal = 20
        let expectedNote = "first repayment"
        let expectedIssuer = LoanPartner?.none
        let expectedDate = DateParser.shared.date(from: "1970-04-27T00:00:00")!
        let expectedEmoji = "🔁"
        
        sut.value = expectedValue
        sut.note = expectedNote
        sut.date = expectedDate
        sut.selectedIssuer = expectedIssuer
        
        try sut.saveLoanTransaction()
        
        let transactions = testingLiabilityRepository.getTransactions().filter{ $0.liability == liability }.sorted{ $0.date < $1.date }
        XCTAssertTrue(transactions.count == 2)
        let newTransaction = try XCTUnwrap(transactions.last)
        
        let actualValue = newTransaction.amount.decimalValue
        let actualNote = newTransaction.note
        let actualDate = newTransaction.date
        let actualIssuer = newTransaction.issuer
        let actualEmoji = newTransaction.emoji
        
        XCTAssertEqual(expectedValue, actualValue)
        XCTAssertEqual(expectedNote, actualNote)
        XCTAssertEqual(expectedDate, actualDate)
        XCTAssertEqual(expectedIssuer, actualIssuer)
        XCTAssertEqual(expectedEmoji, actualEmoji)
    }
    
    /// update a transaction for a Liability
    func test_updateTransaction_liability() throws {
        let (loanPartner,liability,transactionToUpdate) = testDataProvider.createAndPersistTestObjects_updateTransaction_liability1(context: testingCoreDataStack.context)
        let sut = TransactionFormViewModel(
            assetRepository: testingAssetRepository,
            liabilityRepository: testingLiabilityRepository,
            transaction: transactionToUpdate,
            loanPartner: loanPartner,
            transactionAssociate: .liability(liability),
            dismissSheet: {}
        )
        
        let expectedValue: Decimal = 20
        let expectedNote = "only disbursement"
        let expectedIssuer = loanPartner
        let expectedDate = DateParser.shared.date(from: "1970-04-27T00:00:00")!
        let expectedEmoji = "💶"
        
        sut.value = expectedValue
        sut.note = expectedNote
        sut.date = expectedDate
        sut.selectedIssuer = expectedIssuer
        
        try sut.saveLoanTransaction()
        
        let transactions = testingLiabilityRepository.getTransactions().filter{ $0.liability == liability }
        XCTAssertTrue(transactions.count == 1)
        let newTransaction = try XCTUnwrap(transactions.first)
        
        let actualValue = newTransaction.amount.decimalValue
        let actualNote = newTransaction.note
        let actualDate = newTransaction.date
        let actualIssuer = newTransaction.issuer
        let actualEmoji = newTransaction.emoji
        
        XCTAssertEqual(expectedValue, actualValue)
        XCTAssertEqual(expectedNote, actualNote)
        XCTAssertEqual(expectedDate, actualDate)
        XCTAssertEqual(expectedIssuer, actualIssuer)
        XCTAssertEqual(expectedEmoji, actualEmoji)
    }
    
    
    
    /// create a transaction for a Receivable
    func test_createTransaction_receivable() throws {
        let (loanPartner,receivable) = testDataProvider.createAndPersistTestObjects_createTransaction_receivable(context: testingCoreDataStack.context)
        let sut = TransactionFormViewModel(
            assetRepository: testingAssetRepository,
            liabilityRepository: testingLiabilityRepository,
            loanPartner: loanPartner,
            transactionAssociate: .receivable(receivable),
            dismissSheet: {}
        )
        
        let expectedValue: Decimal = 20
        let expectedNote = "first repayment"
        let expectedIssuer = LoanPartner?.none
        let expectedDate = DateParser.shared.date(from: "1970-04-27T00:00:00")!
        let expectedEmoji = "📤"
        
        sut.value = expectedValue
        sut.note = expectedNote
        sut.date = expectedDate
        sut.selectedIssuer = expectedIssuer
        
        try sut.saveLoanTransaction()
        
        let transactions = testingAssetRepository.getTransactions().filter{ $0.receivable == receivable }.sorted{ $0.date < $1.date }
        XCTAssertTrue(transactions.count == 2)
        let newTransaction = try XCTUnwrap(transactions.last)
        
        let actualValue = newTransaction.amount.decimalValue
        let actualNote = newTransaction.note
        let actualDate = newTransaction.date
        let actualIssuer = newTransaction.issuer
        let actualEmoji = newTransaction.emoji
        
        XCTAssertEqual(expectedValue, actualValue)
        XCTAssertEqual(expectedNote, actualNote)
        XCTAssertEqual(expectedDate, actualDate)
        XCTAssertEqual(expectedIssuer, actualIssuer)
        XCTAssertEqual(expectedEmoji, actualEmoji)
    }
    
    /// update a transaction for a Receivable
    func test_updateTransaction_receivable() throws {
        let (loanPartner,receivable,transactionToUpdate) = testDataProvider.createAndPersistTestObjects_updateTransaction_receivable1(context: testingCoreDataStack.context)
        let sut = TransactionFormViewModel(
            assetRepository: testingAssetRepository,
            liabilityRepository: testingLiabilityRepository,
            transaction: transactionToUpdate,
            loanPartner: loanPartner,
            transactionAssociate: .receivable(receivable),
            dismissSheet: {}
        )
        
        let expectedValue: Decimal = 20
        let expectedNote = "only disbursement"
        let expectedIssuer = LoanPartner?.none
        let expectedDate = DateParser.shared.date(from: "1970-04-27T00:00:00")!
        let expectedEmoji = "📤"
        
        sut.value = expectedValue
        sut.note = expectedNote
        sut.date = expectedDate
        sut.selectedIssuer = expectedIssuer
        
        try sut.saveLoanTransaction()
        
        let transactions = testingAssetRepository.getTransactions().filter{ $0.receivable == receivable }
        XCTAssertTrue(transactions.count == 1)
        let newTransaction = try XCTUnwrap(transactions.first)
        
        let actualValue = newTransaction.amount.decimalValue
        let actualNote = newTransaction.note
        let actualDate = newTransaction.date
        let actualIssuer = newTransaction.issuer
        let actualEmoji = newTransaction.emoji
        
        XCTAssertEqual(expectedValue, actualValue)
        XCTAssertEqual(expectedNote, actualNote)
        XCTAssertEqual(expectedDate, actualDate)
        XCTAssertEqual(expectedIssuer, actualIssuer)
        XCTAssertEqual(expectedEmoji, actualEmoji)
    }
    
    
    
    /// create a transaction for a Receivable with value 0 and test whether correct error is thrown
    func test_createTransactionWithInvalidValue_receivable() throws {
        let (loanPartner,receivable) = testDataProvider.createAndPersistTestObjects_createTransaction_receivable(context: testingCoreDataStack.context)
        let sut = TransactionFormViewModel(
            assetRepository: testingAssetRepository,
            liabilityRepository: testingLiabilityRepository,
            loanPartner: loanPartner,
            transactionAssociate: .receivable(receivable),
            dismissSheet: {}
        )
        
        let expectedValue: Decimal = 0
        let expectedNote = "some transaction"
        let expectedIssuer = LoanPartner?.none
        let expectedDate = DateParser.shared.date(from: "1970-04-27T00:00:00")!
        
        sut.value = expectedValue
        sut.note = expectedNote
        sut.date = expectedDate
        sut.selectedIssuer = expectedIssuer
        
        XCTAssertThrowsError(try sut.saveLoanTransaction()) { error in
            XCTAssertEqual(error as? TransactionValidationError, TransactionValidationError.valueNotStrictlyPositive)
        }
    }
    
    /// create a repayment for a Receivable with a date predating the initial transactionand and  test whether correct error is thrown
    func test_createTransactionWithInvalidDate_receivable() throws {
        let (loanPartner,receivable) = testDataProvider.createAndPersistTestObjects_createTransaction_receivable(context: testingCoreDataStack.context)
        let sut = TransactionFormViewModel(
            assetRepository: testingAssetRepository,
            liabilityRepository: testingLiabilityRepository,
            loanPartner: loanPartner,
            transactionAssociate: .receivable(receivable),
            dismissSheet: {}
        )
        
        let expectedValue: Decimal = 20
        let expectedNote = "first repayment"
        let expectedIssuer = loanPartner
        let expectedDate = DateParser.shared.date(from: "1970-04-20T00:00:00")!
        
        sut.value = expectedValue
        sut.note = expectedNote
        sut.date = expectedDate
        sut.selectedIssuer = expectedIssuer
        
        XCTAssertThrowsError(try sut.saveLoanTransaction()) { error in
            XCTAssertEqual(error as? TransactionValidationError, TransactionValidationError.repaymentBeforeOrConcurrentToFirstDisbursement)
        }
    }
    
    /// update a transaction for a Receivable with value 0 and test whether correct error is thrown
    func test_updateTransactionWithInvalidValue_receivable() throws {
        let (loanPartner,receivable,transactionToUpdate) = testDataProvider.createAndPersistTestObjects_updateTransaction_receivable1(context: testingCoreDataStack.context)
        let sut = TransactionFormViewModel(
            assetRepository: testingAssetRepository,
            liabilityRepository: testingLiabilityRepository,
            transaction: transactionToUpdate,
            loanPartner: loanPartner,
            transactionAssociate: .receivable(receivable),
            dismissSheet: {}
        )
        
        sut.value = 0
        
        XCTAssertThrowsError(try sut.saveLoanTransaction()) { error in
            XCTAssertEqual(error as? TransactionValidationError, TransactionValidationError.valueNotStrictlyPositive)
        }
    }
    
    /// update a repayment for a Receivable with a date predating the initial transactionand test whether correct error is thrown
    func test_updateTransactionWithInvalidDate_receivable() throws {
        let (loanPartner,receivable,transactionToUpdate) = testDataProvider.createAndPersistTestObjects_updateTransaction_receivable2(context: testingCoreDataStack.context)
        let sut = TransactionFormViewModel(
            assetRepository: testingAssetRepository,
            liabilityRepository: testingLiabilityRepository,
            transaction: transactionToUpdate,
            loanPartner: loanPartner,
            transactionAssociate: .receivable(receivable),
            dismissSheet: {}
        )
        
        sut.date = DateParser.shared.date(from: "1970-04-20T00:00:00")!
        
        XCTAssertThrowsError(try sut.saveLoanTransaction()) { error in
            XCTAssertEqual(error as? TransactionValidationError, TransactionValidationError.repaymentBeforeOrConcurrentToFirstDisbursement)
        }
    }
    
    /// update a transaction of a Receivable such that the total balance would become negative and test whether the correct error is thrown
    func test_updateTransactionCausingNegativeBalance_receivable() throws {
        let (loanPartner,receivable,transactionToUpdate) = testDataProvider.createAndPersistTestObjects_updateTransaction_receivable2(context: testingCoreDataStack.context)
        let sut = TransactionFormViewModel(
            assetRepository: testingAssetRepository,
            liabilityRepository: testingLiabilityRepository,
            transaction: transactionToUpdate,
            loanPartner: loanPartner,
            transactionAssociate: .receivable(receivable),
            dismissSheet: {}
        )
        
        sut.value = 200
        
        XCTAssertThrowsError(try sut.saveLoanTransaction()) { error in
            XCTAssertEqual(error as? TransactionValidationError, TransactionValidationError.negativeBalanceThroughCreation)
        }
    }
    
    
    
    /// create a transaction for a Liability with value 0 and test whether correct error is thrown
    func test_createTransactionWithInvalidValue_liability() throws {
        let (loanPartner,liability) = testDataProvider.createAndPersistTestObjects_createTransaction_liability(context: testingCoreDataStack.context)
        let sut = TransactionFormViewModel(
            assetRepository: testingAssetRepository,
            liabilityRepository: testingLiabilityRepository,
            loanPartner: loanPartner,
            transactionAssociate: .liability(liability),
            dismissSheet: {}
        )
        
        let expectedValue: Decimal = 0
        let expectedNote = "some transaction"
        let expectedIssuer = LoanPartner?.none
        let expectedDate = DateParser.shared.date(from: "1970-04-27T00:00:00")!
        
        sut.value = expectedValue
        sut.note = expectedNote
        sut.date = expectedDate
        sut.selectedIssuer = expectedIssuer
        
        XCTAssertThrowsError(try sut.saveLoanTransaction()) { error in
            XCTAssertEqual(error as? TransactionValidationError, TransactionValidationError.valueNotStrictlyPositive)
        }
    }

    /// create a repayment for a Liability with a date predating the initial transaction and test whether correct error is thrown
    func test_createTransactionWithInvalidDate_liability() throws {
        let (loanPartner,liability) = testDataProvider.createAndPersistTestObjects_createTransaction_liability(context: testingCoreDataStack.context)
        let sut = TransactionFormViewModel(
            assetRepository: testingAssetRepository,
            liabilityRepository: testingLiabilityRepository,
            loanPartner: loanPartner,
            transactionAssociate: .liability(liability),
            dismissSheet: {}
        )
        
        let expectedValue: Decimal = 20
        let expectedNote = "first repayment"
        let expectedIssuer = LoanPartner?.none
        let expectedDate = DateParser.shared.date(from: "1970-04-20T00:00:00")!
        
        sut.value = expectedValue
        sut.note = expectedNote
        sut.date = expectedDate
        sut.selectedIssuer = expectedIssuer
        
        XCTAssertThrowsError(try sut.saveLoanTransaction()) { error in
            XCTAssertEqual(error as? TransactionValidationError, TransactionValidationError.repaymentBeforeOrConcurrentToFirstDisbursement)
        }
    }

    /// update a transaction for a Liability with value 0 and test whether correct error is thrown
    func test_updateTransactionWithInvalidValue_liability() throws {
        let (loanPartner,liability,transactionToUpdate) = testDataProvider.createAndPersistTestObjects_updateTransaction_liability1(context: testingCoreDataStack.context)
        let sut = TransactionFormViewModel(
            assetRepository: testingAssetRepository,
            liabilityRepository: testingLiabilityRepository,
            transaction: transactionToUpdate,
            loanPartner: loanPartner,
            transactionAssociate: .liability(liability),
            dismissSheet: {}
        )
        
        sut.value = 0
        
        XCTAssertThrowsError(try sut.saveLoanTransaction()) { error in
            XCTAssertEqual(error as? TransactionValidationError, TransactionValidationError.valueNotStrictlyPositive)
        }
    }

    /// update a repayment for a Liability with a date predating the initial transaction and test whether correct error is thrown
    func test_updateTransactionWithInvalidDate_liability() throws {
        let (loanPartner,liability,transactionToUpdate) = testDataProvider.createAndPersistTestObjects_updateTransaction_liability2(context: testingCoreDataStack.context)
        let sut = TransactionFormViewModel(
            assetRepository: testingAssetRepository,
            liabilityRepository: testingLiabilityRepository,
            transaction: transactionToUpdate,
            loanPartner: loanPartner,
            transactionAssociate: .liability(liability),
            dismissSheet: {}
        )
        
        sut.date = DateParser.shared.date(from: "1970-04-20T00:00:00")!
        
        XCTAssertThrowsError(try sut.saveLoanTransaction()) { error in
            XCTAssertEqual(error as? TransactionValidationError, TransactionValidationError.repaymentBeforeOrConcurrentToFirstDisbursement)
        }
    }
    
    /// update a transaction of a Liability such that the total balance would become negative and test whether the correct error is thrown
    func test_updateTransactionCausingNegativeBalance_liability() throws {
        let (loanPartner,liability,transactionToUpdate) = testDataProvider.createAndPersistTestObjects_updateTransaction_liability2(context: testingCoreDataStack.context)
        let sut = TransactionFormViewModel(
            assetRepository: testingAssetRepository,
            liabilityRepository: testingLiabilityRepository,
            transaction: transactionToUpdate,
            loanPartner: loanPartner,
            transactionAssociate: .liability(liability),
            dismissSheet: {}
        )
        
        sut.value = 200
        
        XCTAssertThrowsError(try sut.saveLoanTransaction()) { error in
            XCTAssertEqual(error as? TransactionValidationError, TransactionValidationError.negativeBalanceThroughCreation)
        }
    }
}
