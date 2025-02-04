@testable import EquityLab
import CoreData

struct PossessionFormViewModelTestDataProvider {
    func createAndPersitsTestObjects_getAssetPools_1(using context: NSManagedObjectContext) -> [AssetPool] {
        let name1 = "Blitz"
        let person1 = DataFactory.createLoanPartner(name: "Lenni", context: context)
        let receivable1FirstTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
            amount: 20,
            note: "disbursed amount",
            emoji: "📤",
            context: context
        )
        let asset1 = DataFactory.createReceivable(
            name: name1,
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
    
    func createAndPersistTestObjects_updatePossession_multipurpose(context: NSManagedObjectContext) -> Possession {
        let possession = DataFactory.createPossession(name: "Sparkasse Konto", volatile: true, context: context)
        let _ = DataFactory.createAssetPool(named: "Darlehen", possessions: [], receivables: [], in: context)
        return possession
    }
    
    func createAndPersistTestObjects_createPossessions_multipurpose(context: NSManagedObjectContext) -> AssetPool {
        DataFactory.createAssetPool(named: "Privat", possessions: [], receivables: [], in: context)
    }
    
    func createAndPersistTestObjects_createPossessionsWithSameName_2(context: NSManagedObjectContext) -> (Receivable,AssetPool) {
        let name1 = "Rote Sonne"
        let person1 = DataFactory.createLoanPartner(name: "Philipp", context: context)
        let receivable1FirstTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-07-23T00:00:00")!,
            amount: 200,
            note: "disbursed amount",
            emoji: "📤",
            context: context
        )
        let receivable1SecondTransaction = DataFactory.createLoanTransaction(
            issuer: person1,
            date: DateParser.shared.date(from: "2024-07-25T00:00:00")!,
            amount: 40,
            note: "repayment",
            emoji: "💶",
            context: context
        )
        let receivable = DataFactory.createReceivable(
            name: name1,
            debtor: person1,
            transactions: [receivable1FirstTransaction,receivable1SecondTransaction],
            context: context
        )
        let assetPool = DataFactory.createAssetPool(named: "Privat", possessions: [], receivables: [receivable], in: context)
        return (receivable,assetPool)
    }
    
    func createAndPersistTestObjects_updatePossessionsWithSameName_1(context: NSManagedObjectContext) -> (Possession,String) {
        let occupiedName = "Sparkasse Konto"
        let possession1 = DataFactory.createPossession(name: occupiedName, volatile: true, context: context)
        let possession2 = DataFactory.createPossession(name: "Commerzbank Konto", volatile: true, context: context)
        let _ = DataFactory.createAssetPool(named: "Darlehen", possessions: [possession1,possession2], receivables: [], in: context)
        return (possession2,occupiedName)
    }
    
    func createAndPersistTestObjects_updatePossessionsWithSameName_2(context: NSManagedObjectContext) -> (Possession,String) {
        let occupiedName = "Rote Sonne"
        let person1 = DataFactory.createLoanPartner(name: "Philipp", context: context)
        let receivable1FirstTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-07-23T00:00:00")!,
            amount: 200,
            note: "disbursed amount",
            emoji: "📤",
            context: context
        )
        let receivable1SecondTransaction = DataFactory.createLoanTransaction(
            issuer: person1,
            date: DateParser.shared.date(from: "2024-07-25T00:00:00")!,
            amount: 40,
            note: "repayment",
            emoji: "💶",
            context: context
        )
        let receivable = DataFactory.createReceivable(
            name: occupiedName,
            debtor: person1,
            transactions: [receivable1FirstTransaction,receivable1SecondTransaction],
            context: context
        )
        let possession = DataFactory.createPossession(name: "Commerzbank Konto", volatile: true, context: context)
        let _ = DataFactory.createAssetPool(named: "Darlehen", possessions: [possession], receivables: [receivable], in: context)
        return (possession,occupiedName)
    }
    
    func createAndPersistTestObjects_updatePossessionsWithSameName_3(context: NSManagedObjectContext) -> Possession {
        let possession = DataFactory.createPossession(name: "Commerzbank Konto", volatile: true, context: context)
        let _ = DataFactory.createAssetPool(named: "Darlehen", possessions: [possession], receivables: [], in: context)
        return possession
    }
    
    func createAndPersistTestObjects_deletePossession_1(using context: NSManagedObjectContext) -> (Possession,[Possession]) {
        let asset1 = DataFactory.createPossession(name: "Geldbeutel", volatile: true, context: context)
        let asset2 = DataFactory.createPossession(name: "Konto Sparkasse", volatile: true, context: context)
        let asset3 = DataFactory.createPossession(name: "Konto Commerzbank", volatile: true, context: context)
        let asset4 = DataFactory.createPossession(name: "Depot FNZ", volatile: true, context: context)
        
        let expectedAssets = [asset2,asset3,asset4]
        return (asset1,expectedAssets)
    }
}

