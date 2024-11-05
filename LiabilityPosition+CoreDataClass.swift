import Foundation
import CoreData

@objc(LiabilityPosition)
public class LiabilityPosition: NSManagedObject, Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case poolName
        case value
    }
    
    required convenience public init(from decoder: Decoder) throws {
        self.init(usedContext: ProductionCoreDataStack.shared.context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        poolName = try container.decode(String.self, forKey: .poolName)
        value = try container.decode(Double.self, forKey: .value)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(poolName, forKey: .poolName)
        try container.encode(value, forKey: .value)
    }
}
