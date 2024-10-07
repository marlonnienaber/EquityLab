
import CoreData

@objc(Possession)
public class Possession: Asset, Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case volatile
        case type
    }
    
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let volatile = try container.decode(Bool.self, forKey: .volatile)
        
        self.init(usedContext: ProductionCoreDataStack.shared.context)
        self.name = name
        self.volatile = volatile
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Asset.SubType.possession.rawValue, forKey: .type)
        try container.encode(name, forKey: .name)
        try container.encode(volatile, forKey: .volatile)
    }
}
