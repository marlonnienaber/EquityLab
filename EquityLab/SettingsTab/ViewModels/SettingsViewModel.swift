import os
import SwiftUI
import CoreData

@Observable
class SettingsViewModel {
    @ObservationIgnored private static let logger = Logger(subsystem: .settingsTab, component: .settingsViewModel)
    
    @ObservationIgnored private var snapshotRepository: SnapshotRepository
    @ObservationIgnored private var loanPartnerRepository: LoanPartnerRepository
    @ObservationIgnored private var assetRepository: AssetRepository
    @ObservationIgnored private var liabilityRepository: LiabilityRepository
    var isSerializingState = false
    var operationFailed = false
    var operationSucceeded = false
    var operationSuccessDescription = ""
    var operationFailedDescription = ""
    var temporaryBackupFileUrl: URL?
    var presentImportPathPickerSheet = false
    
    init(
        snapshotRepository: SnapshotRepository = .production,
        loanPartnerRepository: LoanPartnerRepository = .production,
        assetRepository: AssetRepository = .production,
        liabilityRepository: LiabilityRepository = .production
    ) {
        Self.logger.debug("DashboardViewModel()")
        self.snapshotRepository = snapshotRepository
        self.loanPartnerRepository = loanPartnerRepository
        self.assetRepository = assetRepository
        self.liabilityRepository = liabilityRepository
    }
    
    func serializeStateAndShowFileLocationPicker() async {
        Self.logger.debug("serializeStateAndShowFileLocationPicker()")
        await MainActor.run {
            isSerializingState = true
        }
        do {
            let snapshots = snapshotRepository.getSnapshots()
            let loanPartners = loanPartnerRepository.getLoanPartners()
            let liabilityPools = liabilityRepository.getLiabilityPools()
            let assetPools = assetRepository.getAssetPools()
            let jsonBackup = JsonBackup(snapshots: snapshots, loanPartners: loanPartners, liabilityPools: liabilityPools, assetPools: assetPools)
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
                Position.self,
                AssetPool.self,
                Receivable.self,
                Possession.self,
                LiabilityPool.self,
                Liability.self,
                LoanPartner.self,
                LoanTransaction.self
            ]
            for entityType in entityTypes {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: entityType))
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                guard let _ = try? context.execute(deleteRequest) else { return }
            }
            context.reset()
            
            let data = try Data(contentsOf: url)
            guard !data.isEmpty else { throw EmptyDataError() }
            let decoder = JSONDecoder()
            let _  = try decoder.decode(JsonBackup.self, from: data)
            try context.save()
            operationSuccessDescription = "The data from the selected file were imported"
            operationSucceeded = true
        } catch let error {
            operationFailedDescription = error.localizedDescription
            print(error.localizedDescription)
            operationFailed = true
        }
    }
}

struct EmptyDataError: LocalizedError {
    var errorDescription: String? {
        "The imported file does not contain any data"
    }
}
