import SwiftUI

struct PossessionForm: View {
    @State var viewModel: AssetFormViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                    .frame(maxHeight: 16)
                Form {
                    descriptionSection
                    if viewModel.asset.isNotNil {
                        deleteSection
                    }
                }
            }
            .navigationTitle(viewModel.asset.isNil ? "New Possession" : "Edit Possession")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    cancelButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    saveButton
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
    
    private var descriptionSection: some View {
        Section {
            TextField("name", text: $viewModel.assetName)
            Toggle(isOn: $viewModel.possessionIsVolatile) {
                HStack{
                    Text("volatile asset?")
                    Spacer()
                    Button{
                        viewModel.showPopover.toggle()
                    } label: {
                        Image(systemName: "info.circle")
                    }
                    .popover(isPresented: $viewModel.showPopover) {
                        Text("the latest value of non-volatile assets will be reused when taking a new snapshot")
                            .presentationCompactAdaptation(.popover)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                
            }
            Picker("AssetPool", selection: $viewModel.assetPool) {
                ForEach(viewModel.getAssetPools()) { pool in
                    Text(pool.name).tag(pool)
                }
                Text("none selected").tag(AssetPool?.none)
            }
        }
    }
    
    private var deleteSection: some View {
        Section {
            HStack(alignment: .center) {
                Spacer()
                Button {
                    viewModel.deleteAsset()
                    viewModel.dismissSheet()
                } label: {
                    Text("Delete")
                        .foregroundStyle(.red)
                }
                Spacer()
            }
        }
    }
    
    private var cancelButton: some View {
        Button("Cancel") {
            viewModel.dismissSheet()
        }
    }
    
    private var saveButton: some View {
        Button("Save") {
            if viewModel.asset.isNil {
                viewModel.createPossession()
            } else {
                viewModel.updatePossession()
            }
            viewModel.dismissSheet()
        }
        .disabled(viewModel.assetPool.isNil)
    }
}
