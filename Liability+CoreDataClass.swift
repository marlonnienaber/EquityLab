import Foundation
import CoreData

@objc(Liability)
public class Liability: NSManagedObject, Codable {
    func getTransactionRequest() -> NSFetchRequest<LoanTransaction> {
        let request = LoanTransaction.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \LoanTransaction.date, ascending: true)]
        request.predicate = NSPredicate(format: "liability = %@", self)
        return request
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case creditor
    }
    
    required convenience public init(from decoder: Decoder) throws {
        self.init(usedContext: ProductionCoreDataStack.shared.context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        creditor = LoanPartner.getOrCreatePerson(name: try container.decode(String.self, forKey: .creditor))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(creditor?.name, forKey: .creditor)
    }
}
