@testable import EquityLab
import CoreData

struct ReceivableFormViewModelTestDataProvider {
    func createAndPersitsTestObjects_getAssetPools_1(using context: NSManagedObjectContext) -> [AssetPool] {
        let person1 = DataFactory.createLoanPartner(name: "Lenni", context: context)
        let receivable1FirstTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
            amount: 20,
            note: "disbursed amount",
            emoji: "📤",
            context: context
        )
        let asset1 = DataFactory.createReceivable(
            name: "Blitz",
            debtor: person1,
            transactions: [receivable1FirstTransaction],
            context: context
        )
        let asset2 = DataFactory.createPossession(name: "Geldbeutel", volatile: true, context: context)
        let asset3 = DataFactory.createPossession(name: "Konto Sparkasse", volatile: true, context: context)
        let asset4 = DataFactory.createPossession(name: "Konto Commerzbank", volatile: true, context: context)
        let asset5 = DataFactory.createPossession(name: "Depot FNZ", volatile: true, context: context)
        
        let assetPoolName1 = "Bargeld"
        let assetPoolName2 = "Bank"
        let assetPoolName3 = "Wertpapiere"
        let assetPoolName4 = "Geliehen"
        let assetPool1 = DataFactory.createAssetPool(named: assetPoolName1, possessions: [asset2], receivables: [], in: context)
        let assetPool2 = DataFactory.createAssetPool(named: assetPoolName2, possessions: [asset3,asset4], receivables: [], in: context)
        let assetPool3 = DataFactory.createAssetPool(named: assetPoolName3, possessions: [asset5], receivables: [], in: context)
        let assetPool4 = DataFactory.createAssetPool(named: assetPoolName4,  possessions: [], receivables: [asset1], in: context)
        
        return [assetPool1,assetPool2,assetPool3,assetPool4]
    }
    
    func createAndPersistTestObjects_updateReceivable_multipurpose(context: NSManagedObjectContext) -> Receivable {
        let person1 = DataFactory.createLoanPartner(name: "Lenni", context: context)
        let receivable1FirstTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
            amount: 100,
            note: "disbursed amount",
            emoji: "📤",
            context: context
        )
        let receivable1SecondTransaction = DataFactory.createLoanTransaction(
            issuer: person1,
            date: DateParser.shared.date(from: "2024-04-17T00:00:00")!,
            amount: 20,
            note: "repayment",
            emoji: "💶",
            context: context
        )
        let asset1 = DataFactory.createReceivable(
            name: "Lenni",
            debtor: person1,
            transactions: [receivable1FirstTransaction,receivable1SecondTransaction],
            context: context
        )
        let _ = DataFactory.createAssetPool(named: "Darlehen", possessions: [], receivables: [asset1], in: context)
        return asset1
    }
    
    func createAndPersistTestObjects_createReceivable_multipurpose(context: NSManagedObjectContext) -> (AssetPool,LoanPartner) {
        let assetPool = DataFactory.createAssetPool(named: "Privat", possessions: [], receivables: [], in: context)
        let partner = DataFactory.createLoanPartner(name: "Philipp", context: context)
        return (assetPool,partner)
    }
    
    func createAndPersistTestObjects_createReceivablesWithSameName_1(context: NSManagedObjectContext) -> String {
        let name1 = "Blitz"
        let person1 = DataFactory.createLoanPartner(name: "Lenni", context: context)
        let receivable1FirstTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
            amount: 100,
            note: "disbursed amount",
            emoji: "📤",
            context: context
        )
        let receivable1SecondTransaction = DataFactory.createLoanTransaction(
            issuer: person1,
            date: DateParser.shared.date(from: "2024-04-17T00:00:00")!,
            amount: 20,
            note: "repayment",
            emoji: "💶",
            context: context
        )
        let receivable1 = DataFactory.createReceivable(
            name: name1,
            debtor: person1,
            transactions: [receivable1FirstTransaction,receivable1SecondTransaction],
            context: context
        )
        let _ = DataFactory.createAssetPool(named: "Darlehen", possessions: [], receivables: [receivable1], in: context)
        return name1
    }
    
    func createAndPersistTestObjects_createReceivablesWithSameName_2(context: NSManagedObjectContext) -> String {
        let name1 = "Commerzbank Konto"
        let possession = DataFactory.createPossession(
            name: name1,
            volatile: true,
            context: context)
        let _ = DataFactory.createAssetPool(named: "Privat", possessions: [possession], receivables: [], in: context)
        return name1
    }
    
    func createAndPersistTestObjects_updateReceivablesWithSameName_1(context: NSManagedObjectContext) -> (Receivable,String) {
        let name1 = "Blitz"
        let person1 = DataFactory.createLoanPartner(name: "Lenni", context: context)
        let receivable1FirstTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
            amount: 100,
            note: "disbursed amount",
            emoji: "📤",
            context: context
        )
        let receivable1SecondTransaction = DataFactory.createLoanTransaction(
            issuer: person1,
            date: DateParser.shared.date(from: "2024-04-17T00:00:00")!,
            amount: 20,
            note: "repayment",
            emoji: "💶",
            context: context
        )
        let receivable1 = DataFactory.createReceivable(
            name: name1,
            debtor: person1,
            transactions: [receivable1FirstTransaction,receivable1SecondTransaction],
            context: context
        )
        let name2 = "Booth"
        let person2 = DataFactory.createLoanPartner(name: "Papa", context: context)
        let receivable2FirstTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-05-19T00:00:00")!,
            amount: 300,
            note: "disbursed amount",
            emoji: "📤",
            context: context
        )
        let receivable2SecondTransaction = DataFactory.createLoanTransaction(
            issuer: person2,
            date: DateParser.shared.date(from: "2024-07-21T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "💶",
            context: context
        )
        let receivable2 = DataFactory.createReceivable(
            name: name2,
            debtor: person2,
            transactions: [receivable2FirstTransaction,receivable2SecondTransaction],
            context: context
        )
        let _ = DataFactory.createAssetPool(named: "Darlehen", possessions: [], receivables: [receivable1,receivable2], in: context)
        return (receivable1,name2)
    }
    
    func createAndPersistTestObjects_updateReceivablesWithSameName_2(context: NSManagedObjectContext) -> (Receivable,String) {
        let name1 = "Commerzbank Konto"
        let possession = DataFactory.createPossession(
            name: name1,
            volatile: true,
            context: context)
        let name2 = "Booth"
        let person2 = DataFactory.createLoanPartner(name: "Papa", context: context)
        let receivableFirstTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-05-19T00:00:00")!,
            amount: 300,
            note: "disbursed amount",
            emoji: "📤",
            context: context
        )
        let receivableSecondTransaction = DataFactory.createLoanTransaction(
            issuer: person2,
            date: DateParser.shared.date(from: "2024-07-21T00:00:00")!,
            amount: 100,
            note: "repayment",
            emoji: "💶",
            context: context
        )
        let receivable = DataFactory.createReceivable(
            name: name2,
            debtor: person2,
            transactions: [receivableFirstTransaction,receivableSecondTransaction],
            context: context
        )
        let _ = DataFactory.createAssetPool(named: "Privat", possessions: [possession], receivables: [receivable], in: context)
        return (receivable,name1)
    }
}

