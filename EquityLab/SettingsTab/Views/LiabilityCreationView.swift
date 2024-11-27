
import SwiftUI

struct LiabilityCreationView: View {
    @State var viewModel: LiabilityFormViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                    .frame(maxHeight: 16)
                Form {
                    descriptionSection
                    dataSection
                }
            }
            .navigationTitle("New Liability")
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
            TextField("purpose", text: $viewModel.name)
            NavigationLink {
                PersonSelectionView(viewModel:
                    PersonSelectionViewModel(selectedPerson: viewModel.creditor) { selectedPerson in
                        viewModel.creditor = selectedPerson
                    }
                )
            } label: {
                HStack {
                    Text("Debtor")
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
                try viewModel.createLiability()
                viewModel.dismissSheet()
            } catch let error as LiabilityValidationError  {
                viewModel.liabilityValidationError = error
                viewModel.showValidationErrorAlert = true
            } catch {}
        }
    }
}
