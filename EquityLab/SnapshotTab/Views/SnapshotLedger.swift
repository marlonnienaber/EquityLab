import SwiftUI

struct SnapshotLedger: View {
    @State private var viewModel = SnapshotLedgerViewModel()
    
    var body: some View {
        NavigationView {
            ledgerContent
                .navigationTitle("Snapshots")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                            .disabled(viewModel.hasNoSnapshots)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            viewModel.activeSheet = .addSheet
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
        }
        .sheet(item: $viewModel.activeSheet) { activeSheet in
            switch activeSheet {
            case .addSheet: SnapshotForm(viewModel: SnapshotFormViewModel(), snapshotLedgerActiveSheet: $viewModel.activeSheet)
            case .updateSheet(let shot): SnapshotForm(viewModel: SnapshotFormViewModel(snapshot: shot), snapshotLedgerActiveSheet: $viewModel.activeSheet)
            }
        }
    }
    
    @ViewBuilder 
    var ledgerContent: some View {
        if viewModel.hasNoSnapshots {
            noSnapshotDataView
        } else {
            List {
                ForEach(viewModel.years, id: \.self) { year in
                    Section(String(year)) {
                        sectionContent(for: year, containing: viewModel.getSnapshots(fallingInto: year))
                    }
                }
            }
        }
    }
    
    var noSnapshotDataView: some View {
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
            snapshotListCell(for: snapshot)
        }
        .onDelete{ indexSet in
            viewModel.deleteSnapshots(in: year, for: indexSet)
        }
    }
    
    @ViewBuilder 
    func snapshotListCell(for snapshot: Snapshot) -> some View {
        if let equityStringRepresentation = LocalizedCurrencyFormatter.shared.string(from: viewModel.getEquityValue(of: snapshot)),
           let date = snapshot.date {
            Button {
                viewModel.activeSheet = .updateSheet(snapshot: snapshot)
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
}
