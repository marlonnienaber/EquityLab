import CoreData

class CoreDataObserver {
    private let context: NSManagedObjectContext
    private let onEntityChange: (NSManagedObject.Type) -> Void

    init(context: NSManagedObjectContext, onEntityChange: @escaping (NSManagedObject.Type) -> Void) {
        self.context = context
        self.onEntityChange = onEntityChange
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contextDidChange(_:)),
            name: .NSManagedObjectContextObjectsDidChange,
            object: context
        )
    }

    @objc private func contextDidChange(_ notification: Notification) {
        let inserted = notification.userInfo?[NSInsertedObjectsKey] as? Set<NSManagedObject> ?? []
        let updated = notification.userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject> ?? []
        let deleted = notification.userInfo?[NSDeletedObjectsKey] as? Set<NSManagedObject> ?? []
        let allChangedObjects = inserted.union(updated).union(deleted)

        guard !allChangedObjects.isEmpty else { return }

        var typeMapping: [ObjectIdentifier: NSManagedObject.Type] = [:]
        let changedTypeIDs: Set<ObjectIdentifier> = Set(allChangedObjects.map {
            let type = type(of: $0)
            let identifier = ObjectIdentifier(type)
            typeMapping[identifier] = type
            return identifier
        })
        changedTypeIDs.forEach { typeID in
            if let entityType = typeMapping[typeID] {
                onEntityChange(entityType)
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .NSManagedObjectContextObjectsDidChange, object: context)
    }
}
