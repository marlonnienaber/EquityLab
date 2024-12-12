@testable import EquityLab
import CoreData

struct DistributionChartViewModelTestDataProvider {
    func createAndPersistTestObjects_distributionCategories_1(using context: NSManagedObjectContext) -> ([DonutChartCategory],[DonutChartCategory]) {
        let assetPosition1 = DataFactory.createAssetPosition(name: "Sparkasse Konto", poolName: "Bank", value: 20.0, context: context)
        let assetPosition2 = DataFactory.createAssetPosition(name: "FNZ Depot", poolName: "Wertpapiere", value: 30.0, context: context)
        let assetPosition3 = DataFactory.createAssetPosition(name: "Geldbeutel", poolName: "Bargeld", value: 50.0, context: context)
        
        let liabilityPosition1 = DataFactory.createLiabilityPosition(name: "Auto-Kredit", poolName: "Privat", value: 40, context: context)
        let liabilityPosition2 = DataFactory.createLiabilityPosition(name: "Studien-Kredit", poolName: "Staat", value: 60, context: context)
        
        let _ = DataFactory.createSnapshot(with: [assetPosition1, assetPosition2, assetPosition3],
                               and: [liabilityPosition1, liabilityPosition2],
                               for: .now,
                               in: context)
        
        let assetCategory1 = DonutChartCategory(pools: [Pool(value: 20.0, name: "Bank", percentage: 20.0)])
        let assetCategory2 = DonutChartCategory(pools: [Pool(value: 30.0, name: "Wertpapiere", percentage: 30.0)])
        let assetCategory3 = DonutChartCategory(pools: [Pool(value: 50.0, name: "Bargeld", percentage: 50.0)])
        
        let liabilityCategory1 = DonutChartCategory(pools: [Pool(value: 40.0, name: "Privat", percentage: 40.0)])
        let liabilityCategory2 = DonutChartCategory(pools: [Pool(value: 60.0, name: "Staat", percentage: 60.0)])
        
        return ([assetCategory1, assetCategory2, assetCategory3], [liabilityCategory1,liabilityCategory2])
    }
    
    func createAndPersistTestObjects_distributionCategories_2(using context: NSManagedObjectContext) -> ([DonutChartCategory],[DonutChartCategory]) {
        let assetPosition1 = DataFactory.createAssetPosition(name: "Sparkasse Girokonto", poolName: "Bank", value: 10.0, context: context)
        let assetPosition2 = DataFactory.createAssetPosition(name: "Sparkasse Tagesgeldkonto", poolName: "Bank", value: 25.0, context: context)
        let assetPosition3 = DataFactory.createAssetPosition(name: "Commerzbank Konto", poolName: "Bank", value: 5.0, context: context)
        let assetPosition4 = DataFactory.createAssetPosition(name: "FNZ Depot", poolName: "Wertpapiere", value: 1.0, context: context)
        let assetPosition5 = DataFactory.createAssetPosition(name: "Sparkasse Depot", poolName: "Wertpapiere", value: 2.0, context: context)
        let assetPosition6 = DataFactory.createAssetPosition(name: "Geldbeutel", poolName: "Bargeld", value: 57.0, context: context)
        
        let liabilityPosition1 = DataFactory.createLiabilityPosition(name: "Auto-Kredit", poolName: "Privat", value: 40, context: context)
        let liabilityPosition2 = DataFactory.createLiabilityPosition(name: "Miete-Kredit", poolName: "Privat", value: 40, context: context)
        let liabilityPosition3 = DataFactory.createLiabilityPosition(name: "Plattenspieler-Kredit", poolName: "Privat", value: 17, context: context)
        let liabilityPosition4 = DataFactory.createLiabilityPosition(name: "Studien-Kredit", poolName: "Staat", value: 3.0, context: context)
        
        let _ = DataFactory.createSnapshot(with: [assetPosition1, assetPosition2, assetPosition3, assetPosition4, assetPosition5, assetPosition6],
                               and: [liabilityPosition1, liabilityPosition2, liabilityPosition3, liabilityPosition4],
                               for: .now,
                               in: context)
        
        let assetCategory1 = DonutChartCategory(pools: [Pool(value: 40.0, name: "Bank", percentage: 40.0)])
        let assetCategory2 = DonutChartCategory(pools: [Pool(value: 3.0, name: "Wertpapiere", percentage: 3.0)])
        let assetCategory3 = DonutChartCategory(pools: [Pool(value: 57.0, name: "Bargeld", percentage: 57.0)])
        
        let liabilityCategory1 = DonutChartCategory(pools: [Pool(value: 97.0, name: "Privat", percentage: 97.0)])
        let liabilityCategory2 = DonutChartCategory(pools: [Pool(value: 3.0, name: "Staat", percentage: 3.0)])
        
        return ([assetCategory1, assetCategory2, assetCategory3], [liabilityCategory1,liabilityCategory2])
    }
    
