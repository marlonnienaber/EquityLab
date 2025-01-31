import Foundation
import CoreData

@objc(Liability)
public class Liability: NSManagedObject, Codable {
    enum CodingKeys: String, CodingKey {
        case name
    }
    
    required convenience public init(from decoder: Decoder) throws {
        self.init(context: ProductionCoreDataStack.shared.context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
    }
}
