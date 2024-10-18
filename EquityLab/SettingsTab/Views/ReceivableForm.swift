import SwiftUI

struct ReceivableForm: View {
    @State var viewModel: AssetFormViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                    .frame(maxHeight: 16)
                Form {
                    Section {
                        TextField("debtor", text: $viewModel.receivableDebtor)
                        TextField("purpose", text: $viewModel.assetName)
                        Picker("AssetPool", selection: $viewModel.assetPool) {
                            ForEach(viewModel.getAssetPools()) { pool in
                                Text(pool.name).tag(pool)
                            }
                            Text("none selected").tag(AssetPool?.none)
                        }
                    }
                    Section {
                        HStack {
                            Text("initial amount")
                            Spacer()
                            CurrencyInputField(value: $viewModel.receivableInitialAmount)
                                .padding(6)
                        }
                        HStack {
                            Text("repaid amount")
                            Spacer()
                            CurrencyInputField(value: $viewModel.receivableRepaidAmount)
                                .padding(6)
                        }
                    }
                    Section {
                        DatePicker("date", selection: $viewModel.receivableGrantDate, in: ...Date(), displayedComponents: .date)
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
            .navigationTitle(viewModel.asset == nil ? "New Receivable" : "Edit Receivable")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        viewModel.dismissSheet()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if viewModel.asset == nil {
                            viewModel.createReceivable()
                        } else {
                            viewModel.updateReceivable()
                        }
                        viewModel.dismissSheet()
                    }
                    .disabled(viewModel.assetPool == nil)
                }
            }
        }
    }
}
