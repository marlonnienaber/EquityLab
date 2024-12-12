import Foundation
import CoreData

@objc(Liability)
public class Liability: NSManagedObject, Codable, Named {
    
    public var repaymentPercentage: Decimal {
        repaidAmount.decimalValue / initialAmount.decimalValue
    }
    
    public var openAmount: Decimal {
        initialAmount.decimalValue - repaidAmount.decimalValue
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case creditor
        case grantDate
        case initialAmount
        case repaidAmount
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
        self.init(context: ProductionCoreDataStack.shared.context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        creditor = try container.decode(String.self, forKey: .creditor)
        grantDate = try container.decode(Date.self, forKey: .grantDate)
        helperInitialAmount = try container.decode(Decimal.self, forKey: .initialAmount)
        helperRepaidAmount = try container.decode(Decimal.self, forKey: .repaidAmount)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(creditor, forKey: .creditor)
        try container.encode(grantDate, forKey: .grantDate)
        try container.encode(helperInitialAmount, forKey: .initialAmount)
        try container.encode(helperRepaidAmount, forKey: .repaidAmount)
    }
}
