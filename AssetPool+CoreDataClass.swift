
import CoreData

@objc(AssetPool)
public class AssetPool: NSManagedObject, Codable, Named {

    func getAssetRequest() -> NSFetchRequest<Asset> {
        let request = Asset.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Asset.name, ascending: true)]
        request.predicate = NSPredicate(format: "pool = %@", self)
        return request
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case assets
    }
    
    required convenience public init(from decoder: Decoder) throws {
        self.init(usedContext: ProductionCoreDataStack.shared.context)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        var assetsSet = Set<Asset>()
        var assetsContainer = try container.nestedUnkeyedContainer(forKey: .assets)
        while !assetsContainer.isAtEnd {
            let assetDecoder = try assetsContainer.superDecoder()
            if let receivable = try? Receivable(from: assetDecoder) {
                assetsSet.insert(receivable)
            } else if let possession = try? Possession(from: assetDecoder) {
                print(possession.name)
                assetsSet.insert(possession)
            }
        }
        self.assets = assetsSet as NSSet
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        if let assetsSet = assets as? Set<Asset> {
            var assetsContainer = container.nestedUnkeyedContainer(forKey: .assets)
            for asset in assetsSet {
                let assetEncoder = assetsContainer.superEncoder()
                if let receivable = asset as? Receivable {
                    try receivable.encode(to: assetEncoder)
                } else if let possession = asset as? Possession {
                    try possession.encode(to: assetEncoder)
                }
            }
        }
    }
}

