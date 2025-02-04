@testable import EquityLab
import CoreData

struct SnapshotFormViewModelTestDataProvider {
    func createAndPersistTestObjects_poolNames_1(using context: NSManagedObjectContext) -> (Date,[String],[String],[PositionProxy],[PositionProxy]) {
        let person1 = DataFactory.createLoanPartner(name: "Lenni", context: context)
        let asset1FirstTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
            amount: 20,
            note: "disbursed amount",
            emoji: "📤",
            context: context
        )
        let asset1 = DataFactory.createReceivable(
            name: "Blitz",
            debtor: person1,
            transactions: [asset1FirstTransaction],
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
        
        let person2 = DataFactory.createLoanPartner(name: "Papa", context: context)
        let liability1FirstTransaction = DataFactory.createLoanTransaction(
            issuer: person2,
            date: DateParser.shared.date(from: "2023-03-15T00:00:00")!,
            amount: 1000,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liability1SecondTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2023-03-16T00:00:00")!,
            amount: 200,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liability1 = DataFactory.createLiability(
            name: "Auto",
            creditor: person2,
            transactions: [liability1FirstTransaction, liability1SecondTransaction],
            context: context
        )
        let liability2FirstTransaction = DataFactory.createLoanTransaction(
            issuer: person2,
            date: DateParser.shared.date(from: "2024-07-23T00:00:00")!,
            amount: 300,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liability2 = DataFactory.createLiability(
            name: "Booth",
            creditor: person2,
            transactions: [liability2FirstTransaction],
            context: context
        )
        let liability3FirstTransaction = DataFactory.createLoanTransaction(
            issuer: person2,
            date: DateParser.shared.date(from: "2024-07-23T00:00:00")!,
            amount: 5000,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liability3SecondTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-07-25T00:00:00")!,
            amount: 1022.41,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liability3 = DataFactory.createLiability(
            name: "Studium",
            creditor: person2,
            transactions: [liability3FirstTransaction, liability3SecondTransaction],
            context: context
        )
        
        
        let liabilityPoolName1 = "Privat"
        let liabilityPoolName2 = "Staatlich"
        let _ = DataFactory.createLiabilityPool(named: liabilityPoolName1, liabilities: [liability1, liability2], in: context)
        let _ = DataFactory.createLiabilityPool(named: liabilityPoolName2, liabilities: [liability3], in: context)
        
        let assetProxy1 = PositionProxy(name: "Blitz", value: 20.0, pool: assetPoolName4)
        let assetProxy2 = PositionProxy(name: "Geldbeutel", value: 0.0, pool: assetPoolName1)
        let assetProxy3 = PositionProxy(name: "Konto Sparkasse", value: 0.0, pool: assetPoolName2)
        let assetProxy4 = PositionProxy(name: "Konto Commerzbank", value: 0.0, pool: assetPoolName2)
        let assetProxy5 = PositionProxy(name: "Depot FNZ", value: 0.0, pool: assetPoolName3)
        
        let liabilityProxy1 = PositionProxy(name: "Auto", value: 800.0, pool: liabilityPoolName1)
        let liabilityProxy2 = PositionProxy(name: "Booth", value: 300.0, pool: liabilityPoolName1)
        let liabilityProxy3 = PositionProxy(name: "Studium", value: 3977.59, pool: liabilityPoolName2)
        
        let expectedDate = Date.now.startOfDay
        let expectedAssetPoolNames = [assetPoolName1,assetPoolName2,assetPoolName3,assetPoolName4]
        let expectedLiabilityPoolNames = [liabilityPoolName1,liabilityPoolName2]
        let expectedAssetProxies = [assetProxy1,assetProxy2,assetProxy3,assetProxy4,assetProxy5]
        let expectedLiabilityProxies = [liabilityProxy1,liabilityProxy2,liabilityProxy3]
        return (expectedDate,expectedAssetPoolNames,expectedLiabilityPoolNames,expectedAssetProxies,expectedLiabilityProxies)
    }
    
    func createAndPersistTestObjects_poolNames_2(using context: NSManagedObjectContext) -> (Date,[String],[String],[PositionProxy],[PositionProxy]) {
        let person1 = DataFactory.createLoanPartner(name: "Lenni", context: context)
        let asset1FirstTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
            amount: 20,
            note: "disbursed amount",
            emoji: "📤",
            context: context
        )
        let asset1 = DataFactory.createReceivable(
            name: "Blitz",
            debtor: person1,
            transactions: [asset1FirstTransaction],
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
        
        let person2 = DataFactory.createLoanPartner(name: "Papa", context: context)
        let liability1FirstTransaction = DataFactory.createLoanTransaction(
            issuer: person2,
            date: DateParser.shared.date(from: "2023-03-15T00:00:00")!,
            amount: 1000,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liability1SecondTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2023-03-16T00:00:00")!,
            amount: 200,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liability1 = DataFactory.createLiability(
            name: "Auto",
            creditor: person2,
            transactions: [liability1FirstTransaction, liability1SecondTransaction],
            context: context
        )
        let liability2FirstTransaction = DataFactory.createLoanTransaction(
            issuer: person2,
            date: DateParser.shared.date(from: "2024-07-23T00:00:00")!,
            amount: 300,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liability2 = DataFactory.createLiability(
            name: "Booth",
            creditor: person2,
            transactions: [liability2FirstTransaction],
            context: context
        )
        let liability3FirstTransaction = DataFactory.createLoanTransaction(
            issuer: person2,
            date: DateParser.shared.date(from: "2024-07-23T00:00:00")!,
            amount: 5000,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liability3SecondTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-07-25T00:00:00")!,
            amount: 1022.41,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liability3 = DataFactory.createLiability(
            name: "Studium",
            creditor: person2,
            transactions: [liability3FirstTransaction, liability3SecondTransaction],
            context: context
        )
        
        let liabilityPoolName1 = "Privat"
        let liabilityPoolName2 = "Staatlich"
        let _ = DataFactory.createLiabilityPool(named: liabilityPoolName1, liabilities: [liability1, liability2], in: context)
        let liabilityPool2 = DataFactory.createLiabilityPool(named: liabilityPoolName2, liabilities: [liability3], in: context)
        
        let _ = PositionProxy(name: "Blitz", value: 20.0, pool: assetPoolName4)
        let assetProxy2 = PositionProxy(name: "Geldbeutel", value: 0.0, pool: assetPoolName1)
        let assetProxy3 = PositionProxy(name: "Konto Sparkasse", value: 0.0, pool: assetPoolName2)
        let _ = PositionProxy(name: "Konto Commerzbank", value: 0.0, pool: assetPoolName2)
        let assetProxy5 = PositionProxy(name: "Depot FNZ", value: 0.0, pool: assetPoolName3)
        
        let _ = PositionProxy(name: "Auto", value: 800.0, pool: liabilityPoolName1)
        let liabilityProxy2 = PositionProxy(name: "Booth", value: 300.0, pool: liabilityPoolName1)
        let _ = PositionProxy(name: "Studium", value: 3977.59, pool: liabilityPoolName2)
        
        context.delete(assetPool4)
        context.delete(asset4)
        context.delete(liabilityPool2)
        context.delete(liability1)
        try? context.save()
        
        let expectedDate = Date.now.startOfDay
        let expectedAssetPoolNames = [assetPoolName1,assetPoolName2,assetPoolName3]
        let expectedLiabilityPoolNames = [liabilityPoolName1]
        let expectedAssetProxies = [assetProxy2,assetProxy3,assetProxy5]
        let expectedLiabilityProxies = [liabilityProxy2]
        return (expectedDate,expectedAssetPoolNames,expectedLiabilityPoolNames,expectedAssetProxies,expectedLiabilityProxies)
    }
    
    func createAndPersistTestObjects_poolNames_3(using context: NSManagedObjectContext) -> (Snapshot,Date,[String],[String],[PositionProxy],[PositionProxy]) {
        let sparkasse = DataFactory.createAssetPosition(name: "Sparkasse Konto", poolName: "Bank", value: 200.0, context: context)
        let commerzbank = DataFactory.createAssetPosition(name: "Commerzbank Konto", poolName: "Bank", value: 330, context: context)
        let reifeisenbank = DataFactory.createAssetPosition(name: "Reifeisenbank Konto", poolName: "Bank", value: 99.0, context: context)
        let FNZ = DataFactory.createAssetPosition(name: "FNZ", poolName: "Wertpapiere", value: 510.0, context: context)
        let sparschwein = DataFactory.createAssetPosition(name: "Sparschwein", poolName: "Bargeld", value: 23.0, context: context)
        let geldbeutel = DataFactory.createAssetPosition(name: "Geldbeutel", poolName: "Bargeld", value: 40.0, context: context)
        let assetPositions = [sparkasse,commerzbank,reifeisenbank,FNZ,sparschwein,geldbeutel]
        
        let auto1 = DataFactory.createLiabilityPosition(name: "Auto Papa", poolName: "Privat", value: 1000.0, context: context)
        let booth = DataFactory.createLiabilityPosition(name: "Booth", poolName: "Privat", value: 200.0, context: context)
        let fahrrad = DataFactory.createLiabilityPosition(name: "Fahrrad", poolName: "Privat", value: 300.0, context: context)
        let studium = DataFactory.createLiabilityPosition(name: "Studium", poolName: "Staatlich", value: 5000.0, context: context)
        let kaution = DataFactory.createLiabilityPosition(name: "Kaution", poolName: "Bank", value: 1000.0, context: context)
        let auto2 = DataFactory.createLiabilityPosition(name: "Auto Bank", poolName: "Bank", value: 500.0, context: context)
        let liabilityPositions = [auto1,booth,fahrrad,studium,kaution,auto2]
        
        let assetProxy1 = PositionProxy(name: "Sparkasse Konto", value: 200.0, pool: "Bank")
        let assetProxy2 = PositionProxy(name: "Commerzbank Konto", value: 330.0, pool: "Bank")
        let assetProxy3 = PositionProxy(name: "Reifeisenbank Konto", value: 99.0, pool: "Bank")
        let assetProxy4 = PositionProxy(name: "FNZ", value: 510.0, pool: "Wertpapiere")
        let assetProxy5 = PositionProxy(name: "Sparschwein", value: 23.0, pool: "Bargeld")
        let assetProxy6 = PositionProxy(name: "Geldbeutel", value: 40.0, pool: "Bargeld")
        
        let liabilityProxy1 = PositionProxy(name: "Auto Papa", value: 1000.0, pool: "Privat")
        let liabilityProxy2 = PositionProxy(name: "Booth", value: 200.0, pool: "Privat")
        let liabilityProxy3 = PositionProxy(name: "Fahrrad", value: 300.0, pool: "Privat")
        let liabilityProxy4 = PositionProxy(name: "Studium", value: 5000.0, pool: "Staatlich")
        let liabilityProxy5 = PositionProxy(name: "Kaution", value: 1000.0, pool: "Bank")
        let liabilityProxy6 = PositionProxy(name: "Auto Bank", value: 500.0, pool: "Bank")
        
        let snapshot = DataFactory.createSnapshot(with: assetPositions, and: liabilityPositions, for: .now.startOfDay, in: context)
        let expectedDate = Date.now.startOfDay
        let expectedAssetPoolNames = ["Bank","Wertpapiere","Bargeld"]
        let expectedLiabilityPoolNames = ["Privat","Staatlich","Bank"]
        let expectedAssetProxies = [assetProxy1,assetProxy2,assetProxy3,assetProxy4,assetProxy5,assetProxy6]
        let expectedLiabilityProxies = [liabilityProxy1,liabilityProxy2,liabilityProxy3,liabilityProxy4,liabilityProxy5,liabilityProxy6]
        return (snapshot,expectedDate,expectedAssetPoolNames,expectedLiabilityPoolNames,expectedAssetProxies,expectedLiabilityProxies)
    }
    
    func createAndPersistTestObjects_getProxies_1(using context: NSManagedObjectContext) -> ([String:[PositionProxy]],[String:[PositionProxy]]) {
        let person1 = DataFactory.createLoanPartner(name: "Lenni", context: context)
        let asset1FirstTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-04-15T00:00:00")!,
            amount: 20,
            note: "disbursed amount",
            emoji: "📤",
            context: context
        )
        let asset1 = DataFactory.createReceivable(
            name: "Blitz",
            debtor: person1,
            transactions: [asset1FirstTransaction],
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
        
        let person2 = DataFactory.createLoanPartner(name: "Papa", context: context)
        let liability1FirstTransaction = DataFactory.createLoanTransaction(
            issuer: person2,
            date: DateParser.shared.date(from: "2023-03-15T00:00:00")!,
            amount: 1000,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liability1SecondTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2023-03-16T00:00:00")!,
            amount: 200,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liability1 = DataFactory.createLiability(
            name: "Auto",
            creditor: person2,
            transactions: [liability1FirstTransaction, liability1SecondTransaction],
            context: context
        )
        let liability2FirstTransaction = DataFactory.createLoanTransaction(
            issuer: person2,
            date: DateParser.shared.date(from: "2024-07-23T00:00:00")!,
            amount: 300,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liability2 = DataFactory.createLiability(
            name: "Booth",
            creditor: person2,
            transactions: [liability2FirstTransaction],
            context: context
        )
        let liability3FirstTransaction = DataFactory.createLoanTransaction(
            issuer: person2,
            date: DateParser.shared.date(from: "2024-07-23T00:00:00")!,
            amount: 5000,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liability3SecondTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-07-25T00:00:00")!,
            amount: 1022.41,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liability3 = DataFactory.createLiability(
            name: "Studium",
            creditor: person2,
            transactions: [liability3FirstTransaction, liability3SecondTransaction],
            context: context
        )
        
        let liabilityPoolName1 = "Privat"
        let liabilityPoolName2 = "Staatlich"
        let _ = DataFactory.createLiabilityPool(named: liabilityPoolName1, liabilities: [liability1, liability2], in: context)
        let _ = DataFactory.createLiabilityPool(named: liabilityPoolName2, liabilities: [liability3], in: context)
        
        let assetProxy1 = PositionProxy(name: "Blitz", value: 20.0, pool: assetPoolName4)
        let assetProxy2 = PositionProxy(name: "Geldbeutel", value: 0.0, pool: assetPoolName1)
        let assetProxy3 = PositionProxy(name: "Konto Sparkasse", value: 0.0, pool: assetPoolName2)
        let assetProxy4 = PositionProxy(name: "Konto Commerzbank", value: 0.0, pool: assetPoolName2)
        let assetProxy5 = PositionProxy(name: "Depot FNZ", value: 0.0, pool: assetPoolName3)
        
        let liabilityProxy1 = PositionProxy(name: "Auto", value: 800.0, pool: liabilityPoolName1)
        let liabilityProxy2 = PositionProxy(name: "Booth", value: 300.0, pool: liabilityPoolName1)
        let liabilityProxy3 = PositionProxy(name: "Studium", value: 3977.59, pool: liabilityPoolName2)
        
        var poolNameToAssetProxyDictionary = [String:[PositionProxy]]()
        poolNameToAssetProxyDictionary["Bargeld"] = [assetProxy2]
        poolNameToAssetProxyDictionary["Bank"] = [assetProxy3,assetProxy4]
        poolNameToAssetProxyDictionary["Wertpapiere"] = [assetProxy5]
        poolNameToAssetProxyDictionary["Geliehen"] = [assetProxy1]
        
        var poolNameToLiabilityProxyDictionary = [String:[PositionProxy]]()
        poolNameToLiabilityProxyDictionary["Privat"] = [liabilityProxy1,liabilityProxy2]
        poolNameToLiabilityProxyDictionary["Staatlich"] = [liabilityProxy3]
        
        return (poolNameToAssetProxyDictionary,poolNameToLiabilityProxyDictionary)
    }
    
    func createAndPersistTestObjects_getProxies_2(using context: NSManagedObjectContext) -> (Snapshot,[String:[PositionProxy]],[String:[PositionProxy]]) {
        let sparkasse = DataFactory.createAssetPosition(name: "Sparkasse Konto", poolName: "Bank", value: 200.0, context: context)
        let commerzbank = DataFactory.createAssetPosition(name: "Commerzbank Konto", poolName: "Bank", value: 330, context: context)
        let reifeisenbank = DataFactory.createAssetPosition(name: "Reifeisenbank Konto", poolName: "Bank", value: 99.0, context: context)
        let FNZ = DataFactory.createAssetPosition(name: "FNZ", poolName: "Wertpapiere", value: 510.0, context: context)
        let sparschwein = DataFactory.createAssetPosition(name: "Sparschwein", poolName: "Bargeld", value: 23.0, context: context)
        let geldbeutel = DataFactory.createAssetPosition(name: "Geldbeutel", poolName: "Bargeld", value: 40.0, context: context)
        let assetPositions = [sparkasse,commerzbank,reifeisenbank,FNZ,sparschwein,geldbeutel]
        
        let auto1 = DataFactory.createLiabilityPosition(name: "Auto Papa", poolName: "Privat", value: 1000.0, context: context)
        let booth = DataFactory.createLiabilityPosition(name: "Booth", poolName: "Privat", value: 200.0, context: context)
        let fahrrad = DataFactory.createLiabilityPosition(name: "Fahrrad", poolName: "Privat", value: 300.0, context: context)
        let studium = DataFactory.createLiabilityPosition(name: "Studium", poolName: "Staatlich", value: 5000.0, context: context)
        let kaution = DataFactory.createLiabilityPosition(name: "Kaution", poolName: "Bank", value: 1000.0, context: context)
        let auto2 = DataFactory.createLiabilityPosition(name: "Auto Bank", poolName: "Bank", value: 500.0, context: context)
        let liabilityPositions = [auto1,booth,fahrrad,studium,kaution,auto2]
        
        let assetProxy1 = PositionProxy(name: "Sparkasse Konto", value: 200.0, pool: "Bank")
        let assetProxy2 = PositionProxy(name: "Commerzbank Konto", value: 330.0, pool: "Bank")
        let assetProxy3 = PositionProxy(name: "Reifeisenbank Konto", value: 99.0, pool: "Bank")
        let assetProxy4 = PositionProxy(name: "FNZ", value: 510.0, pool: "Wertpapiere")
        let assetProxy5 = PositionProxy(name: "Sparschwein", value: 23.0, pool: "Bargeld")
        let assetProxy6 = PositionProxy(name: "Geldbeutel", value: 40.0, pool: "Bargeld")
        
        let liabilityProxy1 = PositionProxy(name: "Auto Papa", value: 1000.0, pool: "Privat")
        let liabilityProxy2 = PositionProxy(name: "Booth", value: 200.0, pool: "Privat")
        let liabilityProxy3 = PositionProxy(name: "Fahrrad", value: 300.0, pool: "Privat")
        let liabilityProxy4 = PositionProxy(name: "Studium", value: 5000.0, pool: "Staatlich")
        let liabilityProxy5 = PositionProxy(name: "Kaution", value: 1000.0, pool: "Bank")
        let liabilityProxy6 = PositionProxy(name: "Auto Bank", value: 500.0, pool: "Bank")
        
        let snapshot = DataFactory.createSnapshot(with: assetPositions, and: liabilityPositions, for: .now.startOfDay, in: context)
        
        var poolNameToAssetProxyDictionary = [String:[PositionProxy]]()
        poolNameToAssetProxyDictionary["Bargeld"] = [assetProxy5,assetProxy6]
        poolNameToAssetProxyDictionary["Bank"] = [assetProxy1,assetProxy2,assetProxy3]
        poolNameToAssetProxyDictionary["Wertpapiere"] = [assetProxy4]
        
        var poolNameToLiabilityProxyDictionary = [String:[PositionProxy]]()
        poolNameToLiabilityProxyDictionary["Privat"] = [liabilityProxy1,liabilityProxy2,liabilityProxy3]
        poolNameToLiabilityProxyDictionary["Staatlich"] = [liabilityProxy4]
        poolNameToLiabilityProxyDictionary["Bank"] = [liabilityProxy5,liabilityProxy6]
        
        return (snapshot,poolNameToAssetProxyDictionary,poolNameToLiabilityProxyDictionary)
    }
    
    func createAndPersistTestObjects_saveSnapshot_1(using context: NSManagedObjectContext) {
        let asset1 = DataFactory.createPossession(name: "Geldbeutel", volatile: true, context: context)
        let asset2 = DataFactory.createPossession(name: "Konto Sparkasse", volatile: true, context: context)
        let asset3 = DataFactory.createPossession(name: "Konto Commerzbank", volatile: true, context: context)
        
        let assetPoolName1 = "Bargeld"
        let assetPoolName2 = "Bank"
        let _ = DataFactory.createAssetPool(named: assetPoolName1, possessions: [asset1], receivables: [], in: context)
        let _ = DataFactory.createAssetPool(named: assetPoolName2, possessions: [asset2,asset3], receivables: [], in: context)
        
        let person2 = DataFactory.createLoanPartner(name: "Papa", context: context)
        let liability1FirstTransaction = DataFactory.createLoanTransaction(
            issuer: person2,
            date: DateParser.shared.date(from: "2023-03-15T00:00:00")!,
            amount: 1000,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liability1SecondTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2023-03-16T00:00:00")!,
            amount: 200,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liability1 = DataFactory.createLiability(
            name: "Auto",
            creditor: person2,
            transactions: [liability1FirstTransaction, liability1SecondTransaction],
            context: context
        )
        let liability2FirstTransaction = DataFactory.createLoanTransaction(
            issuer: person2,
            date: DateParser.shared.date(from: "2024-07-23T00:00:00")!,
            amount: 5000,
            note: "disbursed amount",
            emoji: "💶",
            context: context
        )
        let liability2SecondTransaction = DataFactory.createLoanTransaction(
            date: DateParser.shared.date(from: "2024-07-25T00:00:00")!,
            amount: 1022.41,
            note: "repayment",
            emoji: "🔁",
            context: context
        )
        let liability2 = DataFactory.createLiability(
            name: "Studium",
            creditor: person2,
            transactions: [liability2FirstTransaction, liability2SecondTransaction],
            context: context
        )
    
        let liabilityPoolName1 = "Privat"
        let liabilityPoolName2 = "Staatlich"
        let _ = DataFactory.createLiabilityPool(named: liabilityPoolName1, liabilities: [liability1], in: context)
        let _ = DataFactory.createLiabilityPool(named: liabilityPoolName2, liabilities: [liability2], in: context)
    }
    
    func createAndPersistTestObjects_saveSnapshot_2(using context: NSManagedObjectContext) -> Snapshot {
        let sparkasse = DataFactory.createAssetPosition(name: "Konto Sparkasse", poolName: "Bank", value: 0.0, context: context)
        let commerzbank = DataFactory.createAssetPosition(name: "Konto Commerzbank", poolName: "Bank", value: 0.0, context: context)
        let FNZ = DataFactory.createAssetPosition(name: "FNZ", poolName: "Wertpapiere", value: 0.0, context: context)
        let geldbeutel = DataFactory.createAssetPosition(name: "Geldbeutel", poolName: "Bargeld", value: 0.0, context: context)
        let assetPositions = [sparkasse,commerzbank,FNZ,geldbeutel]
        
        let auto = DataFactory.createLiabilityPosition(name: "Auto Papa", poolName: "Privat", value: 1000.0, context: context)
        let booth = DataFactory.createLiabilityPosition(name: "Booth", poolName: "Privat", value: 200.0, context: context)
        let studium = DataFactory.createLiabilityPosition(name: "Studium", poolName: "Staatlich", value: 5000.0, context: context)
        let kaution = DataFactory.createLiabilityPosition(name: "Kaution", poolName: "Bank", value: 1000.0, context: context)
        let liabilityPositions = [auto,booth,studium,kaution]
        
        let date = DateParser.shared.date(from: "2024-04-15T00:00:00")!
        
        return DataFactory.createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
    }
    
    func createAndPersistTestObjects_saveSnapshot_3(using context: NSManagedObjectContext) -> Date {
        let sparkasse = DataFactory.createAssetPosition(name: "Konto Sparkasse", poolName: "Bank", value: 0.0, context: context)
        let commerzbank = DataFactory.createAssetPosition(name: "Konto Commerzbank", poolName: "Bank", value: 0.0, context: context)
        let FNZ = DataFactory.createAssetPosition(name: "FNZ", poolName: "Wertpapiere", value: 0.0, context: context)
        let geldbeutel = DataFactory.createAssetPosition(name: "Geldbeutel", poolName: "Bargeld", value: 0.0, context: context)
        let assetPositions = [sparkasse,commerzbank,FNZ,geldbeutel]
        
        let auto = DataFactory.createLiabilityPosition(name: "Auto Papa", poolName: "Privat", value: 1000.0, context: context)
        let booth = DataFactory.createLiabilityPosition(name: "Booth", poolName: "Privat", value: 200.0, context: context)
        let studium = DataFactory.createLiabilityPosition(name: "Studium", poolName: "Staatlich", value: 5000.0, context: context)
        let kaution = DataFactory.createLiabilityPosition(name: "Kaution", poolName: "Bank", value: 1000.0, context: context)
        let liabilityPositions = [auto,booth,studium,kaution]
        
        let date = DateParser.shared.date(from: "2024-04-15T00:00:00")!
        
        DataFactory.createSnapshot(with: assetPositions, and: liabilityPositions, for: date, in: context)
        
        return date
    }
    
    func createAndPersistTestObjects_saveSnapshot_4(using context: NSManagedObjectContext) -> (Snapshot, Date) {
        let sparkasse = DataFactory.createAssetPosition(name: "Konto Sparkasse", poolName: "Bank", value: 0.0, context: context)
        let commerzbank = DataFactory.createAssetPosition(name: "Konto Commerzbank", poolName: "Bank", value: 0.0, context: context)
        let assetPositions1 = [sparkasse,commerzbank]
        
        let FNZ = DataFactory.createAssetPosition(name: "FNZ", poolName: "Wertpapiere", value: 0.0, context: context)
        let geldbeutel = DataFactory.createAssetPosition(name: "Geldbeutel", poolName: "Bargeld", value: 0.0, context: context)
        let assetPositions2 = [FNZ,geldbeutel]
        
        let auto = DataFactory.createLiabilityPosition(name: "Auto Papa", poolName: "Privat", value: 1000.0, context: context)
        let booth = DataFactory.createLiabilityPosition(name: "Booth", poolName: "Privat", value: 200.0, context: context)
        let liabilityPositions1 = [auto,booth]
        
        let studium = DataFactory.createLiabilityPosition(name: "Studium", poolName: "Staatlich", value: 5000.0, context: context)
        let kaution = DataFactory.createLiabilityPosition(name: "Kaution", poolName: "Bank", value: 1000.0, context: context)
        let liabilityPositions2 = [studium,kaution]
        
        let date1 = DateParser.shared.date(from: "2024-04-15T00:00:00")!
        let date2 = DateParser.shared.date(from: "2024-04-14T00:00:00")!
        
        let _ = DataFactory.createSnapshot(with: assetPositions1, and: liabilityPositions1, for: date1, in: context)
        return (DataFactory.createSnapshot(with: assetPositions2, and: liabilityPositions2, for: date2, in: context), date1)
    }
}

