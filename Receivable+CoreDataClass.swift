import Foundation
import CoreData

@objc(Receivable)
public class Receivable: Asset, Codable {
    
    public var repaymentPercentage: Decimal {
        repaidAmount.decimalValue / initialAmount.decimalValue
    }
    
    public var openAmount: Decimal {
        initialAmount.decimalValue - repaidAmount.decimalValue
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case debtor
        case grantDate
        case initialAmount
        case repaidAmount
        case type
    }
    
    var helperInitialAmount: Decimal {
        get {
            initialAmount.decimalValue
        }
        set {
            initialAmount = newValue.nsDecimalNumberValue
        }
    }
    
    var helperRepaidAmount: Decimal {
        get {
            repaidAmount.decimalValue
        }
        set {
            repaidAmount = newValue.nsDecimalNumberValue
        }
    }
    
    required convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let debtor = try container.decode(String.self, forKey: .debtor)
        let grantDate = try container.decode(Date.self, forKey: .grantDate)
        let initialAmount = try container.decode(Decimal.self, forKey: .initialAmount)
        let repaidAmount = try container.decode(Decimal.self, forKey: .repaidAmount)
        
        self.init(usedContext: ProductionCoreDataStack.shared.context)
        self.name = name
        self.debtor = debtor
        self.grantDate = grantDate
        helperInitialAmount = initialAmount
        helperRepaidAmount = repaidAmount
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Asset.SubType.receivable.rawValue, forKey: .type)
        try container.encode(name, forKey: .name)
        try container.encode(debtor, forKey: .debtor)
        try container.encode(grantDate, forKey: .grantDate)
        try container.encode(helperInitialAmount, forKey: .initialAmount)
        try container.encode(helperRepaidAmount, forKey: .repaidAmount)
    }

}
