//
//  SnapshotLedger.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 15.07.24.
//

import SwiftUI

struct SnapshotLedger: View {
    @State private var viewModel = SnapshotLedgerViewModel()
    @State private var activeSheet: SnapshotSheetType? = nil
    
    var body: some View {
        NavigationView {
            LedgerContent
                .navigationTitle("Snapshots")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                            .disabled(viewModel.years.isEmpty)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button (action: {activeSheet = .addSheet} ){
                            Image(systemName: "plus")
                        }
                    }
                }
        }.sheet(item: $activeSheet) { activeSheet in
            switch activeSheet {
            case .addSheet: SnapshotForm(viewModel: SnapshotFormViewModel(), snapshotLedgerActiveSheet: $activeSheet)
            case .updateSheet(let shot): SnapshotForm(viewModel: SnapshotFormViewModel(snapshot: shot), snapshotLedgerActiveSheet: $activeSheet)
            }
        }
    }
    
    @ViewBuilder 
    var LedgerContent: some View {
        if viewModel.years.isEmpty {
            NoSnapshotDataView
        } else {
            List {
                ForEach(viewModel.years, id: \.self) { year in
                    Section(String(year)) {
                        sectionContent(for: year, containing: viewModel.snapshots(fallingInto: year))
                    }
                }
            }
        }
    }
    
    var NoSnapshotDataView: some View {
        VStack {
            Image(systemName: "tray.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
            Text("no snapshots saved")
        }
        .foregroundColor(Color.primary.opacity(0.4))
    }
    
    func sectionContent(for year: Int, containing snapshots: [Snapshot]) -> some View {
        ForEach(snapshots) { snapshot in
            SnapshotListCell(for: snapshot)
        }
        .onDelete{ indexSet in
            viewModel.deleteSnapshots(in: year, for: indexSet)
        }
    }
    
    @ViewBuilder 
    func SnapshotListCell(for snapshot: Snapshot) -> some View {
        if let equityStringRepresentation = LocalizedCurrencyFormatter.shared.string(from: viewModel.equityValue(of: snapshot)),
           let date = snapshot.date {
            Button {
                activeSheet = .updateSheet(snapshot: snapshot)
            } label: {
                HStack {
                    Text(LocalizedShortDateFormatter.shared.string(from: date))
                        .font(.headline).foregroundColor(.primary)
                    Text(equityStringRepresentation)
                        .font(.subheadline).foregroundColor(.gray)
                    Spacer()
                    Image(systemName: "chevron.right").font(.body)
                }
            }
        } else {
            Text("something went wrong while loading this snapshot!")
        }
    }
    
    
    enum SnapshotSheetType: Identifiable {
        var id: UUID { UUID() }
        case addSheet
        case updateSheet(snapshot: Snapshot)
    }
}
