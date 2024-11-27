import os
import SwiftUI
import CoreData

@Observable
class SettingsViewModel {
    @ObservationIgnored private static let logger = Logger(subsystem: .settingsTab, component: .settingsViewModel)
    
    @ObservationIgnored private var snapshotRepository: SnapshotRepository
    @ObservationIgnored private var assetRepository: AssetRepository
    @ObservationIgnored private var liabilityRepository: LiabilityRepository
    @ObservationIgnored private var personRepository: PersonRepository
    var isSerializingState = false
    var operationFailed = false
    var operationSucceeded = false
    var operationSuccessDescription = ""
    var operationFailedDescription = ""
    var temporaryBackupFileUrl: URL?
    var presentImportPathPickerSheet = false
    
    init(
        snapshotRepository: SnapshotRepository = .production,
        assetRepository: AssetRepository = .production,
        liabilityRepository: LiabilityRepository = .production,
        personRepository: PersonRepository = .production
    ) {
        Self.logger.debug("DashboardViewModel()")
        self.snapshotRepository = snapshotRepository
        self.assetRepository = assetRepository
        self.liabilityRepository = liabilityRepository
        self.personRepository = personRepository
    }
    
    func serializeStateAndShowFileLocationPicker() async {
        Self.logger.debug("serializeStateAndShowFileLocationPicker()")
        await MainActor.run {
            isSerializingState = true
        }
        do {
            let snapshots = snapshotRepository.snapshots
            let persons = personRepository.persons
            let liabilityPools = liabilityRepository.liabilityPools
            let assetPools = assetRepository.assetPools
            let jsonBackup = JsonBackup(snapshots: snapshots, persons: persons, liabilityPools: liabilityPools, assetPools: assetPools)
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(jsonBackup)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy|HH-mm"
            let timestamp = formatter.string(from: Date())
            let fileName = "\(timestamp).json"
            let temporaryDirectory = FileManager.default.temporaryDirectory
            let temporaryFileURL = temporaryDirectory.appendingPathComponent(fileName)
            try jsonData.write(to: temporaryFileURL)
            await MainActor.run {
                self.isSerializingState = false
                self.temporaryBackupFileUrl = temporaryFileURL
            }
        } catch let error {
            await MainActor.run {
                self.isSerializingState = false
                self.operationFailedDescription = error.localizedDescription
                self.operationFailed = true
            }
        }
    }
    
    func deserializeJsonFile(at url: URL) {
        Self.logger.debug("deserializeJsonFile(at url)")
        do {
            let context = ProductionCoreDataStack.shared.context
            
            let entityTypes = [
                Snapshot.self,
                AssetPosition.self,
                LiabilityPosition.self,
                AssetPool.self,
                Possession.self,
                Receivable.self,
                LiabilityPool.self,
                Liability.self
            ]
            for entityType in entityTypes {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: entityType))
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                guard let _ = try? context.execute(deleteRequest) else { return }
            }
            try context.save()
            
            let data = try Data(contentsOf: url)
            guard !data.isEmpty else { throw EmptyDataError() }
            let decoder = JSONDecoder()
            let _  = try decoder.decode(JsonBackup.self, from: data)
            try context.save()
            operationSuccessDescription = "The data from the selected file were imported"
            operationSucceeded = true
        } catch let error {
            operationFailedDescription = error.localizedDescription
            operationFailed = true
        }
    }
}

struct EmptyDataError: LocalizedError {
    var errorDescription: String? {
        "The imported file does not contain any data"
    }
}

struct JsonBackup: Codable {
    let snapshots: [Snapshot]
    let persons: [Person]
    let liabilityPools: [LiabilityPool]
    let assetPools: [AssetPool]
    
    enum CodingKeys: String, CodingKey {
        case snapshots
        case persons
        case liabilityPools
        case assetPools
    }
    
    init(snapshots: [Snapshot], persons: [Person], liabilityPools: [LiabilityPool], assetPools: [AssetPool]) {
        self.snapshots = snapshots
        self.persons = persons
        self.liabilityPools = liabilityPools
        self.assetPools = assetPools
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        snapshots = try container.decode([Snapshot].self, forKey: .snapshots)
        persons = []
        liabilityPools = try container.decode([LiabilityPool].self, forKey: .liabilityPools)
        assetPools = try container.decode([AssetPool].self, forKey: .assetPools)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(snapshots, forKey: .snapshots)
        try container.encode(persons, forKey: .persons)
        try container.encode(liabilityPools, forKey: .liabilityPools)
        try container.encode(assetPools, forKey: .assetPools)
    }
}
