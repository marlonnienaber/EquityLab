import SwiftUI
import CoreData

struct SnapshotStructureView: View {
    @State var viewModel = SnapshotStructureViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack(alignment: .top, spacing: 13) {
                        BalanceSide<AssetPool,Asset>(
                            title: "Assets",
                            headerBackgroundColor: .assetsUnselected,
                            pools: viewModel.assetPools,
                            itemRetriever: viewModel.getAssetsForAssetPool,
                            poolEditButtonAction: { pool in
                                viewModel.alertPoolName = pool.name
                                viewModel.assetPoolToEdit = pool
                                viewModel.showEditAssetPoolAlert = true
                            },
                            itemEditButtonAction: { viewModel.activeBalanceItemSheet = .updateSheetAsset(asset: $0) }
                        )
                        BalanceSide<LiabilityPool,Liability>(
                            title: "Liabilities",
                            headerBackgroundColor: .liabilitiesUnselected,
                            pools: viewModel.liabilityPools,
                            itemRetriever: viewModel.getLiabilitiesForLiabilityPool,
                            poolEditButtonAction: { pool in
                                viewModel.alertPoolName = pool.name
                                viewModel.liabilityPoolToEdit = pool
                                viewModel.showEditLiabilityPoolAlert = true
                            },
                            itemEditButtonAction: { viewModel.activeBalanceItemSheet = .updateSheetLiability(liability: $0) }
                        )
                    }
                    .padding(.top)
                }
            }
            .padding(.horizontal)
            .poolEditAlert<AssetPool>(
                title: "Edit AssetPool",
                isPresented: $viewModel.showEditAssetPoolAlert,
                presentedPool: viewModel.assetPoolToEdit,
                textFieldContent: $viewModel.alertPoolName,
                saveAction: { viewModel.updateAssetPool() },
                deleteAction: { viewModel.delete(assetPool: $0) }
            )
            .poolEditAlert<LiabilityPool>(
                title: "Edit LiabilityPool",
                isPresented: $viewModel.showEditLiabilityPoolAlert,
                presentedPool: viewModel.liabilityPoolToEdit,
                textFieldContent: $viewModel.alertPoolName,
                saveAction: { viewModel.updateLiabilityPool() },
                deleteAction: { viewModel.delete(liabilityPool: $0) }
            )
            .poolCreateAlert(
                isPresented: $viewModel.showCreateAssetPoolAlert,
                textFieldContent: $viewModel.alertPoolName,
                saveAction: { viewModel.createAssetPool() }
            )
            .poolCreateAlert(
                isPresented: $viewModel.showCreateLiabilityPoolAlert,
                textFieldContent: $viewModel.alertPoolName,
                saveAction: { viewModel.createLiabilityPool() }
            )
            .sheet(isPresented: $viewModel.showBalanceItemPickerSheet) {
                balanceItemSelectionMenu
                    .presentationDetents([.fraction(0.25)])
            }
            .sheet(item: $viewModel.activeBalanceItemSheet) { activeSheet in
                sheetContent(for: activeSheet)
                    .presentationDetents([.fraction(0.8)])
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.showBalanceItemPickerSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
    
    @ViewBuilder
    func sheetContent(for sheetType: BalanceItemSheet) -> some View {
        switch sheetType {
        case .createSheetPossession: PossessionForm(viewModel: AssetFormViewModel{ viewModel.activeBalanceItemSheet = nil } )
        case .createSheetReceivable: ReceivableForm(viewModel: AssetFormViewModel{ viewModel.activeBalanceItemSheet = nil } )
        case .createSheetLiability: LiabilityForm(viewModel: LiabilityFormViewModel{ viewModel.activeBalanceItemSheet = nil } )
        case .updateSheetAsset(let asset):
            if let possession = asset as? Possession {
                PossessionForm(viewModel: AssetFormViewModel(asset: possession) { viewModel.activeBalanceItemSheet = nil })
            } else if let receivable = asset as? Receivable {
                ReceivableForm(viewModel: AssetFormViewModel(asset: receivable) { viewModel.activeBalanceItemSheet = nil })
            }
        case .updateSheetLiability(let liability): LiabilityForm(viewModel: LiabilityFormViewModel(liability: liability) { viewModel.activeBalanceItemSheet = nil })
        }
    }
    
    var balanceItemSelectionMenu: some View {
        NavigationView {
            VStack {
                Text("Which snapshot item you like to add?")
                Picker("", selection: $viewModel.selectedBalanceItem) {
                    Text("AssetPool").tag(BalanceItemType.assetPool)
                    Text("Possession").tag(BalanceItemType.possession)
                    Text("Receivable").tag(BalanceItemType.receivable)
                    Text("LiabilityPool").tag(BalanceItemType.liabilityPool)
                    Text("Liability").tag(BalanceItemType.liability)
                }
                .pickerStyle(MenuPickerStyle())
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel"){
                        viewModel.activeBalanceItemSheet = nil
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("OK") {
                        viewModel.showBalanceItemPickerSheet = false
                        switch viewModel.selectedBalanceItem {
                        case .assetPool: viewModel.showCreateAssetPoolAlert = true
                        case .possession: viewModel.activeBalanceItemSheet = .createSheetPossession
                        case .receivable: viewModel.activeBalanceItemSheet = .createSheetReceivable
                        case .liabilityPool: viewModel.showCreateLiabilityPoolAlert = true
                        case .liability: viewModel.activeBalanceItemSheet = .createSheetLiability
                        }
                    }
                }
            }
        }
    }
}

