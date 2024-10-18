
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
                    amountSection
                    dateSection
                    if viewModel.liability != nil {
                        Section {
                            HStack(alignment: .center) {
                                Spacer()
                                Button {
                                    viewModel.deleteLiability()
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
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        viewModel.dismissSheet()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let liability = viewModel.liability {
                            viewModel.updateLiability(liability: liability)
                        } else {
                            viewModel.createLiability()
                        }
                        viewModel.dismissSheet()
                    }
                    .disabled(viewModel.liabilityPool == nil)
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
            .navigationTitle(viewModel.liability == nil ? "New Liability" : "Edit Liability")
        }
    }
    
    private var descriptionSection: some View {
        Section {
            TextField("creditor", text: $viewModel.liabilityCreditor)
            TextField("purpose", text: $viewModel.liabilityName)
            Picker("LiabilityPool", selection: $viewModel.liabilityPool) {
                ForEach(viewModel.getLiabilityPools()) { pool in
                    Text(pool.name).tag(pool)
                }
                Text("none selected").tag(LiabilityPool?.none)
            }
        }
    }
    
    private var amountSection: some View {
        Section {
            HStack {
                Text("initial amount")
                Spacer()
                CurrencyInputField(value: $viewModel.liabilityInitialAmount)
                    .padding(6)
            }
            HStack {
                Text("repaid amount")
                Spacer()
                CurrencyInputField(value: $viewModel.liabilityRepaidAmount)
                    .padding(6)
            }
        }
    }
    
    private var dateSection: some View {
        Section {
            DatePicker("date", selection: $viewModel.liabilityGrantDate, in: ...Date(), displayedComponents: .date)
        }
    }
}
