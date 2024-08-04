//
//  AssetLedger.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 14.07.24.
//

import SwiftUI
import CoreData

struct AssetLedger: View {
    @State private var viewModel = AssetLedgerViewModel()
    @State private var activeSheet: AssetLedgerSheetType? = nil
    
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
                    if viewModel.pools.isEmpty {
                        EditButton().disabled(true)
                    } else {
                        EditButton()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button (action: {activeSheet = .addSheetAssetPool} ){
                        Text("new pool")
                    }
                }
            }
        }
        .sheet(item: $activeSheet) { activeSheet in
            switch activeSheet {
            case .addSheetAssetPool: AssetPoolForm(viewModel: AssetPoolFormViewModel(allPools: viewModel.pools),assetLedgerActiveSheet: $activeSheet)
            case .updateSheetAssetPool(let pool): AssetPoolForm(viewModel: AssetPoolFormViewModel(pool: pool, allPools: viewModel.pools), assetLedgerActiveSheet: $activeSheet)
            case .addSheetAsset(let pool): AssetForm(viewModel: AssetFormViewModel(pool: pool, allAssets: viewModel.allAssets()), assetLedgerActiveSheet: $activeSheet)
            case .updateSheetAsset(let asset): AssetForm(viewModel: AssetFormViewModel(asset: asset, allAssets: viewModel.allAssets()), assetLedgerActiveSheet: $activeSheet)
            }
        }
    }
    
    @ViewBuilder func SectionContent(pool: AssetPool, sectionAssets: [Asset]) -> some View {
        ForEach(sectionAssets, id: \.name) { asset in
            Button(action: { activeSheet = AssetLedgerSheetType.updateSheetAsset(asset: asset)}) {
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
            Button(action: {activeSheet = .addSheetAsset(pool: pool)} ) {
                HStack{
                    Image(systemName: "plus")
                    Text("new asset")
                }
            }.buttonStyle(BorderlessButtonStyle())
            Spacer()
            Button(action: {activeSheet = .updateSheetAssetPool(pool: pool)}) {
                Image(systemName: "slider.horizontal.3")
            }.buttonStyle(BorderlessButtonStyle())
        }
    }
    
    public enum AssetLedgerSheetType: Identifiable {
        var id: UUID { UUID() }
        case addSheetAssetPool
        case updateSheetAssetPool(pool: AssetPool)
        case addSheetAsset(pool: AssetPool)
        case updateSheetAsset(asset: Asset)
    }
    
}
