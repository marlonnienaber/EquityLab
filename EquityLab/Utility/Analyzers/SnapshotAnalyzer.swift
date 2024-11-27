import Foundation

struct SnapshotAnalyzer {
    private let repository: SnapshotRepository
    
    init(repository: SnapshotRepository) {
        self.repository = repository
    }
    
    func calculateEquityValue(for snapshot: Snapshot) -> Decimal {
        let totalLiabilityValue = calculateLiabilityValue(for: snapshot)
        let totalAssetValue = calculateAssetValue(for: snapshot)
        return totalAssetValue - totalLiabilityValue
    }
    
    func calculateAssetValue(for snapshot: Snapshot) -> Decimal {
        let assetPositions = repository.assetPositions.filter{ $0.snapshot == snapshot }
        return assetPositions.map{ $0.value.decimalValue }.reduce(0, +)
    }
    
    func calculateLiabilityValue(for snapshot: Snapshot) -> Decimal {
        let liabilityPositions = repository.liabilityPositions.filter{ $0.snapshot == snapshot }
        return liabilityPositions.map{ $0.value.decimalValue }.reduce(0, +)
    }
    
    func getYear(of snapshot: Snapshot) -> Int? {
        guard let date = snapshot.date else { return nil }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: date)
        return components.year
    }
}

