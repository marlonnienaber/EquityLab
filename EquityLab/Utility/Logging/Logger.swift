import os

extension Logger {
    init(subsystem: Subsystem, component: Component) {
        self.init(subsystem: subsystem.rawValue, category: component.rawValue)
    }
    
    enum Subsystem: String {
        case dashboardTab = "dashboard tab"
        case snapshotTab = "snapshot tab"
        case assetTab = "asset tab"
        case liabilityTab = "liability tab"
    }
    
    enum Component: String {
        case dashboardViewModel = "DashboardViewModel"
        case distributionChartViewModel = "DistributionChartViewModel"
        case snapshotLedgerViewModel = "SnapshotLedgerViewModel"
        case assetLedgerViewModel = "AssetLedgerViewModel"
        case liabilityLedgerViewModel = "LiabilityLedgerViewModel"
    }
}