extension View {
    func poolEditAlert<PoolType>(
        title: String,
        isPresented: Binding<Bool>,
        presentedPool: PoolType?,
        textFieldContent: Binding<String>,
        saveAction: @escaping () -> (),
        deleteAction: @escaping (PoolType) -> ()
    ) -> some View {
        self.alert("Edit AssetPool", isPresented: isPresented, presenting: presentedPool) { pool in
            TextField("Value", text: textFieldContent)
            Button("Cancel", role: .cancel) {
                isPresented.wrappedValue = false
            }
            Button("Save") {
                saveAction()
            }
            Button("Delete", role: .destructive) {
                deleteAction(pool)
            }
        }
    }
    
    func poolCreateAlert(
        isPresented: Binding<Bool>,
        textFieldContent: Binding<String>,
        saveAction: @escaping () -> ()
    ) -> some View {
        self.alert("What should the name of the new pool be?", isPresented: isPresented) {
            TextField("Value", text: textFieldContent)
            Button("Cancel") {
                isPresented.wrappedValue = false
            }
            Button("Save") {
                saveAction()
            }
        }
    }
}

struct BalanceSide<PoolType:Named&Hashable,ItemType:Named>: View {
    let title: String
    let headerBackgroundColor: Color
    let pools: [PoolType]
    let itemRetriever: (PoolType) -> ([ItemType])
    let poolEditButtonAction: (PoolType) -> ()
    let itemEditButtonAction: (ItemType) -> ()
    
    var body: some View {
        VStack(alignment: .leading) {
            header
            ForEach(pools, id: \.name) { balancePool in
                Spacer()
                    .frame(height: 20)
                poolSection(for: balancePool)
            }
        }
    }
    
    var header: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundStyle(.primary)
                .padding(.vertical,3)
            Spacer()
        }
        .padding(.horizontal)
        .foregroundStyle(.primaryInverted)
        .background(
            Rectangle()
                .cornerRadius(12)
                .foregroundStyle(headerBackgroundColor)
                .opacity(0.5)
        )
    }
    
    func poolSection(for balancePool: PoolType) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(balancePool.name)
                    .font(.subheadline)
                    .padding(.horizontal)
                    .underline()
                Spacer()
                Button {
                    poolEditButtonAction(balancePool)
                } label: {
                    Image(systemName: "slider.horizontal.3")
                        .font(.subheadline)
                        .padding(.trailing)
                }
            }
            ForEach(itemRetriever(balancePool), id: \.name) { item in
                HStack(spacing: 2) {
                    Text(item.name)
                        .font(.caption)
                        .padding(.leading)
                    Button {
                        itemEditButtonAction(item)
                    } label: {
                        Image(systemName: "chevron.right.circle")
                            .font(.caption2)
                    }
                }
            }
        }
        .padding(.vertical, 6)
    }
}


