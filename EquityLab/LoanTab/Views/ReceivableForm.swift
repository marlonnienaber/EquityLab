import SwiftUI

struct ReceivableForm: View {
    @State var viewModel: ReceivableFormViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                    .frame(maxHeight: 16)
                Form {
                    descriptionSection
                    if viewModel.receivable.isNil {
                        dataSection
                    }
                    if viewModel.deletionPossible {
                        deletionButton
                    }
                }
            }
            .navigationTitle(viewModel.receivable.isNil ? "New Receivable" : "Edit Receivable")
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
            TextField("name", text: $viewModel.name)
            NavigationLink {
                LoanPartnerSelectionView(viewModel:
                    LoanPartnerSelectionViewModel(selectedLoanPartner: viewModel.debtor) { selectedPerson in
                        viewModel.debtor = selectedPerson
                    }
                )
            } label: {
                HStack {
                    Text("debtor")
                    Spacer()
                    Text(viewModel.debtor?.name ?? "none selected")
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
    
    private var dataSection: some View {
        Section {
            HStack {
                Text("initial amount")
                Spacer()
                CurrencyInputField(value: $viewModel.disbursedAmount)
                    .padding(6)
            }
            DatePicker("date", selection: $viewModel.grantDate, in: ...Date(), displayedComponents: .date)
        }
    }
    
    private var deletionButton: some View {
        Button("Delete") {
            viewModel.deleteReceivable()
            viewModel.dismissSheet()
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .foregroundStyle(.red)
    }
    
    private var cancelButton: some View {
        Button("Cancel") {
            viewModel.dismissSheet()
        }
    }
    
    private var saveButton: some View {
        Button("Save") {
            do {
                try viewModel.saveReceivable()
                viewModel.dismissSheet()
            } catch let error as ReceivableValidationError  {
                viewModel.receivableValidationError = error
                viewModel.showValidationErrorAlert = true
            } catch {}
        }
    }
}
