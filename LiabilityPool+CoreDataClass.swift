import CoreData

@objc(LiabilityPool)
public class LiabilityPool: NSManagedObject, Codable {
    
    func getLiabilityRequest() -> NSFetchRequest<Liability> {
        let request = Liability.fetchRequest()
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "pool = %@", self)
        return request
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case liabilities
    }
    
    required convenience public init(from decoder: Decoder) throws {
        self.init(usedContext: ProductionCoreDataStack.shared.context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        if let liabilitiesSet = try container.decodeIfPresent(Set<Liability>.self, forKey: .liabilities) {
            liabilities = liabilitiesSet as NSSet
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        if let liabilitiesSet = liabilities as? Set<Liability> {
            try container.encodeIfPresent(liabilitiesSet, forKey: .liabilities)
        }
    }
}
