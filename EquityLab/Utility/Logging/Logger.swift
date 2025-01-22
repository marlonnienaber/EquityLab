import os

extension Logger {
    init(subsystem: Subsystem, component: Component) {
        self.init(subsystem: subsystem.rawValue, category: component.rawValue)
    }
    
    enum Subsystem: String {
        case dashboardTab = "dashboard tab"
        case snapshotTab = "snapshot tab"
        case loanManagementTab = "loan management tab"
        case settingsTab = "settings tab"
    }
    
    enum Component: String {
        case dashboardViewModel = "DashboardViewModel"
        case distributionChartViewModel = "DistributionChartViewModel"
        case changeChartViewModel = "ChangeChartViewModel"
        case snapshotLedgerViewModel = "SnapshotLedgerViewModel"
        case loanManagementViewModel = "LoanManagementViewModel"
        case possessionFormViewModel = "PossessionFormViewModel"
        case liabilityFormViewModel = "LiabilityFormViewModel"
        case settingsViewModel = "SettingsViewModel"
        case snapshotStructureViewModel = "SnapshotStructureViewModel"
        case transactionFormViewModel = "TransactionFormViewModel"
        case receivableCreateViewModel = "ReceivableCreateViewModel"
        case personSelectionViewModel = "PersonSelectionViewModel"
        case receivableDetailViewModel = "ReceivableDetailViewModel"
        case liabilityDetailViewModel = "LiabilityDetailViewModel"
    }
}
