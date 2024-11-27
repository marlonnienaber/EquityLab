import os
import CoreData

@Observable
class SnapshotLedgerViewModel {
    @ObservationIgnored private static let logger = Logger(subsystem: .snapshotTab, component: .snapshotLedgerViewModel)
    
    @ObservationIgnored private var repository: SnapshotRepository
    @ObservationIgnored private var snapshotAnalyzer: SnapshotAnalyzer
    @ObservationIgnored private var equityValueCache = [Snapshot:Decimal]()
    
    private var snapshots = [Snapshot]()
    private var yearToSnapshotDictionary = [Int:[Snapshot]]()
    var years = [Int]()
    var activeSheet: SnapshotSheetType? = nil
    var hasNoSnapshots: Bool {
        years.isEmpty
    }
    
    
    init(repository: SnapshotRepository = .production) {
        Self.logger.debug("SnapshotLedgerViewModel()")
        self.repository = repository
        self.snapshotAnalyzer = SnapshotAnalyzer(repository: repository)
        
        repository.$snapshots.registerObserver(self, keyPath: \.snapshots) {
            $0.reversed()
        }
        repository.$snapshots.onSetDo { [weak self] newSnapshots in
            guard let self else { return }
            yearToSnapshotDictionary = [Int:[Snapshot]]()
            years = [Int]()
            for snapshot in snapshots {
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
        
        for snapshot in snapshots {
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
        indexSet.map{sectionSnapshots[$0]}.forEach{repository.deleteSnapshot(snapshot: $0)}
    }
    
    func deleteSnapshots(withIndices indexSet: IndexSet) {
        Self.logger.debug("deleteSnapshots(withIndices indexSet)")
        indexSet.map{snapshots[$0]}.forEach{repository.deleteSnapshot(snapshot: $0)}
    }
    
    func getEquityValue(of snapshot: Snapshot) -> NSNumber {
        Self.logger.debug("getEquityValue(of snapshot)")
        return (equityValueCache[snapshot] ?? 0).nsDecimalNumberValue
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
