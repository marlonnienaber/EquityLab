import SwiftUI
import CoreData

struct SnapshotForm: View {
    @State var viewModel: SnapshotFormViewModel
    @Binding var snapshotLedgerActiveSheet: SnapshotLedger.SnapshotSheetType?
    
    var body: some View {
        NavigationView {
            Form {
                DateSection
                AssetSection
                LiabilitySection
            }.toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel"){
                        snapshotLedgerActiveSheet = nil
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.saveSnapshot()
                        snapshotLedgerActiveSheet = nil
                    }
                }
            }.navigationTitle("new Snapshot")
        }
    }
    
    @ViewBuilder var DateSection: some View {
        Section {
            DatePicker("Date", selection: $viewModel.date, in: ...Date(), displayedComponents: .date)
        }
    }
    
    @ViewBuilder var AssetSection: some View {
        Section("Assets") {
            ForEach(viewModel.getAssetPoolNames(), id: \.self) { poolName in
                ForEach(viewModel.getAssetProxies(for: poolName), id: \.name) { proxy in
                    if let index = viewModel.assetProxies.firstIndex(where: { $0.name == proxy.name }) {
                        MonetaryInputView(positionName: proxy.name, positionPool: proxy.poolName, positionValue: $viewModel.assetProxies[index].value)
                    }
                }
            }
        }
    }
    
    @ViewBuilder var LiabilitySection: some View {
        Section("Liabilities") {
            ForEach(viewModel.getLiabilityPoolNames(), id: \.self) { poolName in
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
                    Text(positionName).fontWeight(.heavy)
                    Text(positionPool).font(.footnote)
                }
                Spacer()
                CurrencyInputField(value: $positionValue)
                    .padding(6)
            }
        }
    }
}
