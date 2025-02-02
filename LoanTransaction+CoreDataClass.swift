import Foundation
import CoreData

@objc(LoanTransaction)
public class LoanTransaction: NSManagedObject, Codable {
    enum CodingKeys: String, CodingKey {
        case amount
        case date
        case emoji
        case note
        case issuerName
    }
    
    required convenience public init(from decoder: Decoder) throws {
        self.init(usedContext: ProductionCoreDataStack.shared.context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        amount = (try container.decode(Decimal.self, forKey: .amount)).nsDecimalNumberValue
        date = try container.decode(Date.self, forKey: .date)
        emoji = try container.decode(String.self, forKey: .emoji)
        note = try container.decode(String.self, forKey: .note)
        
        let issuerName = try container.decode(String.self, forKey: .issuerName)
        let issuerRequest = LoanPartner.fetchRequest()
        issuerRequest.predicate = NSPredicate(format: "name == %@", issuerName)
        issuer = try ProductionCoreDataStack.shared.context.fetch(issuerRequest).first
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(amount.decimalValue, forKey: .amount)
        try container.encode(date, forKey: .date)
        try container.encode(emoji, forKey: .emoji)
        try container.encode(note, forKey: .note)
        try container.encode(issuer?.name ?? "", forKey: .issuerName)
    }
}