    func createAndPersistTestObjects_distributionCategories_3(using context: NSManagedObjectContext) -> ([DonutChartCategory],[DonutChartCategory]) {
        let assetPosition1 = DataFactory.createAssetPosition(name: "Sparkasse Girokonto", poolName: "Bank", value: 10.0, context: context)
        let assetPosition2 = DataFactory.createAssetPosition(name: "Sparkasse Tagesgeldkonto", poolName: "Bank", value: 25.0, context: context)
        let assetPosition3 = DataFactory.createAssetPosition(name: "Commerzbank Konto", poolName: "Bank", value: 35.0, context: context)
        let assetPosition4 = DataFactory.createAssetPosition(name: "FNZ Depot", poolName: "Wertpapiere", value: 16.0, context: context)
        let assetPosition5 = DataFactory.createAssetPosition(name: "Sparkasse Depot", poolName: "Wertpapiere", value: 12.0, context: context)
        let assetPosition6 = DataFactory.createAssetPosition(name: "Geldbeutel", poolName: "Bargeld", value: 1.0, context: context)
        let assetPosition7 = DataFactory.createAssetPosition(name: "Sparschwein", poolName: "Bargeld", value: 1.0, context: context)
        
        let liabilityPosition1 = DataFactory.createLiabilityPosition(name: "Auto-Kredit", poolName: "Privat", value: 40, context: context)
        let liabilityPosition2 = DataFactory.createLiabilityPosition(name: "Miete-Kredit", poolName: "Privat", value: 40, context: context)
        let liabilityPosition3 = DataFactory.createLiabilityPosition(name: "Plattenspieler-Kredit", poolName: "Privat", value: 18, context: context)
        let liabilityPosition4 = DataFactory.createLiabilityPosition(name: "Studien-Kredit", poolName: "Staat", value: 2.0, context: context)
        
        let _ = DataFactory.createSnapshot(with: [assetPosition1, assetPosition2, assetPosition3, assetPosition4, assetPosition5, assetPosition6, assetPosition7],
                               and: [liabilityPosition1, liabilityPosition2, liabilityPosition3, liabilityPosition4],
                               for: .now,
                               in: context)
        
        let assetCategory1 = DonutChartCategory(pools: [Pool(value: 70.0, name: "Bank", percentage: 70.0)])
        let assetCategory2 = DonutChartCategory(pools: [
            Pool(value: 28.0, name: "Wertpapiere", percentage: 28.0),
            Pool(value: 2.0, name: "Bargeld", percentage: 2.0)
        ])
        
        let liabilityCategory1 = DonutChartCategory(pools: [
            Pool(value: 98.0, name: "Privat", percentage: 98.0),
            Pool(value: 2.0, name: "Staat", percentage: 2.0)
        ])
        
        return ([assetCategory1, assetCategory2], [liabilityCategory1])
    }
    
