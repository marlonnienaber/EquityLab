import Foundation
import CoreData

@objc(Receivable)
public class Receivable: NSManagedObject, Codable {
    func getTransactionRequest() -> NSFetchRequest<Transaction> {
        let request = Transaction.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Transaction.date, ascending: true)]
        request.predicate = NSPredicate(format: "receivable = %@", self)
        return request
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case debtor
    }
    
    required convenience public init(from decoder: Decoder) throws {
        self.init(usedContext: ProductionCoreDataStack.shared.context)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        debtor = Person.getOrCreatePerson(name: try container.decode(String.self, forKey: .debtor))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(debtor?.name, forKey: .debtor)
    }
}
