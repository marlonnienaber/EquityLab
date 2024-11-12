import Foundation
import CoreData

@objc(Person)
public class Person: NSManagedObject, Encodable {
    static var nameLookup: [String: Person] = [:]
    
    static func getOrCreatePerson(name: String) -> Person {
        if let existingPerson = nameLookup[name] {
            return existingPerson
        } else {
            let newPerson = Person(usedContext: ProductionCoreDataStack.shared.context)
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
