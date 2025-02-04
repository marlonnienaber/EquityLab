import Foundation
import CoreData

@objc(AssetPool)
public class AssetPool: NSManagedObject, Codable {

    func getReceivableRequest() -> NSFetchRequest<Receivable> {
        let request = Receivable.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Receivable.name, ascending: true)]
        request.predicate = NSPredicate(format: "pool = %@", self)
        return request
    }
    
    func getPossessionRequest() -> NSFetchRequest<Possession> {
        let request = Possession.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Possession.name, ascending: true)]
        request.predicate = NSPredicate(format: "pool = %@", self)
        return request
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case receivables
        case possessions
    }
    
    required convenience public init(from decoder: Decoder) throws {
        self.init(usedContext: ProductionCoreDataStack.shared.context)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        if let receivablesSet = try container.decodeIfPresent(Set<Receivable>.self, forKey: .receivables) {
            receivables = receivablesSet as NSSet
        }
        if let possessionsSet = try container.decodeIfPresent(Set<Possession>.self, forKey: .possessions) {
            possessions = possessionsSet as NSSet
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        if let receivablesSet = receivables as? Set<Receivable> {
            try container.encodeIfPresent(receivablesSet, forKey: .receivables)
        }
        if let possessionsSet = possessions as? Set<Possession> {
            try container.encodeIfPresent(possessionsSet, forKey: .possessions)
        }
    }
}