    func createAndPersistTestObjects_distributionCategories_4(using context: NSManagedObjectContext) -> ([DonutChartCategory],[DonutChartCategory]) {
        let assetPosition1 = DataFactory.createAssetPosition(name: "Sparkasse Girokonto", poolName: "Bank Inland", value: 10.0, context: context)
        let assetPosition2 = DataFactory.createAssetPosition(name: "Sparkasse Tagesgeldkonto", poolName: "Bank Inland", value: 25.0, context: context)
        let assetPosition3 = DataFactory.createAssetPosition(name: "Commerzbank Konto", poolName: "Bank Inland", value: 35.0, context: context)
        let assetPosition4 = DataFactory.createAssetPosition(name: "FNZ Depot", poolName: "Wertpapiere", value: 16.0, context: context)
        let assetPosition5 = DataFactory.createAssetPosition(name: "Sparkasse Depot", poolName: "Wertpapiere", value: 12.0, context: context)
        let assetPosition6 = DataFactory.createAssetPosition(name: "Geldbeutel", poolName: "Bargeld", value: 1.0, context: context)
        let assetPosition7 = DataFactory.createAssetPosition(name: "Sparschwein", poolName: "Bargeld", value: 0.5, context: context)
        let assetPosition8 = DataFactory.createAssetPosition(name: "Bank of America Konto", poolName: "Bank Ausland", value: 0.5, context: context)
        
        let liabilityPosition1 = DataFactory.createLiabilityPosition(name: "Auto-Kredit", poolName: "Familie", value: 40, context: context)
        let liabilityPosition2 = DataFactory.createLiabilityPosition(name: "Miete-Kredit", poolName: "Familie", value: 40, context: context)
        let liabilityPosition3 = DataFactory.createLiabilityPosition(name: "Plattenspieler-Kredit", poolName: "Familie", value: 18, context: context)
        let liabilityPosition4 = DataFactory.createLiabilityPosition(name: "Studien-Kredit", poolName: "Staat", value: 1.0, context: context)
        let liabilityPosition5 = DataFactory.createLiabilityPosition(name: "Feiern Lenni", poolName: "Freunde", value: 1.0, context: context)
        
        let _ = DataFactory.createSnapshot(with: [assetPosition1, assetPosition2, assetPosition3, assetPosition4, assetPosition5, assetPosition6, assetPosition7, assetPosition8],
                               and: [liabilityPosition1, liabilityPosition2, liabilityPosition3, liabilityPosition4, liabilityPosition5],
                               for: .now,
                               in: context)
        
        let assetCategory1 = DonutChartCategory(pools: [Pool(value: 70.0, name: "Bank Inland", percentage: 70.0)])
        let assetCategory2 = DonutChartCategory(pools: [
            Pool(value: 28.0, name: "Wertpapiere", percentage: 28.0),
            Pool(value: 1.5, name: "Bargeld", percentage: 1.5),
            Pool(value: 0.5, name: "Bank Ausland", percentage: 0.5)
        ])
        
        let liabilityCategory1 = DonutChartCategory(pools: [
            Pool(value: 98.0, name: "Familie", percentage: 98.0),
            Pool(value: 1.0, name: "Staat", percentage: 1.0),
            Pool(value: 1.0, name: "Freunde", percentage: 1.0)
        ])
        
        return ([assetCategory1, assetCategory2], [liabilityCategory1])
    }
    
    func createAndPersistTestObjects_distributionCategories_5(using context: NSManagedObjectContext) -> ([DonutChartCategory],[DonutChartCategory]) {
        let _ = DataFactory.createSnapshotWithoutPositions(for: .now, in: context)
        return ([], [])
    }
    
    
    func createAndPersistTestObjects_computeTotalValue_1(using context: NSManagedObjectContext) -> (Snapshot, Decimal, Decimal) {
        let assetPosition1 = DataFactory.createAssetPosition(name: "Sparkasse Konto", poolName: "Bank", value: 1_000_000.0, context: context)
        let liabilityPosition1 = DataFactory.createLiabilityPosition(name: "Auto-Kredit", poolName: "Privat", value: 1_000_000_000.0, context: context)
        
        let snapshot = DataFactory.createSnapshot(with: [assetPosition1],
                               and: [liabilityPosition1],
                               for: .now,
                               in: context)
        
        return (snapshot, 1_000_000.0, 1_000_000_000.0)
    }
    
