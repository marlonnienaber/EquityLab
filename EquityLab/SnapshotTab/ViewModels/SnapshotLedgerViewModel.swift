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
    var hasNoSnapshots: Bool {
        years.isEmpty
    }
    var activeSheet: SnapshotSheetType? = nil
    
    init(repository: SnapshotRepository = .production) {
        Self.logger.debug("SnapshotLedgerViewModel()")
        self.repository = repository
        self.snapshotAnalyzer = SnapshotAnalyzer(repository: repository)
        self.repository.add(observer: self)
        snapshots = repository.getSnapshots().sorted{ $0.date ?? .distantFuture > $1.date ?? .distantFuture }
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
        indexSet.map{sectionSnapshots[$0]}.forEach{repository.delete(snapshot: $0)}
    }
    
    func deleteSnapshots(withIndices indexSet: IndexSet) {
        Self.logger.debug("deleteSnapshots(withIndices indexSet)")
        indexSet.map{snapshots[$0]}.forEach{repository.delete(snapshot: $0)}
    }
    
    func getEquityValue(of snapshot: Snapshot) -> NSNumber {
        Self.logger.debug("getEquityValue(of snapshot)")
        let equityValue = equityValueCache[snapshot] ?? 0.0
        return equityValue.nsDecimalNumberValue
    }
}

extension SnapshotLedgerViewModel: SnapshotObserver, AssetPositionObserver, LiabilityPositionObserver {
    func notifyAfterSnapshotUpdate() {
        Self.logger.debug("notifyAfterSnapshotUpdate()")
        updateSnapshotState()
    }
    
    func notifyAfterAssetPositionUpdate() {
        Self.logger.debug("notifyAfterAssetPositionUpdate()")
        updateSnapshotState()
    }
    
    func notifyAfterLiabilityPositionUpdate() {
        Self.logger.debug("notifyAfterLiabilityPositionUpdate()")
        updateSnapshotState()
    }
    
    private func updateSnapshotState() {
        yearToSnapshotDictionary = [Int:[Snapshot]]()
        years = [Int]()
        self.snapshots = repository.getSnapshots().sorted{ $0.date ?? .distantFuture > $1.date ?? .distantFuture }
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
