import Foundation
import CoreData

@objc(Liability)
public class Liability: NSManagedObject, Codable {
    public var repaymentPercentage: Double {
        repaidAmount / initialAmount
    }
    
    public var openAmount: Double {
        initialAmount - repaidAmount
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case creditor
        case grantDate
        case initialAmount
        case repaidAmount
    }
    
    required convenience public init(from decoder: Decoder) throws {
        self.init(usedContext: ProductionCoreDataStack.shared.context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        creditor = Person.getOrCreatePerson(name: try container.decode(String.self, forKey: .creditor))
        grantDate = try container.decode(Date.self, forKey: .grantDate)
        initialAmount = try container.decode(Double.self, forKey: .initialAmount)
        repaidAmount = try container.decode(Double.self, forKey: .repaidAmount)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(creditor?.name, forKey: .creditor)
        try container.encode(grantDate, forKey: .grantDate)
        try container.encode(initialAmount, forKey: .initialAmount)
        try container.encode(repaidAmount, forKey: .repaidAmount)
    }
}
