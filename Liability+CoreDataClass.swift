import Foundation
import CoreData

@objc(Liability)
public class Liability: NSManagedObject, Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case transactions
        case creditorName
    }
    
    required convenience public init(from decoder: Decoder) throws {
        self.init(usedContext: ProductionCoreDataStack.shared.context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        
        if let transactionsSet = try container.decodeIfPresent(Set<LoanTransaction>.self, forKey: .transactions) {
            transactions = transactionsSet as NSSet
        }
        
        let creditorName = try container.decode(String.self, forKey: .creditorName)
        let creditorRequest = LoanPartner.fetchRequest()
        creditorRequest.predicate = NSPredicate(format: "name == %@", creditorName)
        creditor = try ProductionCoreDataStack.shared.context.fetch(creditorRequest).first
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        if let transactionSet = transactions as? Set<LoanTransaction> {
            try container.encodeIfPresent(transactionSet, forKey: .transactions)
        }
        try container.encode(creditor?.name ?? "", forKey: .creditorName)
    }
}
