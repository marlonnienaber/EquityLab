import UIKit
import CoreData

class TestingCoreDataStack: NSObject {
    static let shared = TestingCoreDataStack()
    private let persistentContainer: NSPersistentContainer
    let context: NSManagedObjectContext
    
    private override init() {
        persistentContainer = NSPersistentContainer(name: "CoreDataModel")
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.type = NSInMemoryStoreType

        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("failed to load persistentStores of persistentContainer. Error: \(error)")
            }
        }
        context = persistentContainer.viewContext
    }
}
