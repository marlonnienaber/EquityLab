import CoreData
import os
import SwiftUI
import Observation
import Combine

@Observable
class DashboardViewModel {
    @ObservationIgnored private static let logger = Logger(subsystem: .dashboardTab, component: .dashboardViewModel)
    
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()
    
    @ObservationIgnored private let snapshotAnalyzer: SnapshotAnalyzerNew
    
    @ObservationIgnored private var equityValueCache = [Snapshot:Decimal]()
    
    @ObservationIgnored private var assetValueCache = [Snapshot:Decimal]()
    
    @ObservationIgnored private var liabilityValueCache = [Snapshot:Decimal]()
    
    
    var selectedSnapshotDetailView: SnapshotDetailView = .balanceDetailView
    
    var selectedSnapshotDetailPage: SnapshotDetailPage = .changeDetailPage
    
    
    init(snapshotRepository: SnapshotRepositoryNew = .production) {
        Self.logger.debug("DashboardViewModel()")
        self.snapshotRepository = snapshotRepository
        self.snapshotAnalyzer = SnapshotAnalyzerNew(repository: snapshotRepository)
        
        self.selectedAssetDistributionCategory = getDistributionCategories(for: .assets).first
        self.selectedLiabilityDistributionCategory = getDistributionCategories(for: .liabilities).first
        
        snapshotRepository.$snapshots
            .sink { [weak self] newSnapshots in
                guard let self else { return }
                snapshots = newSnapshots.sorted{ $0.date ?? .distantFuture < $1.date ?? .distantFuture }
                for snapshot in snapshots {
                    equityValueCache[snapshot] = snapshotAnalyzer.calculateEquityValue(for: snapshot)
                }
                selectedSnapshot = snapshots.last
            }
            .store(in: &cancellables)
    }
    
    
    private func getAssetValue(of snapshot: Snapshot) -> Decimal {
        if let assetValue = assetValueCache[snapshot] {
            return assetValue
        } else {
            let assetValue = snapshotAnalyzer.calculateAssetValue(for: snapshot)
            assetValueCache[snapshot] = assetValue
            return assetValue
        }
    }

    private func getLiabilityValue(of snapshot: Snapshot) -> Decimal {
        if let liabilityValue = liabilityValueCache[snapshot] {
            return liabilityValue
        } else {
            let liabilityValue = snapshotAnalyzer.calculateLiabilityValue(for: snapshot)
            liabilityValueCache[snapshot] = liabilityValue
            return liabilityValue
        }
    }

    func getEquityValue(of snapshot: Snapshot) -> Decimal {
        Self.logger.debug("getEquityValue(of snapshot)")
        return equityValueCache[snapshot] ?? 0.0
    }

    func initializeSelectedSnapshot() {
        Self.logger.debug("initializeSelectedSnapshot()")
        if let selectedSnapshot, !snapshots.contains(selectedSnapshot){
            self.selectedSnapshot = snapshots.last
        }
    }
    
    private func computeValueByPool(for positionType: PositionType, using snapshot: Snapshot) -> [String:Decimal] {
        Self.logger.debug("computeValueByPool(for positionType, using snapshot)")
        if positionType == .assets {
            let assetPositions = snapshotRepository.assetPositions.filter{ $0.snapshot == snapshot }
            return Dictionary(grouping: assetPositions, by: { $0.poolName }).mapValues { array in
                array.map { $0.value.decimalValue }.reduce(0, +)
            }
        } else {
            let liabilityPositions = snapshotRepository.liabilityPositions.filter{ $0.snapshot == snapshot }
            return Dictionary(grouping: liabilityPositions, by: { $0.poolName }).mapValues { array in
                array.map { $0.value.decimalValue }.reduce(0, +)
            }
        }
    }
    
    
    
    /// Equity Chart Logic
    
    @ObservationIgnored private var snapshotRepository: SnapshotRepositoryNew
    
    private var snapshots = [Snapshot]()
    
    var filteredSnapshots: [Snapshot] {
        Self.logger.debug("filteredSnapshots")
        let calendar = Calendar.current
        let today = Date.now.startOfDay
        switch selectedTimeHorizon {
        case .threeMonths:
            let threeMonthsAgo = calendar.date(byAdding: .month, value: -3, to: today)!
            return snapshots.filter{ $0.date.isNotNil }.filter{ $0.date! >= threeMonthsAgo }
        case .sixMonths:
            let sixMonthsAgo = calendar.date(byAdding: .month, value: -6, to: today)!
            return snapshots.filter{ $0.date.isNotNil }.filter{ $0.date! >= sixMonthsAgo }
        case .eighteenMonths:
            let eighteenMonthsAgo = calendar.date(byAdding: .month, value: -18, to: today)!
            return snapshots.filter{ $0.date.isNotNil }.filter{ $0.date! >= eighteenMonthsAgo }
        case .all:
            return snapshots
        }
    }
    
