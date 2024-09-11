
import CoreData


extension Asset {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Asset> {
        let request = NSFetchRequest<Asset>(entityName: "Asset")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Asset.name, ascending: true)]
        return request
    }

    @NSManaged public var name: String
    @NSManaged public var pool: AssetPool?

}

extension Asset : Identifiable {

}
