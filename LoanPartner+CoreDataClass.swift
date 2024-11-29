import Foundation
import CoreData

@objc(LoanPartner)
public class LoanPartner: NSManagedObject, Encodable {
    static var nameLookup: [String: LoanPartner] = [:]
    
    static func getOrCreatePerson(name: String) -> LoanPartner {
        if let existingPerson = nameLookup[name] {
            return existingPerson
        } else {
            let newPerson = LoanPartner(usedContext: ProductionCoreDataStack.shared.context)
            newPerson.name = name
            nameLookup[name] = newPerson
            return newPerson
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case name
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
    }
}
