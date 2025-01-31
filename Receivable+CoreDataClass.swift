import Foundation
import CoreData

@objc(Receivable)
public class Receivable: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case name
        case debtor
    }
    
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let debtor = try container.decode(String.self, forKey: .debtor)
        
        self.init(usedContext: ProductionCoreDataStack.shared.context)
        self.name = name
        self.debtor = nil
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(debtor?.name, forKey: .debtor)
    }

}
