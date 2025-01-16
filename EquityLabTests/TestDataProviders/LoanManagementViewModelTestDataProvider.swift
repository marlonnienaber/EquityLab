@testable import EquityLab
import CoreData

struct LoanManagementViewModelTestDataProvider {
    private func createAndPersistFourReceivables(using context: NSManagedObjectContext) -> (Receivable,Receivable,Receivable,Receivable) {
        let date_21_10_1966 = DateParser.shared.date(from: "1966-10-21T00:00:00")!
        let date_23_04_1970 = DateParser.shared.date(from: "1970-04-23T00:00:00")!
        let date_25_04_1970 = DateParser.shared.date(from: "1970-04-25T00:00:00")!
        let date_01_01_2002 = DateParser.shared.date(from: "2002-01-01T00:00:00")!
        let date_05_01_2002 = DateParser.shared.date(from: "2002-01-05T00:00:00")!
        let date_26_04_2002 = DateParser.shared.date(from: "2002-04-26T00:00:00")!
        
        let name1 = "Blitz"
        let person1 = DataFactory.createLoanPartner(name: "Lenni", context: context)
        let receivable1FirstTransaction = DataFactory.createLoanTransaction(
            date: date_21_10_1966,
            amount: 100,
            note: "disbursed amount",
            emoji: "📤",
            context: context
        )
        let receivable1 = DataFactory.createReceivable(
            name: name1,
            debtor: person1,
            transactions: [receivable1FirstTransaction],
            context: context
        )
        
        let name2 = "Lola Bar"
        let receivable2FirstTransaction = DataFactory.createLoanTransaction(
            date: date_23_04_1970,
            amount: 100,
            note: "disbursed amount",
            emoji: "📤",
            context: context
        )
        let receivable2SecondTransaction = DataFactory.createLoanTransaction(
            issuer: person1,
            date: date_25_04_1970,
            amount: 20,
            note: "repayment",
            emoji: "💶",
            context: context
        )
        let receivable2 = DataFactory.createReceivable(
            name: name2,
            debtor: person1,
            transactions: [receivable2FirstTransaction,receivable2SecondTransaction],
            context: context
        )
        
        let name3 = "Haushalt"
        let person2 = DataFactory.createLoanPartner(name: "Philipp", context: context)
        let receivable3FirstTransaction = DataFactory.createLoanTransaction(
            date: date_01_01_2002,
            amount: 330,
            note: "disbursed amount",
            emoji: "📤",
            context: context
        )
        let receivable3SecondTransaction = DataFactory.createLoanTransaction(
            issuer: person2,
            date: date_05_01_2002,
            amount: 50,
            note: "repayment",
            emoji: "💶",
            context: context
        )
        let receivable3 = DataFactory.createReceivable(
            name: name3,
            debtor: person2,
            transactions: [receivable3FirstTransaction,receivable3SecondTransaction],
            context: context
        )
        
        let name4 = "PRST"
        let person3 = DataFactory.createLoanPartner(name: "Filip", context: context)
        let receivable4FirstTransaction = DataFactory.createLoanTransaction(
            date: date_26_04_2002,
            amount: 17,
            note: "disbursed amount",
            emoji: "📤",
            context: context
        )
        let receivable4 = DataFactory.createReceivable(
            name: name4,
            debtor: person3,
            transactions: [receivable4FirstTransaction],
            context: context
        )
        
        let _ = DataFactory.createAssetPool(named: "Darlehen", possessions: [], receivables: [receivable1,receivable2,receivable3,receivable4], in: context)
        return (receivable1,receivable2,receivable3,receivable4)
    }
    
    func createAndPersistTestObjects_deleteReceivablesWithIndices_1(using context: NSManagedObjectContext) -> (IndexSet,[Receivable]) {
        let (receivable1,receivable2,receivable3,receivable4) = createAndPersistFourReceivables(using: context)
        return (IndexSet(),[receivable1, receivable2, receivable3, receivable4])
    }
    
    func createAndPersistTestObjects_deleteReceivablesWithIndices_2(using context: NSManagedObjectContext) -> (IndexSet,[Receivable]) {
        let (receivable1,receivable2,receivable3,receivable4) = createAndPersistFourReceivables(using: context)
        return (IndexSet(integer: 0),[receivable2, receivable3, receivable4])
    }

    func createAndPersistTestObjects_deleteReceivablesWithIndices_3(using context: NSManagedObjectContext) -> (IndexSet,[Receivable]) {
        let (receivable1,receivable2,receivable3,receivable4) = createAndPersistFourReceivables(using: context)
        return (IndexSet(integer: 3),[receivable1, receivable2, receivable3])
    }
    
    func createAndPersistTestObjects_deleteReceivablesWithIndices_4(using context: NSManagedObjectContext) -> (IndexSet,[Receivable]) {
        let (receivable1,receivable2,receivable3,receivable4) = createAndPersistFourReceivables(using: context)
        return (IndexSet(integer: 1),[receivable1, receivable3, receivable4])
    }
    
    func createAndPersistTestObjects_deleteReceivablesWithIndices_5(using context: NSManagedObjectContext) -> (IndexSet,[Receivable]) {
        let (receivable1,receivable2,receivable3,receivable4) = createAndPersistFourReceivables(using: context)
        return (IndexSet(0...2),[receivable4])
    }
    
