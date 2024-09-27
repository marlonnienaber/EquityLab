import os
import CoreData

@Observable
class SnapshotLedgerViewModel {
    @ObservationIgnored private static let logger = Logger(subsystem: .snapshotTab, component: .snapshotLedgerViewModel)
    
    @ObservationIgnored private var repository: SnapshotRepository
    @ObservationIgnored private var snapshotAnalyzer: SnapshotAnalyzer
    @ObservationIgnored private var equityValueCache = [Snapshot:Double]()
    private var snapshots = [Snapshot]()
    var yearToSnapshotDictionary = [Int:[Snapshot]]()
    var years = [Int]()
    
    init(repository: SnapshotRepository = SnapshotRepository.production) {
        self.repository = repository
        self.snapshotAnalyzer = SnapshotAnalyzer(repository: repository)
        snapshots = repository.fetchSnapshots(sortingOrder: .descending)
        for snapshot in snapshots {
            equityValueCache[snapshot] = snapshotAnalyzer.calculateEquityValue(for: snapshot)
            if let year = extractYear(from: snapshot) {
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
    
    private func extractYear(from snapshot: Snapshot) -> Int? {
        guard let date = snapshot.date else { return nil }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: date)
        return components.year
    }
    
    func snapshots(fallingInto year: Int) -> [Snapshot] {
        yearToSnapshotDictionary[year] ?? []
    }
    
    func deleteSnapshots(in year: Int, for indexSet: IndexSet) {
        guard let sectionSnapshots = yearToSnapshotDictionary[year] else { return }
        indexSet.map{sectionSnapshots[$0]}.forEach{repository.delete(snapshot: $0)}
    }
    
    func deleteSnapshots(withIndices indexSet: IndexSet) {
        indexSet.map{snapshots[$0]}.forEach{repository.delete(snapshot: $0)}
    }
    
    func getEquityValue(of snapshot: Snapshot) -> NSNumber {
        let equityValue = equityValueCache[snapshot] ?? 0.0
        return NSNumber(value: equityValue)
    }
    
}

extension SnapshotLedgerViewModel: SnapshotObserver {
    func notifyAfterSnapshotUpdate(_ fetchSnapshots: (SnapshotSortingOrder) -> [Snapshot]) {
        yearToSnapshotDictionary = [Int:[Snapshot]]()
        years = [Int]()
        self.snapshots = fetchSnapshots(.descending)
        for snapshot in snapshots {
            equityValueCache[snapshot] = snapshotAnalyzer.calculateEquityValue(for: snapshot)
            if let year = extractYear(from: snapshot) {
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