    func createAndPersistTestObjects_computeTotalValue_2(using context: NSManagedObjectContext) -> (Snapshot, Decimal, Decimal) {
        let assetPosition1 = DataFactory.createAssetPosition(name: "Sparkasse Konto", poolName: "Bank", value: 1_000_000.0, context: context)
        let assetPosition2 = DataFactory.createAssetPosition(name: "Commerzbank Konto", poolName: "Bank", value: 10.0, context: context)
        let assetPosition3 = DataFactory.createAssetPosition(name: "Reifeisenbank Konto", poolName: "Bank", value: 30_000.0, context: context)
        let liabilityPosition1 = DataFactory.createLiabilityPosition(name: "Auto", poolName: "Privat", value: 1_000_000_000.0, context: context)
        let liabilityPosition2 = DataFactory.createLiabilityPosition(name: "Wohnung 1", poolName: "Privat", value: 1_000_000.0, context: context)
        let liabilityPosition3 = DataFactory.createLiabilityPosition(name: "Wohnung 2", poolName: "Privat", value: 55.0, context: context)
        let liabilityPosition4 = DataFactory.createLiabilityPosition(name: "Motorrad", poolName: "Privat", value: 340_000.0, context: context)
        let liabilityPosition5 = DataFactory.createLiabilityPosition(name: "Vinylsammlung", poolName: "Privat", value: 1.0, context: context)
        
        let snapshot = DataFactory.createSnapshot(with: [assetPosition1, assetPosition2, assetPosition3],
                               and: [liabilityPosition1, liabilityPosition2, liabilityPosition3, liabilityPosition4, liabilityPosition5],
                               for: .now,
                               in: context)
        
        return (snapshot, 1_030_010.0, 1_001_340_056.0)
    }
    
    func createAndPersistTestObjects_computeTotalValue_3(using context: NSManagedObjectContext) -> (Snapshot, Decimal, Decimal) {
        let assetPosition1 = DataFactory.createAssetPosition(name: "Sparkasse Konto", poolName: "Bank Inland", value: 76.33, context: context)
        let assetPosition2 = DataFactory.createAssetPosition(name: "Commerzbank Konto", poolName: "Bank Inland", value: 2_672_654.80, context: context)
        let assetPosition3 = DataFactory.createAssetPosition(name: "Reifeisenbank Konto", poolName: "Bank Inland", value: 756_085.95, context: context)
        let assetPosition4 = DataFactory.createAssetPosition(name: "Bank of America", poolName: "Bank Ausland", value: 650.01, context: context)
        let assetPosition5 = DataFactory.createAssetPosition(name: "Blackrock", poolName: "Bank Ausland", value: 302_070.29, context: context)
        let assetPosition6 = DataFactory.createAssetPosition(name: "Geldbeutel", poolName: "Bargeld", value: 30.50, context: context)
        let assetPosition7 = DataFactory.createAssetPosition(name: "Sparschwein", poolName: "Bargeld", value: 301.22, context: context)
        let assetPosition8 = DataFactory.createAssetPosition(name: "Morgan Stanley", poolName: "Wertpapiere", value: 56_114.76, context: context)
        let liabilityPosition1 = DataFactory.createLiabilityPosition(name: "Auto", poolName: "Privat", value: 22.2, context: context)
        let liabilityPosition2 = DataFactory.createLiabilityPosition(name: "Wohnung 1", poolName: "Privat", value: 5_000.00, context: context)
        let liabilityPosition3 = DataFactory.createLiabilityPosition(name: "Vinylsammlung", poolName: "Privat", value: 300.0, context: context)
        let liabilityPosition4 = DataFactory.createLiabilityPosition(name: "Motorrad", poolName: "Privat", value: 4_000, context: context)
        let liabilityPosition5 = DataFactory.createLiabilityPosition(name: "Studium 1", poolName: "Bank", value: 2_000.0, context: context)
        let liabilityPosition6 = DataFactory.createLiabilityPosition(name: "Studium 2", poolName: "Bank", value: 6_000.0, context: context)
        let liabilityPosition7 = DataFactory.createLiabilityPosition(name: "Wohnung 2", poolName: "Bank", value: 10_000.0, context: context)
        let liabilityPosition8 = DataFactory.createLiabilityPosition(name: "Herd", poolName: "Online", value: 600.0, context: context)
        let liabilityPosition9 = DataFactory.createLiabilityPosition(name: "Spülmaschine", poolName: "Online", value: 551.0, context: context)
        
        let assetPositions = [
            assetPosition1,
            assetPosition2,
            assetPosition3,
            assetPosition4,
            assetPosition5,
            assetPosition6,
            assetPosition7,
            assetPosition8
        ]
        
        let liabilityPositions = [
            liabilityPosition1,
            liabilityPosition2,
            liabilityPosition3,
            liabilityPosition4,
            liabilityPosition5,
            liabilityPosition6,
            liabilityPosition7,
            liabilityPosition8,
            liabilityPosition9
        ]
        
        let snapshot = DataFactory.createSnapshot(with: assetPositions,
                               and: liabilityPositions,
                               for: .now,
                               in: context)
        
        return (snapshot, 3_787_983.86, 28_473.20)
    }
    
