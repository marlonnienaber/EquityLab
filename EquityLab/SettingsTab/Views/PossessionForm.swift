import SwiftUI

struct PossessionForm: View {
    @State var viewModel: AssetFormViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                    .frame(maxHeight: 16)
                Form {
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
                    if viewModel.asset != nil {
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
                }
            }
            .navigationTitle(viewModel.asset == nil ? "New Possession" : "Edit Possession")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        viewModel.dismissSheet()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if viewModel.asset == nil {
                            viewModel.createPossession()
                        } else {
                            viewModel.updatePossession()
                        }
                        viewModel.dismissSheet()
                    }
                    .disabled(viewModel.assetPool == nil)
                }
            }
        }
    }
}
