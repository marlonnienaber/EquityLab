@testable import EquityLab
import CoreData

struct ReceivableDetailViewModelTestDataProvider {
    private func createReceivable(context: NSManagedObjectContext) -> (LoanPartner,Receivable) {
        let person = DataFactory.createLoanPartner(name: "Papa", context: context)
        let receivableTransaction1 = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
            amount: 3000,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let receivableTransaction2 = DataFactory.createLoanTransaction(
            issuer: person,
            date: DateParser.shared.date(from: "2024-04-17T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let receivableTransaction3 = DataFactory.createLoanTransaction(
            issuer: person,
            date: DateParser.shared.date(from: "2024-07-11T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let receivableTransaction4 = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-07-27T00:00:00")!,
            amount: 1000,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let receivableTransaction5 = DataFactory.createLoanTransaction(
            issuer: person,
            date: DateParser.shared.date(from: "2024-12-01T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let receivableTransaction6 = DataFactory.createLoanTransaction(
            issuer: person,
            date: DateParser.shared.date(from: "2025-01-03T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let receivable = DataFactory.createReceivable(
            name: "Studium",
            debtor: person,
            transactions: [
                receivableTransaction1,
                receivableTransaction2,
                receivableTransaction3,
                receivableTransaction4,
                receivableTransaction5,
                receivableTransaction6,
            ],
            context: context
        )
        return (person,receivable)
    }
    
    func createAndPersistTestObjects_monthYears(context: NSManagedObjectContext) -> (LoanPartner,Receivable,[MonthYear]) {
        let (person,receivable) = createReceivable(context: context)
        let expectedMonthYears = [
            MonthYear(month: .january, year: 2025),
            MonthYear(month: .december, year: 2024),
            MonthYear(month: .july, year: 2024),
            MonthYear(month: .april, year: 2024)
        ]
        return (person,receivable,expectedMonthYears)
    }
    
    func createAndPersistTestObjects_getTransactionFallingIntoMonthYear(context: NSManagedObjectContext) -> (LoanPartner,Receivable,[MonthYear:[LoanTransaction]]) {
        let person = DataFactory.createLoanPartner(name: "Papa", context: context)
        let receivableTransaction1 = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
            amount: 3000,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let receivableTransaction2 = DataFactory.createLoanTransaction(
            issuer: person,
            date: DateParser.shared.date(from: "2024-04-17T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let receivableTransaction3 = DataFactory.createLoanTransaction(
            issuer: person,
            date: DateParser.shared.date(from: "2024-07-11T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let receivableTransaction4 = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-07-27T00:00:00")!,
            amount: 1000,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let receivableTransaction5 = DataFactory.createLoanTransaction(
            issuer: person,
            date: DateParser.shared.date(from: "2024-12-01T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let receivableTransaction6 = DataFactory.createLoanTransaction(
            issuer: person,
            date: DateParser.shared.date(from: "2025-01-03T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let receivable = DataFactory.createReceivable(
            name: "Studium",
            debtor: person,
            transactions: [
                receivableTransaction1,
                receivableTransaction2,
                receivableTransaction3,
                receivableTransaction4,
                receivableTransaction5,
                receivableTransaction6,
            ],
            context: context
        )
        var monthYearTotransactionsDictionary: [MonthYear:[LoanTransaction]] = [:]
        monthYearTotransactionsDictionary[MonthYear(month: .january, year: 2025)] = [receivableTransaction6]
        monthYearTotransactionsDictionary[MonthYear(month: .december, year: 2024)] = [receivableTransaction5]
        monthYearTotransactionsDictionary[MonthYear(month: .july, year: 2024)] = [receivableTransaction4,receivableTransaction3]
        monthYearTotransactionsDictionary[MonthYear(month: .april, year: 2024)] = [receivableTransaction2,receivableTransaction1]
        return (person,receivable,monthYearTotransactionsDictionary)
    }
    
    func createAndPersistTestObjects_deleteTransactions_1(context: NSManagedObjectContext) -> (LoanPartner,Receivable,[LoanTransaction]) {
        let person = DataFactory.createLoanPartner(name: "Papa", context: context)
        let receivableTransaction1 = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
            amount: 3000,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let receivableTransaction2 = DataFactory.createLoanTransaction(
            issuer: person,
            date: DateParser.shared.date(from: "2024-04-17T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let receivableTransaction3 = DataFactory.createLoanTransaction(
            issuer: person,
            date: DateParser.shared.date(from: "2024-07-11T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let receivableTransaction4 = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-07-27T00:00:00")!,
            amount: 1000,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let receivableTransaction5 = DataFactory.createLoanTransaction(
            issuer: person,
            date: DateParser.shared.date(from: "2024-12-01T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let receivableTransaction6 = DataFactory.createLoanTransaction(
            issuer: person,
            date: DateParser.shared.date(from: "2025-01-03T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let receivable = DataFactory.createReceivable(
            name: "Studium",
            debtor: person,
            transactions: [
                receivableTransaction1,
                receivableTransaction2,
                receivableTransaction3,
                receivableTransaction4,
                receivableTransaction5,
                receivableTransaction6,
            ],
            context: context
        )
        return (person,receivable,[receivableTransaction3,receivableTransaction4,receivableTransaction5,receivableTransaction6])
    }
    
    func createAndPersistTestObjects_deleteTransactions_2(context: NSManagedObjectContext) -> (LoanPartner,Receivable,[LoanTransaction]) {
        let person = DataFactory.createLoanPartner(name: "Papa", context: context)
        let receivableTransaction1 = DataFactory.createLoanTransaction(
            issuer: person,
            date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
            amount: 3000,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let receivableTransaction2 = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-04-17T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let receivableTransaction3 = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-07-11T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let receivableTransaction4 = DataFactory.createLoanTransaction(
            issuer: person,
            date: DateParser.shared.date(from: "2024-07-27T00:00:00")!,
            amount: 1000,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let receivableTransaction5 = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-12-01T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let receivableTransaction6 = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2025-01-03T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let receivable = DataFactory.createReceivable(
            name: "Studium",
            debtor: person,
            transactions: [
                receivableTransaction1,
                receivableTransaction2,
                receivableTransaction3,
                receivableTransaction4,
                receivableTransaction5,
                receivableTransaction6,
            ],
            context: context
        )
        return (person,receivable,[receivableTransaction1,receivableTransaction3,receivableTransaction4,receivableTransaction5,receivableTransaction6])
    }
}
