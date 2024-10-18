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
        case settingsTab = "settingsTab"
    }
    
    enum Component: String {
        case dashboardViewModel = "DashboardViewModel"
        case distributionChartViewModel = "DistributionChartViewModel"
        case snapshotLedgerViewModel = "SnapshotLedgerViewModel"
        case assetLedgerViewModel = "AssetLedgerViewModel"
        case assetFormViewModel = "AssetFormViewModel"
        case liabilityLedgerViewModel = "LiabilityLedgerViewModel"
        case liabilityFormViewModel = "LiabilityFormViewModel"
        case snapshotStructureViewModel = "SnapshotStructureViewModel"
    }
}
