import CoreData

@objc(Receivable)
public class Receivable: Asset, Codable {
    
    public var repaymentPercentage: Double {
        repaidAmount / initialAmount
    }
    
    public var openAmount: Double {
        initialAmount - repaidAmount
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case debtor
        case grantDate
        case initialAmount
        case repaidAmount
        case type
    }
    
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let debtor = try container.decode(String.self, forKey: .debtor)
        let grantDate = try container.decode(Date.self, forKey: .grantDate)
        let initialAmount = try container.decode(Double.self, forKey: .initialAmount)
        let repaidAmount = try container.decode(Double.self, forKey: .repaidAmount)
        
        self.init(usedContext: ProductionCoreDataStack.shared.context)
        self.name = name
        self.debtor = debtor
        self.grantDate = grantDate
        self.initialAmount = initialAmount
        self.repaidAmount = repaidAmount
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Asset.SubType.receivable.rawValue, forKey: .type)
        try container.encode(name, forKey: .name)
        try container.encode(debtor, forKey: .debtor)
        try container.encode(grantDate, forKey: .grantDate)
        try container.encode(initialAmount, forKey: .initialAmount)
        try container.encode(repaidAmount, forKey: .repaidAmount)
    }

}
