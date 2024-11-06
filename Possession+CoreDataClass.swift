import Foundation
import CoreData

@objc(Possession)
public class Possession: NSManagedObject, Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case volatile
    }
    
    required convenience public init(from decoder: Decoder) throws {
        self.init(usedContext: ProductionCoreDataStack.shared.context)
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.name = try container.decode(String.self, forKey: .name)
        self.volatile = try container.decode(Bool.self, forKey: .volatile)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(volatile, forKey: .volatile)
    }
}
