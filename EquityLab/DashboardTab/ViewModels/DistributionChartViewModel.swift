import os
import SwiftUI
import CoreData
import Charts

@Observable
class DistributionChartViewModel {
    @ObservationIgnored private static let logger = Logger(subsystem: .dashboardTab, component: .distributionChartViewModel)

    @ObservationIgnored private var repository: SnapshotRepository
    @ObservationIgnored private let distributionChartType: DistributionChartType
    @ObservationIgnored private var positionType: PositionType {
        switch distributionChartType {
        case .assetDistributionChart: .assets
        case .liabilityDistributionChart: .liabilities
        }
    }
    
    var dashboardViewModel: DashboardViewModel
    var selectedCategory: DonutChartCategory?
    var selectedCumulativeValue: Double?
    var color: Color {
        switch distributionChartType {
        case .liabilityDistributionChart: Color("LiabilitiesUnselected")
        case .assetDistributionChart: Color("AssetsUnselected")
        }
    }
    var showPopover: Bool = false
    var distributionCategories: [DonutChartCategory] {
        Self.logger.debug("distributionCategories")
        guard let selectedSnapshot = dashboardViewModel.selectedSnapshot else { return [] }
        let totalValue = computeTotalValue(for: selectedSnapshot)
        let poolValues = dashboardViewModel.computeValueByPool(for: positionType, using: selectedSnapshot)
        var categories = poolValues.keys.sorted().map{
            DonutChartCategory(pools: [Pool(value: poolValues[$0]!, name: $0, percentage: (poolValues[$0]! / totalValue) * 100)])
        }
        categories.sort(by: {$0.percentage < $1.percentage})
        while categories.contains(where: {$0.percentage < 3.0} ) && categories.count > 1 {
            let smallestCategory = categories.removeFirst()
            smallestCategory.pools.forEach{
                categories[0].pools.append($0)
            }
        }
        return categories
    }

    
    init(
            distributionChartType: DistributionChartType,
            dashboardViewModel: DashboardViewModel,
            repository: SnapshotRepository = .production
        )
    {
        Self.logger.debug("DistributionChartViewModel()")
        self.distributionChartType = distributionChartType
        self.dashboardViewModel = dashboardViewModel
        self.repository = repository
        self.selectedCategory = distributionCategories.first
        self.repository.add(observer: self)
    }
    
    
    func getValueString(for pool: Pool) -> String {
        Self.logger.debug("getValueString(for pool)")
        return LocalizedCurrencyFormatter.shared.string(from: pool.value as NSNumber) ?? ""
    }
    
    func getPercentageString(for pool: Pool) -> String {
        Self.logger.debug("getPercentageString(for pool)")
        return String(format: "%.1f", pool.percentage) + " %"
    }
    
    func getSelectedCategoryPercentageString() -> String? {
        Self.logger.debug("getSelectedCategoryPercentageString()")
        guard let selectedCategory else { return nil }
        return String(format: "%.1f", selectedCategory.percentage) + " %"
    }
    
    func calculateFrameLength(for geometry: GeometryProxy) -> CGFloat {
        Self.logger.debug("calculateFrameLength(for geometry)")
        let maxWidth = geometry.size.width * 0.5
        let maxHeight = geometry.size.height
        return min(maxWidth, maxHeight)
    }
    
    func calculateOuterRadius(for geometry: GeometryProxy, and category: DonutChartCategory) -> MarkDimension {
        Self.logger.debug("calculateOuterRadius(for geometry)")
        let chartSize = calculateFrameLength(for: geometry)
        if chartSize >= 170 {
            return selectedCategory == category ? 95 : 82
        } else if chartSize >= 155 {
            return selectedCategory == category ? 80 : 73
        } else {
            return selectedCategory == category ? 70 : 63
        }
    }
    
    
    func computeTotalValue(for snapshot: Snapshot) -> Double {
        Self.logger.debug("computeTotalValue(for snapshot)")
        let positions: [Position]
        switch distributionChartType {
        case .assetDistributionChart: positions = repository.fetchAssetPositions(of: snapshot)
        case .liabilityDistributionChart: positions = repository.fetchLiabilityPositions(of: snapshot)
        }
        let totalValue = positions.map{ $0.value }.reduce(0, +)
        return totalValue
    }
    
    func setSelectedCategoryForNewCumulativeValue(cumulativeValue: Double) {
        Self.logger.debug("setSelectedCategoryForNewCumulativeValue(cumulativeValue)")
        var distributionCategories = distributionCategories
        var cumulativeTotal = 0.0
        var category: DonutChartCategory
        repeat {
            category = distributionCategories.removeFirst()
            cumulativeTotal += category.value
        } while cumulativeValue > cumulativeTotal
        selectedCategory = category
    }
    
    func setSelectedCategoryForNewSnapshot() {
        Self.logger.debug("setSelectedCategoryForNewSnapshot()")
        selectedCategory = distributionCategories.first(where: {$0 == selectedCategory}) ?? distributionCategories.first
    }
}

extension DistributionChartViewModel: SnapshotObserver {
    func notifyAfterSnapshotUpdate() {
        Self.logger.debug("notifyAfterSnapshotUpdate()")
        selectedCategory = distributionCategories.first
    }
}

enum DistributionChartType {
    case liabilityDistributionChart
    case assetDistributionChart
}

struct DonutChartCategory: Equatable, Hashable {
    var pools: [Pool]
    var value: Double {
        pools.map{ $0.value }.reduce(0, +)
    }
    var percentage: Double {
        pools.map{ $0.percentage }.reduce(0, +)
    }
}


struct Pool: Equatable, Hashable {
    let value: Double
    let name: String
    let percentage: Double
    
    static func == (lhs: Pool, rhs: Pool) -> Bool {
        lhs.name == rhs.name
    }
}
