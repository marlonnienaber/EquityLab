@testable import EquityLab
import CoreData

struct LiabilityDetailViewModelTestDataProvider {
    private func createLiability(context: NSManagedObjectContext) -> (LoanPartner,Liability) {
        let person = DataFactory.createLoanPartner(name: "Papa", context: context)
        let liabilityTransaction1 = DataFactory.createLoanTransaction(
            issuer: person,
            date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
            amount: 3000,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liabilityTransaction2 = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-04-17T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liabilityTransaction3 = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-07-11T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liabilityTransaction4 = DataFactory.createLoanTransaction(
            issuer: person,
            date: DateParser.shared.date(from: "2024-07-27T00:00:00")!,
            amount: 1000,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liabilityTransaction5 = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-12-01T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liabilityTransaction6 = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2025-01-03T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liability = DataFactory.createLiability(
            name: "Studium",
            creditor: person,
            transactions: [
                liabilityTransaction1,
                liabilityTransaction2,
                liabilityTransaction3,
                liabilityTransaction4,
                liabilityTransaction5,
                liabilityTransaction6,
            ],
            context: context
        )
        return (person,liability)
    }
    
    func createAndPersistTestObjects_monthYears(context: NSManagedObjectContext) -> (LoanPartner,Liability,[MonthYear]) {
        let (person,liability) = createLiability(context: context)
        let expectedMonthYears = [
            MonthYear(month: .january, year: 2025),
            MonthYear(month: .december, year: 2024),
            MonthYear(month: .july, year: 2024),
            MonthYear(month: .april, year: 2024)
        ]
        return (person,liability,expectedMonthYears)
    }
    
    func createAndPersistTestObjects_getTransactionFallingIntoMonthYear(context: NSManagedObjectContext) -> (LoanPartner,Liability,[MonthYear:[LoanTransaction]]) {
        let person = DataFactory.createLoanPartner(name: "Papa", context: context)
        let liabilityTransaction1 = DataFactory.createLoanTransaction(
            issuer: person,
            date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
            amount: 3000,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liabilityTransaction2 = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-04-17T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liabilityTransaction3 = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-07-11T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liabilityTransaction4 = DataFactory.createLoanTransaction(
            issuer: person,
            date: DateParser.shared.date(from: "2024-07-27T00:00:00")!,
            amount: 1000,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liabilityTransaction5 = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-12-01T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liabilityTransaction6 = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2025-01-03T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liability = DataFactory.createLiability(
            name: "Studium",
            creditor: person,
            transactions: [
                liabilityTransaction1,
                liabilityTransaction2,
                liabilityTransaction3,
                liabilityTransaction4,
                liabilityTransaction5,
                liabilityTransaction6,
            ],
            context: context
        )
        var monthYearTotransactionsDictionary: [MonthYear:[LoanTransaction]] = [:]
        monthYearTotransactionsDictionary[MonthYear(month: .january, year: 2025)] = [liabilityTransaction6]
        monthYearTotransactionsDictionary[MonthYear(month: .december, year: 2024)] = [liabilityTransaction5]
        monthYearTotransactionsDictionary[MonthYear(month: .july, year: 2024)] = [liabilityTransaction4,liabilityTransaction3]
        monthYearTotransactionsDictionary[MonthYear(month: .april, year: 2024)] = [liabilityTransaction2,liabilityTransaction1]
        return (person,liability,monthYearTotransactionsDictionary)
    }
    
    func createAndPersistTestObjects_batchDeleteTransactions(context: NSManagedObjectContext) -> (LoanPartner,Liability,[LoanTransaction]) {
        let person = DataFactory.createLoanPartner(name: "Papa", context: context)
        let liabilityTransaction1 = DataFactory.createLoanTransaction(
            issuer: person,
            date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
            amount: 3000,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liabilityTransaction2 = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-04-17T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liabilityTransaction3 = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-07-11T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liabilityTransaction4 = DataFactory.createLoanTransaction(
            issuer: person,
            date: DateParser.shared.date(from: "2024-07-27T00:00:00")!,
            amount: 1000,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liabilityTransaction5 = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-12-01T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liabilityTransaction6 = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2025-01-03T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liability = DataFactory.createLiability(
            name: "Studium",
            creditor: person,
            transactions: [
                liabilityTransaction1,
                liabilityTransaction2,
                liabilityTransaction3,
                liabilityTransaction4,
                liabilityTransaction5,
                liabilityTransaction6,
            ],
            context: context
        )
        return (person,liability,[liabilityTransaction1,liabilityTransaction2,liabilityTransaction3,liabilityTransaction4,liabilityTransaction5,liabilityTransaction6])
    }
    
    func createAndPersistTestObjects_deleteTransactions(context: NSManagedObjectContext) -> (LoanPartner,Liability,[LoanTransaction]) {
        let person = DataFactory.createLoanPartner(name: "Papa", context: context)
        let liabilityTransaction1 = DataFactory.createLoanTransaction(
            issuer: person,
            date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
            amount: 3000,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liabilityTransaction2 = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-04-17T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liabilityTransaction3 = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-07-11T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liabilityTransaction4 = DataFactory.createLoanTransaction(
            issuer: person,
            date: DateParser.shared.date(from: "2024-07-27T00:00:00")!,
            amount: 1000,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liabilityTransaction5 = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-12-01T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liabilityTransaction6 = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2025-01-03T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liability = DataFactory.createLiability(
            name: "Studium",
            creditor: person,
            transactions: [
                liabilityTransaction1,
                liabilityTransaction2,
                liabilityTransaction3,
                liabilityTransaction4,
                liabilityTransaction5,
                liabilityTransaction6,
            ],
            context: context
        )
        return (person,liability,[liabilityTransaction1,liabilityTransaction3,liabilityTransaction4,liabilityTransaction5,liabilityTransaction6])
    }
    
    func createAndPersistTestObjects_deleteTransactionsNegativeBalanceThroughDeletion(context: NSManagedObjectContext) -> (LoanPartner,Liability,[LoanTransaction]) {
        let person = DataFactory.createLoanPartner(name: "Papa", context: context)
        let liabilityTransaction1 = DataFactory.createLoanTransaction(
            issuer: person,
            date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
            amount: 3000,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liabilityTransaction2 = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-04-17T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liabilityTransaction3 = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-07-11T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liabilityTransaction4 = DataFactory.createLoanTransaction(
            issuer: person,
            date: DateParser.shared.date(from: "2024-07-27T00:00:00")!,
            amount: 1000,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liabilityTransaction5 = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-12-01T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liabilityTransaction6 = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2025-01-03T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liability = DataFactory.createLiability(
            name: "Studium",
            creditor: person,
            transactions: [
                liabilityTransaction1,
                liabilityTransaction2,
                liabilityTransaction3,
                liabilityTransaction4,
                liabilityTransaction5,
                liabilityTransaction6,
            ],
            context: context
        )
        return (person,liability,[liabilityTransaction1,liabilityTransaction2,liabilityTransaction3,liabilityTransaction4,liabilityTransaction5,liabilityTransaction6])
    }
}

