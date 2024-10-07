
import CoreData

@objc(Asset)
public class Asset: NSManagedObject {
    public enum SubType: String, Codable, Hashable {
        case receivable
        case possession
    }
}
