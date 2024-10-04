import SwiftUI
import CoreData

/* TODO: create a custom .alert modifier which only takes in an optional AssetPool -> get rid of alert-flags in viewModel */
struct AssetLedger: View {
    @State private var viewModel = AssetLedgerViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.pools) { pool in
                    Section(pool.name) {
                        SectionContent(pool: pool, sectionAssets: viewModel.assets(for: pool))
                        SectionControls(for: pool)
                    }
                }
            }
            .navigationTitle("Assets")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                        .disabled(viewModel.pools.isEmpty)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.resetPoolVariables()
                        viewModel.showCreatePoolAlert = true
                    } label: {
                        Text("new pool")
                    }
                }
            }
            .alert("What should the name of the new pool be?", isPresented: $viewModel.showCreatePoolAlert) {
                TextField("Value", text: $viewModel.alertPoolName)
                Button("Cancel") {
                    viewModel.showCreatePoolAlert = false
                }
                Button("Save") {
                    viewModel.createAssetPool()
                }
            }
            .alert("Edit \(viewModel.alertPool?.name ?? "")", isPresented: $viewModel.showEditPoolAlert) {
                TextField("Value", text: $viewModel.alertPoolName)
                Button("Cancel", role: .cancel) {
                    viewModel.showEditPoolAlert = false
                }
                Button("Save") {
                    viewModel.updateAssetPool()
                }
                Button("Delete", role: .destructive) {
                    viewModel.deleteAssetPool()
                }
            }
        }
        .sheet(item: $viewModel.activeSheet) { activeSheet in
            switch activeSheet {
            case .addSheetAsset(let pool): AssetForm(viewModel: AssetFormViewModel(pool: pool) { viewModel.activeSheet = nil })
            case .updateSheetAsset(let asset): AssetForm(viewModel: AssetFormViewModel(asset: asset) { viewModel.activeSheet = nil })
            }
        }
    }
    
    @ViewBuilder func SectionContent(pool: AssetPool, sectionAssets: [Asset]) -> some View {
        ForEach(sectionAssets, id: \.name) { asset in
            Button {
                viewModel.activeSheet = AssetLedgerSheetType.updateSheetAsset(asset: asset)
            } label: {
                if let receivable = asset as? Receivable {
                    HStack{
                        if let initialAmountStringRepresentation = LocalizedCurrencyFormatter.shared.string(from: NSNumber(value: receivable.initialAmount)) {
                            VStack(alignment: .leading) {
                                Text(receivable.name)
                                    .foregroundColor(Color.primary)
                                Text(receivable.debtor)
                                    .font(.footnote)
                                    .foregroundColor(Color.gray)
                                Text(initialAmountStringRepresentation)
                                    .font(.footnote)
                                    .foregroundColor(Color.gray)
                            }
                            Spacer()
                            CircularProgressView(progress: receivable.repaymentPercentage)
                                .frame(width: 37, height: 37)
                        }
                    }
                } else {
                    Text(asset.name).foregroundColor(.primary)
                }
            }
        }.onDelete{ indexSet in
            viewModel.deleteAssets(in: pool, forIndexSet: indexSet)
        }
    }
        
    @ViewBuilder func SectionControls(for pool: AssetPool) -> some View {
        HStack{
            Button {
                viewModel.activeSheet = .addSheetAsset(pool: pool)
            } label: {
                HStack{
                    Image(systemName: "plus")
                    Text("new asset")
                }
            }
            .buttonStyle(BorderlessButtonStyle())
            Spacer()
            Button {
                viewModel.alertPool = pool
                viewModel.alertPoolName = pool.name
                viewModel.showEditPoolAlert = true
            } label: {
                Image(systemName: "slider.horizontal.3")
            }
            .buttonStyle(BorderlessButtonStyle())
        }
    }
}
