//
//  ChangeChartViewModel.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 06.08.24.
//

import Foundation
import SwiftUI
import os

@Observable
class ChangeChartViewModel {
    @ObservationIgnored private var changeChartType: ChangeChartType
    @ObservationIgnored private var positionType: PositionType {
        switch changeChartType {
        case .assetChangeChart: .assets
        case .liabilityChangeChart: .liabilities
        }
    }
    @ObservationIgnored private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "",
        category: String(describing: ChangeChartViewModel.self)
    )
    var dashboardViewModel: DashboardViewModel
    
    init(changeChartType: ChangeChartType, dashboardViewModel: DashboardViewModel) {
        self.changeChartType = changeChartType
        self.dashboardViewModel = dashboardViewModel
    }
    
    var changeCategories: [BarChartCategory] {
        guard let selectedShot = dashboardViewModel.selectedSnapshot, let beforeShot = computeShotBeforeSelectedShot() else { return [] }
        
        let poolValuesSelectedShot = dashboardViewModel.computeValueByPool(for: positionType, using: selectedShot)
        let poolValuesBeforeShot = dashboardViewModel.computeValueByPool(for: positionType, using: beforeShot)
        
        let beforeShotKeySet = Set(poolValuesBeforeShot.keys)
        
        var changedPoolValues = poolValuesSelectedShot.filter{ beforeShotKeySet.contains($0.key)}
        
        changedPoolValues.forEach{ key,value in
            changedPoolValues[key] = ((value / poolValuesBeforeShot[key]!) - 1) * 100
        }
        let changeCategories = changedPoolValues.map{ BarChartCategory(change: $0.value, name: $0.key, color: Color("desert")) }
        return changeCategories
    }
    
    var maxChangePercentage: Double {
        changeCategories.map{ abs($0.change) }.max() ?? 0.0
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
