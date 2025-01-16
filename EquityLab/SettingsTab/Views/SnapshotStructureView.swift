import SwiftUI
import CoreData

struct SnapshotStructureView: View {
    @State var viewModel = SnapshotStructureViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack(alignment: .top, spacing: 13) {
                        BalanceSide (
                            viewModel: viewModel,
                            title: "Assets",
                            headerBackgroundColor: .assetsUnselected,
                            pools: viewModel.assetPools
                        )
                        BalanceSide (
                            viewModel: viewModel,
                            title: "Liabilities",
                            headerBackgroundColor: .liabilitiesUnselected,
                            pools: viewModel.liabilityPools
                        )
                    }
                    .padding(.top)
                }
            }
            .padding(.horizontal)
            .poolEditAlert<AssetPool, AssetPoolValidationError>(
                title: "Edit AssetPool",
                isPresented: $viewModel.showEditAssetPoolAlert,
                presentedPool: viewModel.assetPoolToEdit,
                textFieldContent: $viewModel.alertPoolName,
                saveAction: { try viewModel.updateAssetPool() },
                errorAction: { error in
                    viewModel.assetPoolValidationError = error
                    viewModel.showAssetPoolValidationErrorAlert = true
                },
                deleteAction: { viewModel.deleteAssetPool($0) },
                cleanUpAction: {
                    viewModel.assetPoolToEdit = nil
                    viewModel.alertPoolName = ""
                }
            )
            .poolEditAlert<LiabilityPool, LiabilityPoolValidationError>(
                title: "Edit LiabilityPool",
                isPresented: $viewModel.showEditLiabilityPoolAlert,
                presentedPool: viewModel.liabilityPoolToEdit,
                textFieldContent: $viewModel.alertPoolName,
                saveAction: { try viewModel.updateLiabilityPool() },
                errorAction: { error in
                    viewModel.liabilityPoolValidationError = error
                    viewModel.showLiabilityPoolValidationErrorAlert = true
                },
                deleteAction: { viewModel.deleteLiabilityPool($0) },
                cleanUpAction: {
                    viewModel.assetPoolToEdit = nil
                    viewModel.alertPoolName = ""
                }
            )
            .poolCreateAlert<AssetPoolValidationError>(
                isPresented: $viewModel.showCreateAssetPoolAlert,
                textFieldContent: $viewModel.alertPoolName,
                saveAction: { try viewModel.createAssetPool() },
                errorAction: { error in
                    viewModel.assetPoolValidationError = error
                    viewModel.showAssetPoolValidationErrorAlert = true
                },
                cleanUpAction: { viewModel.alertPoolName = "" }
            )
            .poolCreateAlert<LiabilityPoolValidationError>(
                isPresented: $viewModel.showCreateLiabilityPoolAlert,
                textFieldContent: $viewModel.alertPoolName,
                saveAction: { try viewModel.createLiabilityPool() },
                errorAction: { error in
                    viewModel.liabilityPoolValidationError = error
                    viewModel.showLiabilityPoolValidationErrorAlert = true
                },
                cleanUpAction: { viewModel.alertPoolName = "" }
            )
            .alert(isPresented: $viewModel.showAssetPoolValidationErrorAlert, error: viewModel.assetPoolValidationError) { _ in
                Button("OK", role: .cancel) {
                    viewModel.assetPoolValidationError = nil
                    if viewModel.assetPoolToEdit.isNil {
                        viewModel.showCreateAssetPoolAlert = true
                    } else {
                        viewModel.showEditAssetPoolAlert = true
                    }
                }
            } message: { _ in }
            .alert(isPresented: $viewModel.showLiabilityPoolValidationErrorAlert, error: viewModel.liabilityPoolValidationError) { _ in
                Button("OK", role: .cancel) {
                    viewModel.liabilityPoolValidationError = nil
                    if viewModel.liabilityPoolToEdit.isNil {
                        viewModel.showCreateLiabilityPoolAlert = true
                    } else {
                        viewModel.showEditLiabilityPoolAlert = true
                    }
                }
            } message: { _ in }
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
        case .createSheetPossession:
            PossessionForm(viewModel: PossessionFormViewModel{ viewModel.activeBalanceItemSheet = nil } )
        case .createSheetReceivable:
            ReceivableForm(viewModel: ReceivableFormViewModel{ viewModel.activeBalanceItemSheet = nil } )
        case .createSheetLiability:
            EmptyView()
        case .updateSheetPossession(let possession):
            PossessionForm(viewModel: PossessionFormViewModel(possession: possession) { viewModel.activeBalanceItemSheet = nil })
        case .updateSheetReceivable(let receivable):
            ReceivableForm(viewModel: ReceivableFormViewModel(receivable: receivable) { viewModel.activeBalanceItemSheet = nil } )
        case .updateSheetLiability(let liability):
            EmptyView()
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
    func poolEditAlert<PoolType, ErrorType: Error>(
        title: String,
        isPresented: Binding<Bool>,
        presentedPool: PoolType?,
        textFieldContent: Binding<String>,
        saveAction: @escaping () throws -> (),
        errorAction: @escaping (ErrorType) -> (),
        deleteAction: @escaping (PoolType) -> (),
        cleanUpAction: @escaping () -> ()
    ) -> some View {
        self.alert("Edit AssetPool", isPresented: isPresented, presenting: presentedPool) { pool in
            TextField("Value", text: textFieldContent)
            Button("Cancel", role: .cancel) {
                isPresented.wrappedValue = false
                cleanUpAction()
            }
            Button("Save") {
                do {
                    try saveAction()
                    cleanUpAction()
                } catch let error as ErrorType {
                    errorAction(error)
                } catch {}
            }
            Button("Delete", role: .destructive) {
                deleteAction(pool)
                cleanUpAction()
            }
        }
    }
    
    func poolCreateAlert<ErrorType:Error>(
        isPresented: Binding<Bool>,
        textFieldContent: Binding<String>,
        saveAction: @escaping () throws -> (),
        errorAction: @escaping (ErrorType) -> (),
        cleanUpAction: @escaping () -> ()
    ) -> some View {
        self.alert("What should the name of the new pool be?", isPresented: isPresented) {
            TextField("Value", text: textFieldContent)
            Button("Cancel") {
                isPresented.wrappedValue = false
                cleanUpAction()
            }
            Button("Save") {
                do {
                    try saveAction()
                    cleanUpAction()
                } catch let error as ErrorType {
                    errorAction(error)
                } catch {}
            }
        }
    }
}

struct BalanceSide: View {
    let viewModel: SnapshotStructureViewModel
    let title: String
    let headerBackgroundColor: Color
    let pools: [SnapshotStructurePool]
    
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
    
    func poolSection(for balancePool: SnapshotStructurePool) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(balancePool.name)
                    .font(.subheadline)
                    .padding(.horizontal)
                    .underline()
                Spacer()
                Button {
                    balancePool.edit(via: viewModel)
                } label: {
                    Image(systemName: "slider.horizontal.3")
                        .font(.subheadline)
                        .padding(.trailing)
                }
            }
            ForEach(balancePool.retrieveItems(via: viewModel), id: \.name) { item in
                HStack(spacing: 2) {
                    Text(item.name)
                        .font(.caption)
                        .padding(.leading)
                    Button {
                        item.edit(via: viewModel)
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
