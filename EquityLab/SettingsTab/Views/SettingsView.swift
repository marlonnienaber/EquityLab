import SwiftUI

struct SettingsView: View {
    @State var viewModel = SettingsViewModel()
    
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
            .sheet(item: $viewModel.temporaryBackupFileUrl) { url in
                ExportPathPicker(temporaryFileUrl: url)
            }
            .sheet(isPresented: $viewModel.presentImportPathPickerSheet) {
                ImportPathPicker { url in
                    viewModel.deserializeJsonFile(at: url)
                }
            }
            .overlay {
                if viewModel.isSerializingState {
                    VStack {
                        ProgressView("Loading...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .foregroundColor(.primary)
                            .padding()
                            .background(.primaryInverted)
                            .cornerRadius(10)
                    }
                    .shadow(radius: 10)
                    .transition(.opacity)
                }
            }
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
            Task {
                await viewModel.serializeStateAndShowFileLocationPicker()
            }
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
            viewModel.presentImportPathPickerSheet = true
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

struct ExportPathPicker: UIViewControllerRepresentable {
    let temporaryFileUrl: URL
    
    func makeCoordinator() -> Coordinator {
        Coordinator(temporaryFileUrl: temporaryFileUrl)
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let documentPicker = UIDocumentPickerViewController(forExporting: [temporaryFileUrl], asCopy: true)
        documentPicker.delegate = context.coordinator
        return documentPicker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let temporaryFileUrl: URL
        
        init(temporaryFileUrl: URL) {
            self.temporaryFileUrl = temporaryFileUrl
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            try? FileManager.default.removeItem(at: temporaryFileUrl)
        }
    }
}

struct ImportPathPicker: UIViewControllerRepresentable {
    var onFilePicked: (URL) -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onFilePicked: onFilePicked)
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.json], asCopy: true)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var onFilePicked: (URL) -> Void
        
        init(onFilePicked: @escaping (URL) -> Void) {
            self.onFilePicked = onFilePicked
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            onFilePicked(url)
        }
    }
}
