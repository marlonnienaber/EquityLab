import SwiftUI

struct LiabilityForm: View {
    @State var viewModel: LiabilityFormViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                    .frame(maxHeight: 16)
                Form {
                    descriptionSection
                    if viewModel.liability.isNil {
                        dataSection
                    }
                    /* TODO: add delete button for SnapshotStructureView */
                }
            }
            .navigationTitle(viewModel.liability.isNil ? "New Liability" : "Edit Liability")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    cancelButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    saveButton
                }
            }
            .alert(isPresented: $viewModel.showValidationErrorAlert, error: viewModel.liabilityValidationError) { _ in
                Button("OK", role: .cancel) {
                    viewModel.liabilityValidationError = nil
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
                    LoanPartnerSelectionViewModel(selectedPerson: viewModel.creditor) { selectedPerson in
                        viewModel.creditor = selectedPerson
                    }
                )
            } label: {
                HStack {
                    Text("creditor")
                    Spacer()
                    Text(viewModel.creditor?.name ?? "none selected")
                }
            }
            Picker("LiabilityPool", selection: $viewModel.liabilityPool) {
                ForEach(viewModel.getLiabilityPools()) { pool in
                    Text(pool.name).tag(pool)
                }
                Text("none selected").tag(LiabilityPool?.none)
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
    
    private var cancelButton: some View {
        Button("Cancel") {
            viewModel.dismissSheet()
        }
    }
    
    private var saveButton: some View {
        Button("Save") {
            do {
                try viewModel.saveLiability()
                viewModel.dismissSheet()
            } catch let error as LiabilityValidationError  {
                viewModel.liabilityValidationError = error
                viewModel.showValidationErrorAlert = true
            } catch {}
        }
    }
}