    var selectedDate: Date? {
        get {
            selectedSnapshot?.date
        }
        set {
            if let newValue {
                selectedSnapshot = snapshots.filter { snapshot in
                    snapshot.date.isNotNil
                }.min{ firstSnapshot, secondSnapshot in
                    firstSnapshot.date!.isCloser(to: newValue, than: secondSnapshot.date!)
                }
            }
        }
    }
    
    var selectedSnapshot: Snapshot?
    
    var noSnapshotsAvailable: Bool {
        Self.logger.debug("noSnapshotsAvailable")
        return snapshots.isEmpty
    }
    
    var selectedTimeHorizon: TimeHorizon = .all
    
    
    
    /// Balance View Logic
    
    func getBalanceViewModel(for snapshot: Snapshot) -> BalanceViewModel {
        Self.logger.debug("getBalanceViewModel(for snapshot)")
        return BalanceViewModel(
            assetValueString: LocalizedCurrencyFormatter.shared.string(from: getAssetValue(of: snapshot).nsDecimalNumberValue) ?? "",
            liabilityValueString: LocalizedCurrencyFormatter.shared.string(from: getLiabilityValue(of: snapshot).nsDecimalNumberValue) ?? "",
            equityValueString: LocalizedCurrencyFormatter.shared.string(from: getEquityValue(of: snapshot).nsDecimalNumberValue) ?? ""
        )
    }
    
    
    
    /// Distribution Charts Logic
    
    var assetDistributionChartCategories: [DonutChartCategory] {
        getDistributionCategories(for: .assets)
    }
    
    var selectedAssetDistributionCategory: DonutChartCategory?
    
    var selectedAssetCumulativeValue: Decimal?
    
    var showAssetDistributionChartPopover: Bool = false
    
    var noPositiveAssetDistributionCategoriesRecorded: Bool {
        noPositiveDistributionCategoriesRecordedForThisSnapshot(for: .assets)
    }
    
    
    var liabilityDistributionChartCategories: [DonutChartCategory] {
        getDistributionCategories(for: .liabilities)
    }
    
    var selectedLiabilityDistributionCategory: DonutChartCategory?
    
    var selectedLiabilityCumulativeValue: Decimal?
    
    var showLiabilityDistributionChartPopover: Bool = false
    
    var noPositiveLiabilityDistributionCategoriesRecorded: Bool {
        noPositiveDistributionCategoriesRecordedForThisSnapshot(for: .liabilities)
    }
    
    
    private func noPositiveDistributionCategoriesRecordedForThisSnapshot(for positionType: PositionType) -> Bool {
        Self.logger.debug("noPositiveDistributionCategoriesRecordedForThisSnapshot")
        return getDistributionCategories(for: positionType).first(where: { $0.value > 0.0 }) == nil
    }
    
