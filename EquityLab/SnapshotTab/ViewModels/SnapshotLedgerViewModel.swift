import os
import CoreData
import Combine

@Observable
class SnapshotLedgerViewModel {
    @ObservationIgnored private static let logger = Logger(subsystem: .snapshotTab, component: .snapshotLedgerViewModel)
    
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()
    @ObservationIgnored private var repository: SnapshotRepositoryNew
    @ObservationIgnored private var snapshotAnalyzer: SnapshotAnalyzerNew
    @ObservationIgnored private var equityValueCache = [Snapshot:Decimal]()
    private var yearToSnapshotDictionary = [Int:[Snapshot]]()
    var years = [Int]()
    var hasNoSnapshots: Bool {
        Self.logger.debug("hasNoSnapshots")
        return years.isEmpty
    }
    var activeSheet: SnapshotSheetType? = nil
    
    
    /* TODO: currently changes in AssetPositions or LiabilityPositions are only reflected in the ledger because this VM seems to be reinitialized after saveSnapshot(). -> investigate why */
    init(repository: SnapshotRepositoryNew = .production) {
        Self.logger.debug("SnapshotLedgerViewModel()")
        self.repository = repository
        self.snapshotAnalyzer = SnapshotAnalyzerNew(repository: repository)
        
        repository.$snapshots
            .sink { [weak self] newSnapshots in
                Self.logger.debug("new snapshots arrived in VM")
                guard let self else { return }
                transformIntoViewModelData(newSnapshots)
            }
            .store(in: &cancellables)
    }
    
    
    private func transformIntoViewModelData(_ newSnapshots: [Snapshot]) {
        equityValueCache = [:]
        yearToSnapshotDictionary = [:]
        years = []
        let sortedSnapshots = newSnapshots.sorted{ $0.date ?? .distantFuture > $1.date ?? .distantFuture }
        for snapshot in sortedSnapshots {
            equityValueCache[snapshot] = snapshotAnalyzer.calculateEquityValue(for: snapshot)
            if let year = snapshotAnalyzer.getYear(of: snapshot) {
                if !yearToSnapshotDictionary.keys.contains(year) {
                    years.append(year)
                }
                if var associatedSnapshots = yearToSnapshotDictionary[year] {
                    associatedSnapshots.append(snapshot)
                    yearToSnapshotDictionary[year] = associatedSnapshots
                } else {
                    yearToSnapshotDictionary[year] = [snapshot]
                }
            }
        }
    }
    
    func getSnapshots(fallingInto year: Int) -> [Snapshot] {
        Self.logger.debug("getSnapshots(fallingInto year)")
        return yearToSnapshotDictionary[year] ?? []
    }
    
    func deleteSnapshots(in year: Int, for indexSet: IndexSet) {
        Self.logger.debug("deleteSnapshots(in year)")
        guard let sectionSnapshots = yearToSnapshotDictionary[year] else { return }
        indexSet.map{sectionSnapshots[$0]}.forEach{repository.deleteSnapshot($0)}
    }
    
    func getEquityValue(of snapshot: Snapshot) -> NSNumber {
        Self.logger.debug("getEquityValue(of snapshot)")
        let equityValue = equityValueCache[snapshot] ?? 0.0
        return equityValue.nsDecimalNumberValue
    }
}

enum SnapshotSheetType: Identifiable {
    case addSheet
    case updateSheet(snapshot: Snapshot)
    var id: String {
        switch self {
        case .addSheet:
            return "addSheet"
        case .updateSheet(let snapshot):
            return "updateSheet-\(snapshot.id)"
        }
    }
}