    func createAndPersistTestObjects_deleteReceivablesWithIndices_6(using context: NSManagedObjectContext) -> (IndexSet,[Receivable]) {
        let (receivable1,receivable2,receivable3,receivable4) = createAndPersistFourReceivables(using: context)
        return (IndexSet(0...3),[])
    }
    
    
    private func createAndPersistFourLiabilities(using context: NSManagedObjectContext) -> (Liability,Liability,Liability,Liability) {
        let date_21_10_1966 = DateParser.shared.date(from: "1966-10-21T00:00:00")!
        let date_23_04_1970 = DateParser.shared.date(from: "1970-04-23T00:00:00")!
        let date_25_04_1970 = DateParser.shared.date(from: "1970-04-25T00:00:00")!
        let date_01_01_2002 = DateParser.shared.date(from: "2002-01-01T00:00:00")!
        let date_05_01_2002 = DateParser.shared.date(from: "2002-01-05T00:00:00")!
        let date_26_04_2002 = DateParser.shared.date(from: "2002-04-26T00:00:00")!
        
        let name1 = "Blitz"
        let person1 = DataFactory.createLoanPartner(name: "Lenni", context: context)
        let liability1FirstTransaction = DataFactory.createLoanTransaction(
            issuer: person1,
            date: date_21_10_1966,
            amount: 100,
            note: "disbursed amount",
            emoji: "📤",
            context: context
        )
        let liability1 = DataFactory.createLiability(
            name: name1,
            creditor: person1,
            transactions: [liability1FirstTransaction],
            context: context
        )
        
        let name2 = "Lola Bar"
        let liability2FirstTransaction = DataFactory.createLoanTransaction(
            issuer: person1,
            date: date_23_04_1970,
            amount: 100,
            note: "disbursed amount",
            emoji: "📤",
            context: context
        )
        let liability2SecondTransaction = DataFactory.createLoanTransaction(
            date: date_25_04_1970,
            amount: 20,
            note: "repayment",
            emoji: "💶",
            context: context
        )
        let liability2 = DataFactory.createLiability(
            name: name2,
            creditor: person1,
            transactions: [liability2FirstTransaction,liability2SecondTransaction],
            context: context
        )
        
        let name3 = "Haushalt"
        let person2 = DataFactory.createLoanPartner(name: "Philipp", context: context)
        let liability3FirstTransaction = DataFactory.createLoanTransaction(
            issuer: person2,
            date: date_01_01_2002,
            amount: 330,
            note: "disbursed amount",
            emoji: "📤",
            context: context
        )
        let liability3SecondTransaction = DataFactory.createLoanTransaction(
            date: date_05_01_2002,
            amount: 50,
            note: "repayment",
            emoji: "💶",
            context: context
        )
        let liability3 = DataFactory.createLiability(
            name: name3,
            creditor: person2,
            transactions: [liability3FirstTransaction,liability3SecondTransaction],
            context: context
        )
        
        let name4 = "PRST"
        let person3 = DataFactory.createLoanPartner(name: "Filip", context: context)
        let liability4FirstTransaction = DataFactory.createLoanTransaction(
            issuer: person3,
            date: date_26_04_2002,
            amount: 17,
            note: "disbursed amount",
            emoji: "📤",
            context: context
        )
        let liability4 = DataFactory.createLiability(
            name: name4,
            creditor: person3,
            transactions: [liability4FirstTransaction],
            context: context
        )
        
        let _ = DataFactory.createLiabilityPool(named: "Darlehen", liabilities: [liability1,liability2,liability3,liability4], in: context)
        return (liability1,liability2,liability3,liability4)
    }
    
    func createAndPersistTestObjects_deleteLiabilitiesWithIndices_1(using context: NSManagedObjectContext) -> (IndexSet,[Liability]) {
        let (liability1,liability2,liability3,liability4) = createAndPersistFourLiabilities(using: context)
        return (IndexSet(),[liability1,liability2,liability3,liability4])
    }
    
    func createAndPersistTestObjects_deleteLiabilitiesWithIndices_2(using context: NSManagedObjectContext) -> (IndexSet,[Liability]) {
        let (liability1,liability2,liability3,liability4) = createAndPersistFourLiabilities(using: context)
        return (IndexSet(integer: 0),[liability2,liability3,liability4])
    }
    
    func createAndPersistTestObjects_deleteLiabilitiesWithIndices_3(using context: NSManagedObjectContext) -> (IndexSet,[Liability]) {
        let (liability1,liability2,liability3,liability4) = createAndPersistFourLiabilities(using: context)
        return (IndexSet(integer: 3),[liability1,liability2,liability3])
    }
    
    func createAndPersistTestObjects_deleteLiabilitiesWithIndices_4(using context: NSManagedObjectContext) -> (IndexSet,[Liability]) {
        let (liability1,liability2,liability3,liability4) = createAndPersistFourLiabilities(using: context)
        return (IndexSet(integer: 2),[liability1,liability2,liability4])
    }

    func createAndPersistTestObjects_deleteLiabilitiesWithIndices_5(using context: NSManagedObjectContext) -> (IndexSet,[Liability]) {
        let (liability1,liability2,liability3,liability4) = createAndPersistFourLiabilities(using: context)
        return (IndexSet(2...3),[liability1,liability2])
    }
    
    func createAndPersistTestObjects_deleteLiabilitiesWithIndices_6(using context: NSManagedObjectContext) -> (IndexSet,[Liability]) {
        let (liability1,liability2,liability3,liability4) = createAndPersistFourLiabilities(using: context)
        return (IndexSet(0...3),[])
    }
}
