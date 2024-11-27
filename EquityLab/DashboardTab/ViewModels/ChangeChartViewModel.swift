
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
    var changeChartColor: Color {
        switch changeChartType {
        case .liabilityChangeChart: .liabilitiesUnselected
        case .assetChangeChart: .assetsUnselected
        }
    }
    var changeCategories: [BarChartCategory] {
        guard let selectedShot = dashboardViewModel.selectedSnapshot, let beforeShot = computeShotBeforeSelectedShot() else { return [] }
        
        let poolValuesSelectedShot = dashboardViewModel.computeValueByPool(for: positionType, using: selectedShot)
        let poolValuesBeforeShot = dashboardViewModel.computeValueByPool(for: positionType, using: beforeShot)
        
        let beforeShotKeySet = Set(poolValuesBeforeShot.keys)
        
        var changedPoolValues = poolValuesSelectedShot.filter{ beforeShotKeySet.contains($0.key)}
        
        changedPoolValues.forEach{ key,value in
            var changePercentage = ((value / poolValuesBeforeShot[key]!) - 1) * 100
            if changePercentage.isNaN || changePercentage.isInfinite {
                changePercentage = 0.0
            }
            changedPoolValues[key] = changePercentage
        }
        let changeCategories = changedPoolValues.map{ BarChartCategory(change: $0.value.doubleValue, name: $0.key) }
        return changeCategories
    }
    var noChangesToLastSnapshot: Bool {
        changeCategories.first(where: { $0.change != 0.0 }) == nil
    }
    var maxChangePercentage: Double {
        let maxChange = changeCategories.map{ abs($0.change) }.max()
        guard let maxChange, !maxChange.isNaN, maxChange.isFinite else { return 0.0 }
        return maxChange
    }
    
    
    init(changeChartType: ChangeChartType, dashboardViewModel: DashboardViewModel) {
        self.changeChartType = changeChartType
        self.dashboardViewModel = dashboardViewModel
    }
    
    
    func computeShotBeforeSelectedShot() -> Snapshot? {
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

struct BarChartCategory: Identifiable {
    let change: Double
    let name: String
    let id = UUID()
}
