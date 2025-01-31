@testable import EquityLab
import CoreData

struct LiabilityFormViewModelTestDataProvider {
    func createAndPersistTestObjects_getLiabilityPools_1(using context: NSManagedObjectContext) -> [LiabilityPool] {
        let person1 = DataFactory.createLoanPartner(name: "Papa", context: context)
        let liability1FirstTransaction = DataFactory.createLoanTransaction(
            issuer: person1,
            date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
            amount: 1000,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liability1SecondTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-04-17T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liability1 = DataFactory.createLiability(
            name: "Auto",
            creditor: person1,
            transactions: [liability1FirstTransaction, liability1SecondTransaction],
            context: context
        )
        
        let person2 = DataFactory.createLoanPartner(name: "Mama", context: context)
        let liability2FirstTransaction = DataFactory.createLoanTransaction(
            issuer: person2,
            date: DateParser.shared.date(from: "2024-09-15T00:00:00")!,
            amount: 300,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liability2SecondTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-09-16T00:00:00")!,
            amount: 50,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liability2 = DataFactory.createLiability(
            name: "Booth",
            creditor: person2,
            transactions: [liability2FirstTransaction,liability2SecondTransaction],
            context: context
        )
        
        let person3 = DataFactory.createLoanPartner(name: "Bayerische Landesregierung", context: context)
        let liability3FirstTransaction = DataFactory.createLoanTransaction(
            issuer: person3,
            date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
            amount: 5000,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liability3SecondTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-07-25T00:00:00")!,
            amount: 1300,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liability3 = DataFactory.createLiability(
            name: "Studium",
            creditor: person3,
            transactions: [liability3FirstTransaction, liability3SecondTransaction],
            context: context
        )
        
        let liabilityPoolName1 = "Privat"
        let liabilityPoolName2 = "Staatlich"
        let liabilityPool1 = DataFactory.createLiabilityPool(named: liabilityPoolName1, liabilities: [liability1,liability2], in: context)
        let liabilityPool2 = DataFactory.createLiabilityPool(named: liabilityPoolName2, liabilities: [liability3], in: context)

        
        return [liabilityPool1,liabilityPool2]
    }
    
    func createAndPersistTestObjects_createLiability_1(context: NSManagedObjectContext) -> (LiabilityPool, LoanPartner) {
        let liabilityPool = DataFactory.createLiabilityPool(named: "Privat", liabilities: [], in: context)
        let partner = DataFactory.createLoanPartner(name: "Papa", context: context)
        return (liabilityPool,partner)
    }
    
    func createAndPersistTestObjects_createLiability_2(using context: NSManagedObjectContext) -> String {
        let liabilityName = "Auto"
        let person1 = DataFactory.createLoanPartner(name: "Papa", context: context)
        let liability1FirstTransaction = DataFactory.createLoanTransaction(
            issuer: person1,
            date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
            amount: 1000,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liability1SecondTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-04-17T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liability1 = DataFactory.createLiability(
            name: liabilityName,
            creditor: person1,
            transactions: [liability1FirstTransaction, liability1SecondTransaction],
            context: context
        )
        return liabilityName
    }
    
    func createAndPersistTestObjects_updateOrDeleteLiability_1(context: NSManagedObjectContext) -> Liability {
        let person1 = DataFactory.createLoanPartner(name: "Papa", context: context)
        let liability1FirstTransaction = DataFactory.createLoanTransaction(
            issuer: person1,
            date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
            amount: 1000,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liability1SecondTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-04-17T00:00:00")!,
            amount: 200,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liability1 = DataFactory.createLiability(
            name: "Auto",
            creditor: person1,
            transactions: [liability1FirstTransaction, liability1SecondTransaction],
            context: context
        )
        
        let _ = DataFactory.createLiabilityPool(named: "Privat", liabilities: [liability1], in: context)
        
        return liability1
    }
    
    func createAndPersistTestObjects_updateLiability_2(context: NSManagedObjectContext) -> (Liability,String) {
        let person1 = DataFactory.createLoanPartner(name: "Papa", context: context)
        let liability1FirstTransaction = DataFactory.createLoanTransaction(
            issuer: person1,
            date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
            amount: 1000,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liability1SecondTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-04-17T00:00:00")!,
            amount: 200,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liability1 = DataFactory.createLiability(
            name: "Auto",
            creditor: person1,
            transactions: [liability1FirstTransaction, liability1SecondTransaction],
            context: context
        )
        
        let occupiedName = "Booth"
        let person2 = DataFactory.createLoanPartner(name: "Mama", context: context)
        let liability2FirstTransaction = DataFactory.createLoanTransaction(
            issuer: person2,
            date: DateParser.shared.date(from: "2024-09-15T00:00:00")!,
            amount: 300,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liability2SecondTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-09-16T00:00:00")!,
            amount: 50,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liability2 = DataFactory.createLiability(
            name: occupiedName,
            creditor: person2,
            transactions: [liability2FirstTransaction,liability2SecondTransaction],
            context: context
        )
        
        let _ = DataFactory.createLiabilityPool(named: "Privat", liabilities: [liability1], in: context)
        
        return (liability1,occupiedName)
    }
}
