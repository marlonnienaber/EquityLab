
import SwiftUI

struct LiabilityForm: View {
    @State var viewModel: LiabilityFormViewModel
    
    var body: some View {
        NavigationView {
            Form {
                descriptionSection
                amountSection
                dateSection
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
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
            .navigationTitle(viewModel.liability == nil ? "new Liability" : "edit Liability")
        }
    }
    
    private var descriptionSection: some View {
        Section {
            TextField("creditor", text: $viewModel.liabilityCreditor)
            TextField("purpose", text: $viewModel.liabilityName)
            HStack {
                Spacer()
                Text("(20 characters max)")
                    .font(.footnote)
                    .foregroundColor(Color.gray)
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
