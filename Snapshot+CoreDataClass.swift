
import CoreData

@objc(Snapshot)
public class Snapshot: NSManagedObject, Codable {
    
    func getAssetPositionRequest() -> NSFetchRequest<AssetPosition> {
        let request = NSFetchRequest<AssetPosition>(entityName: "AssetPosition")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \AssetPosition.name, ascending: true)]
        request.predicate = NSPredicate(format: "snapshot = %@", self)
        return request
    }

    func getLiabilityPositionRequest() -> NSFetchRequest<LiabilityPosition> {
        let request = NSFetchRequest<LiabilityPosition>(entityName: "LiabilityPosition")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \LiabilityPosition.name, ascending: true)]
        request.predicate = NSPredicate(format: "snapshot = %@", self)
        return request
    }
    
    enum CodingKeys: String, CodingKey {
        case date
        case assets
        case liabilities
    }
    
    required convenience public init(from decoder: Decoder) throws {
        self.init(usedContext: ProductionCoreDataStack.shared.context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(Date.self, forKey: .date)
        if let assetsSet = try container.decodeIfPresent(Set<AssetPosition>.self, forKey: .assets) {
            assets = assetsSet as NSSet
        }
        if let liabilitiesSet = try container.decodeIfPresent(Set<LiabilityPosition>.self, forKey: .liabilities) {
            liabilities = liabilitiesSet as NSSet
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        if let assetsSet = assets as? Set<AssetPosition> {
            try container.encodeIfPresent(assetsSet, forKey: .assets)
        }
        if let liabilitiesSet = liabilities as? Set<LiabilityPosition> {
            try container.encodeIfPresent(liabilitiesSet, forKey: .liabilities)
        }
    }
}
