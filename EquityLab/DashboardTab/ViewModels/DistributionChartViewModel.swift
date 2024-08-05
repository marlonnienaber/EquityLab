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
    @ObservationIgnored private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "",
        category: String(describing: DistributionChartViewModel.self)
    )
    @ObservationIgnored private var context: NSManagedObjectContext
    @ObservationIgnored private var distributionChartType: DistributionChartType
    var dashboardViewModel: DashboardViewModel
    var selectedCategory: DonutChartCategory?
    
    init(distributionChartType: DistributionChartType, dashboardViewModel: DashboardViewModel) {
        self.distributionChartType = distributionChartType
        self.dashboardViewModel = dashboardViewModel
        let context = DataService.shared.persistentContainer.viewContext
        self.context = context
        self.selectedCategory = distributionCategories.first
    }
    
    var selectedCumulativeValue: Double?
    
    var distributionCategories: [DonutChartCategory] {
        Self.logger.trace("comp. property assetDistributionCategories was called")
        guard let selectedSnapshot = dashboardViewModel.selectedSnapshot else { return [] }
        Self.logger.trace("computing assetDistributionCategories")
        var colorQueue = ColorQueue(colors: [Color("desert"), Color("midnight"), Color("dawn"), Color("coral")])
        
        let poolValues = computeValueByPool(for: distributionChartType, using: selectedSnapshot)
        let categories = poolValues.keys.sorted().map{
            DonutChartCategory(value: poolValues[$0]!, name: $0, color: colorQueue.dequeue())
        }
        
        Self.logger.trace("categories created from assetPositions:")
        for category in categories {
            Self.logger.trace("\(category.name) (color: \(category.color) | value: \(category.value)")
        }
        
        return categories
    }
    
    func getSelectedCategoryValueString() -> String {
        guard let selectedCategory else { return "" }
        return LocalizedCurrencyFormatter.shared.string(from: selectedCategory.value as NSNumber) ?? ""
    }
    
    func getSelectedCategoryPercentageString() -> String {
        guard let selectedCategory, let selectedSnapshot = dashboardViewModel.selectedSnapshot else { return "" }
        Self.logger.trace("computing percentage-String for category \(selectedCategory.name)")
        let percentage = (selectedCategory.value / computeTotalValue(for: selectedSnapshot)) * 100
        Self.logger.trace("computed percentage: \(percentage)")
        return String(format: "%.1f", percentage) + "%"
    }
    
    func computeTotalValue(for snapshot: Snapshot) -> Double {
        Self.logger.trace("computing total asset value for snapshot \(snapshot.date)")
        let positions: [Position]
        if distributionChartType == .assetDistributionChart {
            positions = (try? context.fetch(snapshot.getAssetPositionRequest())) ?? []
        } else {
            positions = (try? context.fetch(snapshot.getLiabilityPositionRequest())) ?? []
        }
        let totalValue = positions.map{ $0.value }.reduce(0, +)
        Self.logger.trace("computed total asset value: \(totalValue)")
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
    
    func computeValueByPool(for distributionChartType: DistributionChartType, using snapshot: Snapshot) -> [String:Double] {
        if distributionChartType == .assetDistributionChart {
            let assetPositions = (try? context.fetch(snapshot.getAssetPositionRequest())) ?? []
            return Dictionary(grouping: assetPositions, by: { $0.poolName }).mapValues { array in
                array.map { $0.value }.reduce(0, +)
            }
        } else {
            let liabilityPositions = (try? context.fetch(snapshot.getLiabilityPositionRequest())) ?? []
            return Dictionary(grouping: liabilityPositions, by: { $0.poolName }).mapValues { array in
                array.map { $0.value }.reduce(0, +)
            }
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
