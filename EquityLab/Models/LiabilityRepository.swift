import CoreData

class LiabilityRepository: NSObject {
    public static let production = LiabilityRepository(context: ProductionCoreDataStack.shared.context)
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchLiabilities() -> [Liability] {
        let liabilityFetchRequest = NSFetchRequest<Liability>(entityName: String(describing: "Liability"))
        return (try? context.fetch(liabilityFetchRequest)) ?? []
    }
    
    func fetchLiabilityPools() -> [LiabilityPool] {
        let liabilityPoolFetchRequest = NSFetchRequest<LiabilityPool>(entityName: String(describing: "LiabilityPool"))
        return (try? context.fetch(liabilityPoolFetchRequest)) ?? []
    }
}
