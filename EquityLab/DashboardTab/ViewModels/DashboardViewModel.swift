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
    @ObservationIgnored private var assetValues = [Snapshot:Double]()
    @ObservationIgnored private var liabilityValues = [Snapshot:Double]()
    var selectedSnapshot: Snapshot?
    
    override init() {
        let context = DataService.shared.persistentContainer.viewContext
        self.context = context
        
        let request = ObservingFetchRequest<Snapshot>(entityName: "Snapshot")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Snapshot.date, ascending: true)]
        request.observedRelationships = ["liabilities"]
        fetchedResultsController = ObservingFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
            self.unfilteredSnapshots = fetchedResultsController.fetchedObjects as! [Snapshot]
            for shot in unfilteredSnapshots {
                equityValues[shot] = calculateEquityValue(for: shot)
            }
        } catch {}
        self.selectedSnapshot = unfilteredSnapshots.last
    }
    
    private func calculateEquityValue(for snapshot: Snapshot) -> Double {
        let totalLiabilityValue = calculateLiabilityValue(for: snapshot)
        let totalAssetValue = calculateAssetValue(for: snapshot)
        return totalAssetValue - totalLiabilityValue
    }
    private func calculateAssetValue(for snapshot: Snapshot) -> Double {
        let assetPositions = (try? context.fetch(snapshot.getAssetPositionRequest())) ?? []
        return assetPositions.map{ $0.value }.reduce(0, +)
    }
    private func calculateLiabilityValue(for snapshot: Snapshot) -> Double {
        let liabilityPositions = (try? context.fetch(snapshot.getLiabilityPositionRequest())) ?? []
        return liabilityPositions.map{ $0.value }.reduce(0, +)
    }
    
    func equityValue(of snapshot: Snapshot) -> Double {
        equityValues[snapshot] ?? 0.0
    }
    func assetValue(of snapshot: Snapshot) -> Double {
        if let assetValue = assetValues[snapshot] {
            return assetValue
        } else {
            let assetValue = calculateAssetValue(for: snapshot)
            assetValues[snapshot] = assetValue
            return assetValue
        }
    }
    func liabilityValue(of snapshot: Snapshot) -> Double {
        if let liabilityValue = liabilityValues[snapshot] {
            return liabilityValue
        } else {
            let liabilityValue = calculateLiabilityValue(for: snapshot)
            liabilityValues[snapshot] = liabilityValue
            return liabilityValue
        }
    }
    
    func initializeSelectedSnapshot() {
        if let selectedSnapshot, !unfilteredSnapshots.contains(selectedSnapshot){
            self.selectedSnapshot = unfilteredSnapshots.last
        }
    }
    
    var selectedSnapshotDetailView: SnapshotDetailView = .balanceDetailView
    var currentPageAssetDetailView = 0
    
    func computeValueByPool(for positionType: PositionType, using snapshot: Snapshot) -> [String:Double] {
        if positionType == .assets {
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
    
    func computeShotBeforeSelectedShot() -> Snapshot? {
        if let selectedDate {
            if let index = filteredSnapshots.firstIndex(where: {$0.date == selectedDate} ) {
                return index == 0 ? nil : filteredSnapshots[index - 1]
            }
        }
        return nil
    }
    
    // MARK: members NetWorthChart
    var selectedTimeHorizon: TimeHorizon = .all
    var unfilteredSnapshots = [Snapshot]()
    var filteredSnapshots: [Snapshot] {
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
