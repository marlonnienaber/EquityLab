//
//  DashboardViewModel.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 15.07.24.
//

import Foundation
import CoreData
import os
import SwiftUI

@Observable
class DashboardViewModel: NSObject {
    // MARK: shared members
    @ObservationIgnored private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "",
        category: String(describing: DashboardViewModel.self)
    )
    @ObservationIgnored private var context: NSManagedObjectContext
    @ObservationIgnored private let fetchedResultsController: ObservingFetchedResultsController<Snapshot>
    @ObservationIgnored private var equityValues = [Snapshot:Double]()
    var selectedSnapshot: Snapshot?
    
    override init() {
        Self.logger.trace("creating DashboardVM")
        let context = DataService.shared.persistentContainer.viewContext
        self.context = context
        
        let request = ObservingFetchRequest<Snapshot>(entityName: "Snapshot")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Snapshot.date, ascending: false)]
        request.observedRelationships = ["liabilities"]
        fetchedResultsController = ObservingFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        fetchedResultsController.delegate = self
        Self.logger.trace("attempting to fetch Snapshots in dashboardVM")
        do {
            try fetchedResultsController.performFetch()
            self.unfilteredSnapshots = fetchedResultsController.fetchedObjects as! [Snapshot]
            for shot in unfilteredSnapshots {
                equityValues[shot] = calculateEquityValue(for: shot)
            }
            Self.logger.trace("fetched Snapshots in DashboardViewModel:")
            for shot in unfilteredSnapshots {
                Self.logger.trace("\(shot.date)")
            }
        } catch {
            Self.logger.trace("something went wrong fetching snapshot in DashboardVM")
        }
        
        self.selectedSnapshot = unfilteredSnapshots.last
        self.selectedAssetCategory = assetDistributionCategories.first
    }
    
    private func calculateEquityValue(for snapshot: Snapshot) -> Double {
        let liabilityPositions = (try? context.fetch(snapshot.getLiabilityPositionRequest())) ?? []
        let totalLiabilityValue = liabilityPositions.map{ $0.value }.reduce(0, +)
        let assetPositions = (try? context.fetch(snapshot.getAssetPositionRequest())) ?? []
        let totalAssetValue = assetPositions.map{ $0.value }.reduce(0, +)
        return totalAssetValue - totalLiabilityValue
    }
    
    func equityValue(of snapshot: Snapshot) -> Double {
        equityValues[snapshot] ?? 0.0
    }
    
    func initializeSelectedSnapshot() {
        if let selectedSnapshot, !unfilteredSnapshots.contains(selectedSnapshot){
            self.selectedSnapshot = unfilteredSnapshots.last
        }
    }
    
    var selectedSnapshotDetailView: SnapshotDetailView = .assetDetailView
    var currentPageAssetDetailView = 0
    
    
    // MARK: members NetWorthChart
    var selectedTimeHorizon: TimeHorizon = .all
    var unfilteredSnapshots = [Snapshot]()
    var filteredSnapshots: [Snapshot] {
        Self.logger.trace("returning filtered Snapshots:")
        for shot in unfilteredSnapshots {
            Self.logger.trace("\(shot.date)")
        }
        return unfilteredSnapshots
    }
    var selectedDate: Date? {
        get {
            selectedSnapshot?.date
        }
        set {
            if let newValue {
                selectedSnapshot = unfilteredSnapshots.min(by: {closestDayPredicate(firstShot: $0, secondShot: $1, selectedDate: newValue)} )
            }
        }
    }
    
    func closestDayPredicate(firstShot: Snapshot, secondShot: Snapshot, selectedDate: Date) -> Bool {
        computeAbsoluteMinuteDifference(first: firstShot.date, second: selectedDate) < computeAbsoluteMinuteDifference(first: secondShot.date, second: selectedDate) ? true : false
    }
    
    func computeAbsoluteMinuteDifference(first: Date, second: Date) -> Int {
        let components = Calendar.current.dateComponents([.minute], from: first, to: second)
        return abs(components.minute!)
    }
    
    func dateFallsIntoLastMonth(date: Date, amount: Int) -> Bool {
        let today = Date.now
        let calendar = Calendar.current
        let dateMonthsAgo = calendar.date(byAdding: .month, value: -amount, to: today) ?? Date()
        return date >= dateMonthsAgo && date <= today
    }
    
    
    // MARK: members DistributionChart
    var assetDistributionCategories: [DonutChartCategory] {
        Self.logger.trace("comp. property assetDistributionCategories was called")
        guard let selectedSnapshot else { return [] }
        Self.logger.trace("computing assetDistributionCategories")
        var colorQueue = ColorQueue(colors: [Color("desert"), Color("midnight"), Color("dawn"), Color("coral")])
        
        let poolValues = computeValueByPool(for: .assetDistributionChart, using: selectedSnapshot)
        let categories = poolValues.keys.sorted().map{
            DonutChartCategory(value: poolValues[$0]!, name: $0, color: colorQueue.dequeue())
        }
        
        Self.logger.trace("categories created from assetPositions:")
        for category in categories {
            Self.logger.trace("\(category.name) (color: \(category.color) | value: \(category.value)")
        }
        
        return categories
    }
    var selectedAssetCategory: DonutChartCategory?
    var selectedCumulativeValue: Double?
    
    func getSelectedCategoryValueString() -> String {
        guard let selectedAssetCategory else { return "" }
        return LocalizedCurrencyFormatter.shared.string(from: selectedAssetCategory.value as NSNumber) ?? ""
    }
    
    func getSelectedCategoryPercentageString() -> String {
        guard let selectedAssetCategory, let selectedSnapshot else { return "" }
        Self.logger.trace("computing percentage-String for category \(selectedAssetCategory.name)")
        let percentage = (selectedAssetCategory.value / computeTotalAssetValue(for: selectedSnapshot)) * 100
        Self.logger.trace("computed percentage: \(percentage)")
        return String(format: "%.1f", percentage) + "%"
    }
    
    func computeTotalAssetValue(for snapshot: Snapshot) -> Double {
        Self.logger.trace("computing total asset value for snapshot \(snapshot.date)")
        let assetPositions = (try? context.fetch(snapshot.getAssetPositionRequest())) ?? []
        let totalAssetValue = assetPositions.map{ $0.value }.reduce(0, +)
        Self.logger.trace("computed total asset value: \(totalAssetValue)")
        return totalAssetValue
    }
    
    func setSelectedCategoryForNewCumulativeValue(cumulativeValue: Double) {
        var cumulativeTotal = 0.0
        let _ = assetDistributionCategories.first { assetCategory in
            cumulativeTotal += Double(assetCategory.value)
            if cumulativeValue <= cumulativeTotal {
                selectedAssetCategory = assetCategory
                return true
            }
            return false
        }
    }
    
    func setSelectedCategoryForNewSnapshot() {
        selectedAssetCategory = assetDistributionCategories.first(where: {$0.name == selectedAssetCategory?.name})
    }
    
    
    // MARK: members ChangeChart
    var assetChangeCategories: [BarChartCategory] {
        guard let selectedShot = selectedSnapshot, let beforeShot = computeShotBeforeSelectedShot() else {
            return []
        }
        
        let poolValuesSelectedShot = computeValueByPool(for: .assetDistributionChart, using: selectedShot)
        let poolValuesBeforeShot = computeValueByPool(for: .assetDistributionChart, using: beforeShot)
        
        let beforeShotKeySet = Set(poolValuesBeforeShot.keys)
        
        var changedPoolValues = poolValuesSelectedShot.filter{ beforeShotKeySet.contains($0.key)}
        
        changedPoolValues.forEach{ key,value in
            changedPoolValues[key] = ((value / poolValuesBeforeShot[key]!) - 1) * 100
        }
        
        return changedPoolValues.map{ BarChartCategory(change: $0.value, name: $0.key, color: Color("desert")) }
    }
    var maxAssetChangePercentage: Double {
        assetChangeCategories.map{ abs($0.change) }.max() ?? 0.0
    }
    
    func computeShotBeforeSelectedShot() -> Snapshot? {
        if let selectedDate {
            if let index = filteredSnapshots.firstIndex(where: {$0.date == selectedDate} ) {
                return index == 0 ? nil : filteredSnapshots[index - 1]
            }
        }
        return nil
    }
    
    func computeValueByPool(for positionType: DistributionChartType, using snapshot: Snapshot) -> [String:Double] {
        if positionType == .assetDistributionChart {
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
}


// MARK: change management
extension DashboardViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        do {
            try fetchedResultsController.performFetch()
            self.unfilteredSnapshots = fetchedResultsController.fetchedObjects as! [Snapshot]
            for shot in unfilteredSnapshots {
                equityValues[shot] = calculateEquityValue(for: shot)
            }
        } catch {}
    }
}


// MARK: utilities
enum TimeHorizon: String, CaseIterable, Identifiable {
    case threeMonths = "3M"
    case sixMonths = "6M"
    case eighteenMonths = "18M"
    case all = "ALL"

    var id: String { self.rawValue }
}

enum SnapshotDetailView: String, CaseIterable, Identifiable {
    case assetDetailView = "Asset Details"
    case liabilityDetailView = "Liability Details"
    var id: String { self.rawValue }
}

struct DonutChartCategory: Identifiable {
    let value: Double
    let name: String
    let id = UUID()
    let color: Color
}

struct BarChartCategory: Identifiable {
    let change: Double
    let name: String
    let color: Color
    let id = UUID()
}

struct ColorQueue {
    private var colors: [Color]
    private var currentIndex: Int = 0
    
    init(colors: [Color]) {
        self.colors = colors
    }
    
    mutating func dequeue() -> Color {
        let color = colors[currentIndex]
        currentIndex = (currentIndex + 1) % colors.count
        return color
    }
}
