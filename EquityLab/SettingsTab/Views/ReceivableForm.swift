import SwiftUI

struct ReceivableForm: View {
    @State var viewModel: AssetFormViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                    .frame(maxHeight: 16)
                Form {
                    descriptionSection
                    amountSection
                    dateSection
                    if viewModel.asset.isNotNil {
                        deleteSection
                    }
                }
            }
            .navigationTitle(viewModel.asset.isNil ? "New Receivable" : "Edit Receivable")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    cancelButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    saveButton
                }
            }
            .alert(isPresented: $viewModel.showValidationErrorAlert, error: viewModel.receivableValidationError) { _ in
                Button("OK", role: .cancel) {
                    viewModel.receivableValidationError = nil
                }
            } message: { _ in }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
    
    private var descriptionSection: some View {
        Section {
            TextField("name", text: $viewModel.assetName)
            TextField("debtor", text: $viewModel.receivableDebtor)
            Picker("AssetPool", selection: $viewModel.assetPool) {
                ForEach(viewModel.getAssetPools()) { pool in
                    Text(pool.name).tag(pool)
                }
                Text("none selected").tag(AssetPool?.none)
            }
        }
    }
    
    private var amountSection: some View {
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
    }
    
    private var dateSection: some View {
        Section {
            DatePicker("date", selection: $viewModel.receivableGrantDate, in: ...Date(), displayedComponents: .date)
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
                do {
                    try viewModel.createReceivable()
                    viewModel.dismissSheet()
                } catch let error as ReceivableValidationError  {
                    viewModel.receivableValidationError = error
                    viewModel.showValidationErrorAlert = true
                } catch {}
            } else {
                do {
                    try viewModel.updateReceivable()
                    viewModel.dismissSheet()
                } catch let error as ReceivableValidationError  {
                    viewModel.receivableValidationError = error
                    viewModel.showValidationErrorAlert = true
                } catch {}
            }
        }
    }
}
