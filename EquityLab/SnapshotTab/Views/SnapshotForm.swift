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
                        MonetaryInputView(positionName: proxy.name, positionPool: proxy.poolName, positionValue: $viewModel.assetProxies[index].value)
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
                        MonetaryInputView(positionName: proxy.name, positionPool: proxy.poolName, positionValue: $viewModel.liabilityProxies[index].value)
                    }
                }
            }
        }
    }
    
    struct MonetaryInputView: View {
        let positionName: String
        let positionPool: String
        @Binding var positionValue: Double
        
        var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    Text(positionName)
                        .fontWeight(.heavy)
                    Text(positionPool)
                        .font(.footnote)
                }
                Spacer()
                CurrencyInputField(value: $positionValue)
                    .padding(6)
            }
        }
    }
}
