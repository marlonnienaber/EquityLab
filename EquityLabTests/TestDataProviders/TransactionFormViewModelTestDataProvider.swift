@testable import EquityLab
import CoreData

struct TransactionFormViewModelTestDataProvider {
    
    func createAndPersistTestObjects_createTransaction_liability(context: NSManagedObjectContext) -> (LoanPartner,Liability) {
        let person = DataFactory.createLoanPartner(name: "Lenni", context: context)
        let firstTransaction = DataFactory.createLoanTransaction(
            issuer: person,
            date: DateParser.shared.date(from: "1970-04-25T00:00:00")!,
            amount: 100,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liability = DataFactory.createLiability(
            name: "Blitz",
            creditor: person,
            transactions: [firstTransaction],
            context: context
        )
        return (person,liability)
    }

    func createAndPersistTestObjects_updateTransaction_liability1(context: NSManagedObjectContext) -> (LoanPartner,Liability,LoanTransaction) {
        let person = DataFactory.createLoanPartner(name: "Lenni", context: context)
        let firstTransaction = DataFactory.createLoanTransaction(
            issuer: person,
            date: DateParser.shared.date(from: "1970-04-25T00:00:00")!,
            amount: 100,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liability = DataFactory.createLiability(
            name: "Blitz",
            creditor: person,
            transactions: [firstTransaction],
            context: context
        )
        return (person,liability,firstTransaction)
    }
    
    func createAndPersistTestObjects_updateTransaction_liability2(context: NSManagedObjectContext) -> (LoanPartner,Liability,LoanTransaction) {
        let person = DataFactory.createLoanPartner(name: "Lenni", context: context)
        let firstTransaction = DataFactory.createLoanTransaction(
            issuer: person,
            date: DateParser.shared.date(from: "1970-04-25T00:00:00")!,
            amount: 100,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let secondTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "1970-04-27T00:00:00")!,
            amount: 50,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liability = DataFactory.createLiability(
            name: "Blitz",
            creditor: person,
            transactions: [firstTransaction,secondTransaction],
            context: context
        )
        return (person,liability,secondTransaction)
    }
    
    func createAndPersistTestObjects_createTransaction_receivable(context: NSManagedObjectContext) -> (LoanPartner,Receivable) {
        let person = DataFactory.createLoanPartner(name: "Lenni", context: context)
        let firstTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "1970-04-25T00:00:00")!,
            amount: 100,
            note: "disbursed amount",
            emoji: "📤",
            context: context
        )
        let liability = DataFactory.createReceivable(
            name: "Blitz",
            debtor: person,
            transactions: [firstTransaction],
            context: context
        )
        return (person,liability)
    }

    func createAndPersistTestObjects_updateTransaction_receivable1(context: NSManagedObjectContext) -> (LoanPartner,Receivable,LoanTransaction) {
        let person = DataFactory.createLoanPartner(name: "Lenni", context: context)
        let firstTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "1970-04-25T00:00:00")!,
            amount: 100,
            note: "disbursed amount",
            emoji: "📤",
            context: context
        )
        let liability = DataFactory.createReceivable(
            name: "Blitz",
            debtor: person,
            transactions: [firstTransaction],
            context: context
        )
        return (person,liability,firstTransaction)
    }
    
    func createAndPersistTestObjects_updateTransaction_receivable2(context: NSManagedObjectContext) -> (LoanPartner,Receivable,LoanTransaction) {
        let person = DataFactory.createLoanPartner(name: "Lenni", context: context)
        let firstTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "1970-04-25T00:00:00")!,
            amount: 100,
            note: "disbursed amount",
            emoji: "📤",
            context: context
        )
        let secondTransaction = DataFactory.createLoanTransaction(
            issuer: person,
            date: DateParser.shared.date(from: "1970-04-27T00:00:00")!,
            amount: 50,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liability = DataFactory.createReceivable(
            name: "Blitz",
            debtor: person,
            transactions: [firstTransaction,secondTransaction],
            context: context
        )
        return (person,liability,secondTransaction)
    }
}