    func createAndPersistTestObjects_computeTotalValue_4(using context: NSManagedObjectContext) -> (Snapshot, Decimal, Decimal) {
        let assetPosition1 = DataFactory.createAssetPosition(name: "Sparkasse Konto", poolName: "Bank Inland", value: 76.33, context: context)
        let assetPosition2 = DataFactory.createAssetPosition(name: "Commerzbank Konto", poolName: "Bank Inland", value: 2_672_654.80, context: context)
        let assetPosition3 = DataFactory.createAssetPosition(name: "Reifeisenbank Konto", poolName: "Bank Inland", value: 756_085.95, context: context)
        let assetPosition4 = DataFactory.createAssetPosition(name: "Bank of America", poolName: "Bank Ausland", value: 650.01, context: context)
        let assetPosition5 = DataFactory.createAssetPosition(name: "Blackrock", poolName: "Bank Ausland", value: 302_070.29, context: context)
        let assetPosition6 = DataFactory.createAssetPosition(name: "Geldbeutel", poolName: "Bargeld", value: 30.50, context: context)
        let assetPosition7 = DataFactory.createAssetPosition(name: "Sparschwein", poolName: "Bargeld", value: 301.22, context: context)
        let assetPosition8 = DataFactory.createAssetPosition(name: "Morgan Stanley", poolName: "Wertpapiere", value: 0, context: context)
        let liabilityPosition1 = DataFactory.createLiabilityPosition(name: "Auto", poolName: "Privat", value: 22.2, context: context)
        let liabilityPosition2 = DataFactory.createLiabilityPosition(name: "Wohnung 1", poolName: "Privat", value: 5_000.00, context: context)
        let liabilityPosition3 = DataFactory.createLiabilityPosition(name: "Vinylsammlung", poolName: "Privat", value: 300.0, context: context)
        let liabilityPosition4 = DataFactory.createLiabilityPosition(name: "Motorrad", poolName: "Privat", value: 4_000, context: context)
        let liabilityPosition5 = DataFactory.createLiabilityPosition(name: "Studium 1", poolName: "Bank", value: 2_000.0, context: context)
        let liabilityPosition6 = DataFactory.createLiabilityPosition(name: "Studium 2", poolName: "Bank", value: 6_000.0, context: context)
        let liabilityPosition7 = DataFactory.createLiabilityPosition(name: "Wohnung 2", poolName: "Bank", value: 10_000.0, context: context)
        let liabilityPosition8 = DataFactory.createLiabilityPosition(name: "Herd", poolName: "Online", value: 0.0, context: context)
        let liabilityPosition9 = DataFactory.createLiabilityPosition(name: "Spülmaschine", poolName: "Online", value: 0.0, context: context)
        
        let assetPositions = [
            assetPosition1,
            assetPosition2,
            assetPosition3,
            assetPosition4,
            assetPosition5,
            assetPosition6,
            assetPosition7,
            assetPosition8
        ]
        
        let liabilityPositions = [
            liabilityPosition1,
            liabilityPosition2,
            liabilityPosition3,
            liabilityPosition4,
            liabilityPosition5,
            liabilityPosition6,
            liabilityPosition7,
            liabilityPosition8,
            liabilityPosition9
        ]
        
        let snapshot = DataFactory.createSnapshot(with: assetPositions,
                               and: liabilityPositions,
                               for: .now,
                               in: context)
        
        return (snapshot, 3_731_869.1, 27_322.2)
    }
    