    private func getDistributionCategories(for positionType: PositionType) -> [DonutChartCategory] {
        Self.logger.debug("getDistributionCategories(for positionsType)")
        guard let selectedSnapshot else { return [] }
        let totalValue = switch positionType {
        case .assets: snapshotAnalyzer.calculateAssetValue(for: selectedSnapshot)
        case .liabilities: snapshotAnalyzer.calculateLiabilityValue(for: selectedSnapshot)
        }
        let poolValues = computeValueByPool(for: positionType, using: selectedSnapshot)
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
    
    func setSelectedDistributionCategory(for positionType: PositionType, with cumulativeValue: Decimal) {
        Self.logger.debug("setSelectedDistributionCategoryFor(for positionType, with cumulativeValue)")
        var distributionCategories = getDistributionCategories(for: positionType)
        var cumulativeTotal: Decimal = 0
        var category: DonutChartCategory
        repeat {
            category = distributionCategories.removeFirst()
            cumulativeTotal += category.value
        } while cumulativeValue > cumulativeTotal
        
        switch positionType {
        case .assets: selectedAssetDistributionCategory = category
        case .liabilities: selectedLiabilityDistributionCategory = category
        }
    }
    
    func setSelectedDistributionCategoryOnNewSnapshot() {
        Self.logger.debug("setSelectedDistributionCategory()")
        switch selectedSnapshotDetailView {
        case .assetDetailView:
            let assetDistributionCategories = getDistributionCategories(for: .assets)
            selectedAssetDistributionCategory = assetDistributionCategories.first(where: {$0 == selectedAssetDistributionCategory}) ?? assetDistributionCategories.first
        case .liabilityDetailView:
            let liabilityDistributionCategories = getDistributionCategories(for: .liabilities)
            selectedLiabilityDistributionCategory = liabilityDistributionCategories.first(where: {$0 == selectedLiabilityDistributionCategory}) ?? liabilityDistributionCategories.first
        default: return
        }
    }
    
    
    
    /// Change Charts Logic
    
    var assetChangeChartCategories: [BarChartCategory] {
        Self.logger.debug("assetChangeChartCategories")
        return computeChangeChartCategories(for: .assets)
    }
    
    var maxAssetChangePercentage: Decimal {
        Self.logger.debug("maxAssetChangePercentage")
        return assetChangeChartCategories.map{ abs($0.change) }.max() ?? 0
    }
    
    var noAssetChangesToLastSnapshot: Bool {
        Self.logger.debug("noAssetChangesToLastSnapshot")
        return assetChangeChartCategories.first(where: { $0.change != 0 }).isNil
    }
    
    
    var liabilityChangeChartCategories: [BarChartCategory] {
        Self.logger.debug("liabilityChangeChartCategories")
        return computeChangeChartCategories(for: .liabilities)
    }
    
    var maxLiabilityChangePercentage: Decimal {
        Self.logger.debug("maxLiabilityChangePercentage")
        return liabilityChangeChartCategories.map{ abs($0.change) }.max() ?? 0
    }

    var noLiabilityChangesToLastSnapshot: Bool {
        Self.logger.debug("noLiabilityChangesToLastSnapshot")
        return liabilityChangeChartCategories.first(where: { $0.change != 0 }).isNil
    }
    
    
    private func computeChangeChartCategories(for positionType: PositionType) -> [BarChartCategory] {
        guard let selectedSnapshot, let beforeShot = computeSnapshotBeforeSelectedSnapshot() else { return [] }
        
        let poolValuesSelectedShot = computeValueByPool(for: positionType, using: selectedSnapshot)
        let poolValuesBeforeShot = computeValueByPool(for: positionType, using: beforeShot)
        
        let beforeShotKeySet = Set(poolValuesBeforeShot.keys)
        
        var changedPoolValues = poolValuesSelectedShot.filter{ beforeShotKeySet.contains($0.key) }
        
        changedPoolValues.forEach{ key,value in
            let beforeValue = poolValuesBeforeShot[key]!
            let changePercentage = beforeValue == 0 ? 0 : ((value / beforeValue) - 1) * 100
            changedPoolValues[key] = changePercentage
        }
        let changeCategories = changedPoolValues.map{ BarChartCategory(change: $0.value, name: $0.key) }
        return changeCategories
    }
    
    func computeSnapshotBeforeSelectedSnapshot() -> Snapshot? {
        Self.logger.debug("computeSnapshotBeforeSelectedSnapshot()")
        if let selectedDate {
            if let index = filteredSnapshots.firstIndex(where: {$0.date == selectedDate} ) {
                return index == 0 ? nil : filteredSnapshots[index - 1]
            }
        }
        return nil
    }
}

enum PositionType {
    case assets
    case liabilities
}

enum TimeHorizon: String, CaseIterable, Identifiable {
    case threeMonths = "3M"
    case sixMonths = "6M"
    case eighteenMonths = "18M"
    case all = "ALL"

    var id: String { self.rawValue }
}

enum SnapshotDetailView: String, CaseIterable, Identifiable {
    case balanceDetailView = "Balance"
    case assetDetailView = "Assets"
    case liabilityDetailView = "Liabilities"
    var id: String { self.rawValue }
}

enum SnapshotDetailPage {
    case changeDetailPage
    case distributionDetailPage
}

extension Date {
    func isCloser(to referenceDate: Date, than otherDate: Date) -> Bool {
        self.computeAbsoluteMinuteDifference(to: referenceDate) < otherDate.computeAbsoluteMinuteDifference(to: referenceDate)
    }
    
    func computeAbsoluteMinuteDifference(to otherDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.minute], from: self, to: otherDate)
        return abs(components.minute!)
    }
}

extension URL: Identifiable {
    public var id: String {
        absoluteString
    }
}

struct BalanceViewModel {
    let assetValueString: String
    let liabilityValueString: String
    let equityValueString:String
}

struct DonutChartCategory: Equatable, Hashable {
    var pools: [Pool]
    var value: Decimal {
        pools.map{ $0.value }.reduce(0, +)
    }
    var percentage: Decimal {
        pools.map{ $0.percentage }.reduce(0, +)
    }
}

struct Pool: Equatable, Hashable {
    let value: Decimal
    let name: String
    let percentage: Decimal
    
    static func == (lhs: Pool, rhs: Pool) -> Bool {
        lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

struct BarChartCategory {
    let change: Decimal
    let name: String
}
