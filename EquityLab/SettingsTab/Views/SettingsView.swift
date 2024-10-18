import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Snapshots") {
                    balanceStructureMenu
                }
                Section("Data") {
                    importDataButton
                    exportDataButton
                }
            }
            .navigationTitle("Settings")
        }
    }
    
    var balanceStructureMenu: some View {
        NavigationLink {
            SnapshotStructureView()
                .navigationTitle("Snapshot Structure")
        } label: {
            Text("Structure")
        }
    }
    
    var exportDataButton: some View {
        Button {
            
        } label: {
            HStack {
                Text("Export Data")
                Spacer()
                Image(systemName: "square.and.arrow.up")
            }
        }
        .foregroundStyle(.primary)
    }
    
    var importDataButton: some View {
        Button {
            
        } label: {
            HStack {
                Text("Import Data")
                Spacer()
                Image(systemName: "square.and.arrow.down")
            }
        }
        .foregroundStyle(.primary)
    }
}