    func createAndPersistTestObjects_computeTotalValue_5(using context: NSManagedObjectContext) -> (Snapshot, Decimal, Decimal) {
        let snapshot = DataFactory.createSnapshotWithoutPositions(for: .now, in: context)
        return (snapshot, 0.0, 0.0)
    }
    
    
    func createAndPersistTestObjects_setSelectedCategoryForNewCumulativeValue_1(using context: NSManagedObjectContext) -> (DonutChartCategory, DonutChartCategory) {
        let assetPosition1 = DataFactory.createAssetPosition(name: "Sparkasse Konto", poolName: "Bank", value: 20.0, context: context)
        let assetPosition2 = DataFactory.createAssetPosition(name: "FNZ Depot", poolName: "Wertpapiere", value: 30.0, context: context)
        let assetPosition3 = DataFactory.createAssetPosition(name: "Geldbeutel", poolName: "Bargeld", value: 50.0, context: context)
        
        let liabilityPosition1 = DataFactory.createLiabilityPosition(name: "Auto-Kredit", poolName: "Privat", value: 40, context: context)
        let liabilityPosition2 = DataFactory.createLiabilityPosition(name: "Studien-Kredit", poolName: "Staat", value: 60, context: context)
        
        let _ = DataFactory.createSnapshot(with: [assetPosition1, assetPosition2, assetPosition3],
                               and: [liabilityPosition1, liabilityPosition2],
                               for: .now,
                               in: context)
        
        return (
            .init(pools: [.init(value: 30.0, name: "Wertpapiere", percentage: 30.0)]),
            .init(pools:[.init(value: 40.0, name: "Privat", percentage: 40.0)])
        )
    }
    
    func createAndPersistTestObjects_setSelectedCategoryForNewCumulativeValue_2(using context: NSManagedObjectContext) -> (DonutChartCategory, DonutChartCategory) {
        let assetPosition1 = DataFactory.createAssetPosition(name: "Sparkasse Konto", poolName: "Bank", value: 20.0, context: context)
        let assetPosition2 = DataFactory.createAssetPosition(name: "FNZ Depot", poolName: "Wertpapiere", value: 30.0, context: context)
        let assetPosition3 = DataFactory.createAssetPosition(name: "Geldbeutel", poolName: "Bargeld", value: 50.0, context: context)
        
        let liabilityPosition1 = DataFactory.createLiabilityPosition(name: "Auto-Kredit", poolName: "Privat", value: 40, context: context)
        let liabilityPosition2 = DataFactory.createLiabilityPosition(name: "Studien-Kredit", poolName: "Staat", value: 60, context: context)
        
        let _ = DataFactory.createSnapshot(with: [assetPosition1, assetPosition2, assetPosition3],
                               and: [liabilityPosition1, liabilityPosition2],
                               for: .now,
                               in: context)
        
        return (
            .init(pools: [.init(value: 20.0, name: "Bank", percentage: 20.0)]),
            .init(pools:[.init(value: 40.0, name: "Privat", percentage: 40.0)])
        )
    }
}

