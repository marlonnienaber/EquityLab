struct SnapshotAnalyzer {
    private let repository: SnapshotRepository
    
    init(repository: SnapshotRepository) {
        self.repository = repository
    }
    
    func calculateEquityValue(for snapshot: Snapshot) -> Double {
        let totalLiabilityValue = calculateLiabilityValue(for: snapshot)
        let totalAssetValue = calculateAssetValue(for: snapshot)
        return totalAssetValue - totalLiabilityValue
    }
    
    func calculateAssetValue(for snapshot: Snapshot) -> Double {
        let assetPositions = repository.fetchAssetPositions(of: snapshot)
        return assetPositions.map{ $0.value }.reduce(0, +)
    }
    
    func calculateLiabilityValue(for snapshot: Snapshot) -> Double {
        let liabilityPositions = repository.fetchLiabilityPositions(of: snapshot)
        return liabilityPositions.map{ $0.value }.reduce(0, +)
    }
}

