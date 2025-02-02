import Foundation
import CoreData

@objc(Receivable)
public class Receivable: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case name
        case transactions
        case debtorName
    }
    
    required convenience public init(from decoder: Decoder) throws {
        self.init(usedContext: ProductionCoreDataStack.shared.context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        
        if let transactionsSet = try container.decodeIfPresent(Set<LoanTransaction>.self, forKey: .transactions) {
            transactions = transactionsSet as NSSet
        }
        
        let debtorName = try container.decode(String.self, forKey: .debtorName)
        let debtorRequest = LoanPartner.fetchRequest()
        debtorRequest.predicate = NSPredicate(format: "name == %@", debtorName)
        debtor = try ProductionCoreDataStack.shared.context.fetch(debtorRequest).first
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        if let transactionSet = transactions as? Set<LoanTransaction> {
            try container.encodeIfPresent(transactionSet, forKey: .transactions)
        }
        try container.encode(debtor?.name ?? "", forKey: .debtorName)
    }

}
