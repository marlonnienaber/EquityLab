
import CoreData

@objc(Asset)
public class Asset: NSManagedObject, Named {
    public enum SubType: String, Codable, Hashable {
        case receivable
        case possession
    }
}
