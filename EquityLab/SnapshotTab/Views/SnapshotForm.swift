import SwiftUI
import CoreData

struct SnapshotForm: View {
    @State var viewModel: SnapshotFormViewModel
    
    var body: some View {
        NavigationView {
            Form {
                dateSection
                assetSection
                liabilitySection
            }
            .navigationTitle("new Snapshot")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel"){
                        viewModel.dismissSheet()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        do {
                            try viewModel.saveSnapshot()
                            viewModel.dismissSheet()
                        } catch let error as SnapshotValidationError {
                            viewModel.snapshotValidationError = error
                            viewModel.showValidationErrorAlert = true
                        } catch {}
                    }
                }
            }
            .alert(isPresented: $viewModel.showValidationErrorAlert, error: viewModel.snapshotValidationError) { _ in
                Button("OK", role: .cancel) {
                    viewModel.snapshotValidationError = nil
                }
            } message: { _ in }
        }
    }
    
    var dateSection: some View {
        Section {
            DatePicker("Date", selection: $viewModel.date, in: ...Date(), displayedComponents: .date)
        }
    }
    
    var assetSection: some View {
        Section("Assets") {
            ForEach(viewModel.assetPoolNames, id: \.self) { poolName in
                ForEach(viewModel.getAssetProxies(for: poolName), id: \.name) { proxy in
                    if let index = viewModel.assetProxies.firstIndex(where: { $0.name == proxy.name }) {
                        CurrencyInputView(value: $viewModel.liabilityProxies[index].value) {
                            VStack(alignment: .leading) {
                                Text(proxy.name)
                                    .fontWeight(.heavy)
                                Text(proxy.poolName)
                                    .font(.footnote)
                            }
                        }
                    }
                }
            }
        }
    }
    
    var liabilitySection: some View {
        Section("Liabilities") {
            ForEach(viewModel.liabilityPoolNames, id: \.self) { poolName in
                ForEach(viewModel.getLiabilityProxies(for: poolName), id: \.name) { proxy in
                    if let index = viewModel.liabilityProxies.firstIndex(where: { $0.name == proxy.name }) {
                        CurrencyInputView(value: $viewModel.liabilityProxies[index].value) {
                            VStack(alignment: .leading) {
                                Text(proxy.name)
                                    .fontWeight(.heavy)
                                Text(proxy.poolName)
                                    .font(.footnote)
                            }
                        }
                    }
                }
            }
        }
    }
}
