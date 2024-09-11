import Foundation
import SwiftUI

struct LiabilityForm: View {
    @State var viewModel: LiabilityFormViewModel
    @Binding public var liabilityLedgerActiveSheet: LiabilityLedgerSheetType?
    
    var body: some View {
        NavigationView {
            Form {
                DescriptionSection
                AmountSection
                DateSection
            }.toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", action: { liabilityLedgerActiveSheet = nil } )
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let liability = viewModel.liability {
                            viewModel.updateLiability(liability: liability)
                        } else {
                            viewModel.createLiability()
                        }
                        liabilityLedgerActiveSheet = nil
                    }
                }
            }.onTapGesture {
                hideKeyboard()
            }.navigationTitle(viewModel.liability == nil ? "new Liability" : "edit Liability")
        }
    }
    
    @ViewBuilder fileprivate var DescriptionSection: some View {
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
    
    @ViewBuilder fileprivate var AmountSection: some View {
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
    
    @ViewBuilder fileprivate var DateSection: some View {
        Section {
            DatePicker("date", selection: $viewModel.liabilityGrantDate, in: ...Date(), displayedComponents: .date)
        }
    }

}
