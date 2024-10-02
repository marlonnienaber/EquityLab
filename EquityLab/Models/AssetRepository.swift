import CoreData

class AssetRepository: NSObject {
    public static let production = AssetRepository(context: ProductionCoreDataStack.shared.context)
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchAssets() -> [Asset] {
        let assetFetchRequest = NSFetchRequest<Asset>(entityName: String(describing: "Asset"))
        return (try? context.fetch(assetFetchRequest)) ?? []
    }
    
    func fetchAssetPools() -> [AssetPool] {
        let assetPoolFetchRequest = NSFetchRequest<AssetPool>(entityName: String(describing: "AssetPool"))
        return (try? context.fetch(assetPoolFetchRequest)) ?? []
    }
}
