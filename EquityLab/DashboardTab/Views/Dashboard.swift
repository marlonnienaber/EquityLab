import SwiftUI
import Charts
import UIKit

struct Dashboard: View {
    @State var viewModel = DashboardViewModel()
    
    var body: some View {
        NavigationView {
            dashboardContent
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button {
                                Task {
                                    await viewModel.serializeStateAndShowFileLocationPicker()
                                }
                            } label: {
                                HStack {
                                    Text("export data")
                                    Image(systemName: "square.and.arrow.up")
                                }
                            }
                            Button {
                                viewModel.presentImportPathPickerSheet = true
                            } label: {
                                HStack {
                                    Text("import data")
                                    Image(systemName: "square.and.arrow.down")
                                }
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
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
                .navigationTitle("Analytics")
        }
    }
    
    @ViewBuilder
    private var dashboardContent: some View {
        if viewModel.noSnapshotsAvailable {
            noSnapshotsView
        } else {
            GeometryReader { geometry in
                VStack(spacing: 16) {
                    equitySection
                        .frame(height: geometry.size.height * 0.45)
                    snapshotDetailSection
                        .frame(height: geometry.size.height * 0.55)
                }
            }
            .padding([.top, .leading, .trailing], 16)
            .padding(.bottom, 32)
        }
    }
    
    private var noSnapshotsView: some View {
        VStack {
            Image(systemName: "tray.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
            Text("no snapshots available for analysis")
        }
        .foregroundColor(Color.primary.opacity(0.4))
    }
    
    private var equitySection: some View {
        GroupBox {
            HStack {
                Text("equity")
                    .bold()
                Spacer()
                Picker("Time Horizon", selection: $viewModel.selectedTimeHorizon) {
                    ForEach(TimeHorizon.allCases) { timeHorizon in
                        Text(timeHorizon.rawValue).tag(timeHorizon)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 235)
            }
            EquityChart(viewModel: viewModel)
        }
    }
    
    private var snapshotDetailSection: some View {
        GroupBox {
            if let selectedSnapshot = viewModel.selectedSnapshot, let date = selectedSnapshot.date {
                HStack {
                    Text(LocalizedLongDateFormatter.shared.string(from: date))
                        .bold()
                    Spacer()
                    Picker("Snapshot Detail View",selection: $viewModel.selectedSnapshotDetailView) {
                        ForEach(SnapshotDetailView.allCases) { detailView in
                            Text(detailView.rawValue).tag(detailView)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .accentColor(.primary)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.2))
                    )
                }
                switch viewModel.selectedSnapshotDetailView {
                case .assetDetailView: assetDetailView
                case .liabilityDetailView: liabilityDetailView
                case .balanceDetailView: balanceDetailView
                }
            } else {
                Text("Please select a snapshot by taping on a data point in the equity section to display its details.")
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .groupBoxStyle(PageViewGroupBoxStyle())
        .onAppear{
            viewModel.initializeSelectedSnapshot()
        }
    }
    
    private var balanceDetailView: some View {
        VStack {
            Spacer()
            BalanceView(viewModel: viewModel)
            Spacer()
        }
    }
    
    private var assetDetailView: some View {
        TabView(selection: $viewModel.selectedDetailPage) {
            VStack {
                ChangenChart(viewModel: ChangeChartViewModel(changeChartType: .assetChangeChart, dashboardViewModel: viewModel))
                Spacer()
                    .frame(height: 45)
            }
            .tag(DetailPage.changeDetailPage)
            VStack {
                DistributionChart(viewModel: DistributionChartViewModel(distributionChartType: .assetDistributionChart, dashboardViewModel: viewModel))
                Spacer()
                    .frame(height: 45)
            }
            .tag(DetailPage.distributionDetailPage)
        }
        .tabViewStyle(PageTabViewStyle())
    }
    
    private var liabilityDetailView: some View {
        TabView(selection: $viewModel.selectedDetailPage) {
            VStack {
                ChangenChart(viewModel: ChangeChartViewModel(changeChartType: .liabilityChangeChart, dashboardViewModel: viewModel))
                Spacer()
                    .frame(height: 45)
            }
            .tag(DetailPage.changeDetailPage)
            VStack {
                DistributionChart(viewModel: DistributionChartViewModel(distributionChartType: .liabilityDistributionChart, dashboardViewModel: viewModel))
                Spacer()
                    .frame(height: 45)
            }
            .tag(DetailPage.distributionDetailPage)
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

private struct PageViewGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .padding([.top, .leading, .trailing])
            .padding(.bottom, 0)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color(UIColor.secondarySystemBackground))
            )
    }
}

struct ExportPathPicker: UIViewControllerRepresentable {
    let temporaryFileUrl: URL
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let documentPicker = UIDocumentPickerViewController(forExporting: [temporaryFileUrl], asCopy: true)
        documentPicker.delegate = context.coordinator
        return documentPicker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let selectedURL = urls.first else { return }
            print("File saved to: \(selectedURL)")
            /* TODO: delete temporary file after final file was created at selected location */
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            print("Document picker was cancelled")
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
