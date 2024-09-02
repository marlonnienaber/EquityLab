//
//  DistributionChartViewModel.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 05.08.24.
//

import Foundation
import os
import SwiftUI
import CoreData

@Observable
class DistributionChartViewModel {
    @ObservationIgnored private static let loggerSubsystem = Bundle.main.bundleIdentifier ?? ""
    @ObservationIgnored private static let loggerCategory = String(describing: DistributionChartViewModel.self)
    @ObservationIgnored private static let logger = Logger(subsystem: loggerSubsystem, category: loggerCategory)

    @ObservationIgnored private unowned var repository: SnapshotRepository
    @ObservationIgnored private var distributionChartType: DistributionChartType
    @ObservationIgnored private var positionType: PositionType {
        switch distributionChartType {
        case .assetDistributionChart: .assets
        case .liabilityDistributionChart: .liabilities
        }
    }
    var unselectedColor: Color {
        switch distributionChartType {
        case .liabilityDistributionChart: Color("LiabilitiesUnselected")
        case .assetDistributionChart: Color("AssetsUnselected")
        }
    }
    var selectedColor: Color {
        switch distributionChartType {
        case .liabilityDistributionChart: Color("LiabilitiesSelected")
        case .assetDistributionChart: Color("AssetsSelected")
        }
    }
    var dashboardViewModel: DashboardViewModel
    var selectedCategory: DonutChartCategory?
    
    init(distributionChartType: DistributionChartType, 
         dashboardViewModel: DashboardViewModel,
         repository: SnapshotRepository = SnapshotRepository(context: ProductionCoreDataStack.shared.context)) {
        self.distributionChartType = distributionChartType
        self.dashboardViewModel = dashboardViewModel
        self.repository = repository
        self.selectedCategory = distributionCategories.first
    }
    
    var selectedCumulativeValue: Double?
    
    var distributionCategories: [DonutChartCategory] {
        guard let selectedSnapshot = dashboardViewModel.selectedSnapshot else { return [] }

        let poolValues = dashboardViewModel.computeValueByPool(for: positionType, using: selectedSnapshot)
        let categories = poolValues.keys.sorted().map{
            DonutChartCategory(value: poolValues[$0]!, name: $0)
        }
        
        return categories
    }
    
    func getSelectedCategoryValueString() -> String {
        guard let selectedCategory else { return "" }
        return LocalizedCurrencyFormatter.shared.string(from: selectedCategory.value as NSNumber) ?? ""
    }
    
    func getSelectedCategoryPercentageString() -> String {
        guard let selectedCategory, let selectedSnapshot = dashboardViewModel.selectedSnapshot else { return "" }
        let percentage = (selectedCategory.value / computeTotalValue(for: selectedSnapshot)) * 100
        return String(format: "%.1f", percentage) + "%"
    }
    
    func computeTotalValue(for snapshot: Snapshot) -> Double {
        let positions: [Position]
        if distributionChartType == .assetDistributionChart {
            positions = repository.fetchAssetPositions(of: snapshot)
        } else {
            positions = repository.fetchLiabilityPositions(of: snapshot)
        }
        let totalValue = positions.map{ $0.value }.reduce(0, +)
        return totalValue
    }
    
    func setSelectedCategoryForNewCumulativeValue(cumulativeValue: Double) {
        var cumulativeTotal = 0.0
        let _ = distributionCategories.first { category in
            cumulativeTotal += Double(category.value)
            if cumulativeValue <= cumulativeTotal {
                selectedCategory = category
                return true
            }
            return false
        }
    }
    
    func setSelectedCategoryForNewSnapshot() {
        selectedCategory = distributionCategories.first(where: {$0.name == selectedCategory?.name})
    }
}

enum DistributionChartType {
    case liabilityDistributionChart
    case assetDistributionChart
}

struct DonutChartCategory: Identifiable {
    let value: Double
    let name: String
    let id = UUID()
}
