import Foundation
import CoreData


extension Position {

    @NSManaged public var name: String
    @NSManaged public var poolName: String
    @NSManaged public var value: NSDecimalNumber

}

extension Position : Identifiable {

}
