
import SwiftUI
import os

@Observable
class ChangeChartViewModel {
    @ObservationIgnored private static let logger = Logger(subsystem: .dashboardTab, component: .changeChartViewModel)
    @ObservationIgnored private var changeChartType: ChangeChartType
    @ObservationIgnored private var positionType: PositionType {
        switch changeChartType {
        case .assetChangeChart: .assets
        case .liabilityChangeChart: .liabilities
        }
    }
    var dashboardViewModel: DashboardViewModel
    var changeCategories: [BarChartCategory] {
        Self.logger.debug("changeCategories")
        guard let selectedShot = dashboardViewModel.selectedSnapshot, let beforeShot = computeSnapshotBeforeSelectedSnapshot() else { return [] }
        
        let poolValuesSelectedShot = dashboardViewModel.computeValueByPool(for: positionType, using: selectedShot)
        let poolValuesBeforeShot = dashboardViewModel.computeValueByPool(for: positionType, using: beforeShot)
        
        let beforeShotKeySet = Set(poolValuesBeforeShot.keys)
        
        var changedPoolValues = poolValuesSelectedShot.filter{ beforeShotKeySet.contains($0.key) }
        
        changedPoolValues.forEach{ key,value in
            let beforeValue = poolValuesBeforeShot[key]!
            var changePercentage = beforeValue == 0 ? 0 : ((value / beforeValue) - 1) * 100
            changedPoolValues[key] = changePercentage
        }
        let changeCategories = changedPoolValues.map{ BarChartCategory(change: $0.value, name: $0.key) }
        return changeCategories
    }
    var maxChangePercentage: Decimal {
        Self.logger.debug("maxChangePercentage")
        return changeCategories.map{ abs($0.change) }.max() ?? 0
    }
    var changeChartColor: Color {
        switch changeChartType {
        case .liabilityChangeChart: .liabilitiesUnselected
        case .assetChangeChart: .assetsUnselected
        }
    }
    var noChangesToLastSnapshot: Bool {
        Self.logger.debug("noChangesToLastSnapshot")
        return changeCategories.first(where: { $0.change != 0 }).isNil
    }
    
    
    init(changeChartType: ChangeChartType, dashboardViewModel: DashboardViewModel) {
        Self.logger.debug("ChangeChartViewModel()")
        self.changeChartType = changeChartType
        self.dashboardViewModel = dashboardViewModel
    }
    
    
    func computeSnapshotBeforeSelectedSnapshot() -> Snapshot? {
        Self.logger.debug("computeSnapshotBeforeSelectedSnapshot()")
        if let selectedDate = dashboardViewModel.selectedDate {
            if let index = dashboardViewModel.filteredSnapshots.firstIndex(where: {$0.date == selectedDate} ) {
                return index == 0 ? nil : dashboardViewModel.filteredSnapshots[index - 1]
            }
        }
        return nil
    }
}

enum ChangeChartType {
    case liabilityChangeChart
    case assetChangeChart
}

struct BarChartCategory {
    let change: Decimal
    let name: String
}
