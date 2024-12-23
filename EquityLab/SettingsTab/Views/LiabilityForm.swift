//
//import SwiftUI
//
//struct LiabilityForm: View {
//    @State var viewModel: LiabilityFormViewModel
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                Spacer()
//                    .frame(maxHeight: 16)
//                Form {
//                    descriptionSection
//                    amountSection
//                    dateSection
//                    if viewModel.liability.isNotNil {
//                        deleteSection
//                    }
//                }
//            }
//            .navigationTitle(viewModel.liability.isNil ? "New Liability" : "Edit Liability")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    cancelButton
//                }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    saveButton
//                }
//            }
//            .alert(isPresented: $viewModel.showValidationErrorAlert, error: viewModel.liabilityValidationError) { _ in
//                Button("OK", role: .cancel) {
//                    viewModel.liabilityValidationError = nil
//                }
//            } message: { _ in }
//            .onTapGesture {
//                hideKeyboard()
//            }
//        }
//    }
//    
//    private var descriptionSection: some View {
//        Section {
//            TextField("creditor", text: $viewModel.liabilityCreditor)
//            TextField("purpose", text: $viewModel.liabilityName)
//            Picker("LiabilityPool", selection: $viewModel.liabilityPool) {
//                ForEach(viewModel.getLiabilityPools()) { pool in
//                    Text(pool.name).tag(pool)
//                }
//                Text("none selected").tag(LiabilityPool?.none)
//            }
//        }
//    }
//    
//    private var amountSection: some View {
//        Section {
//            HStack {
//                Text("initial amount")
//                Spacer()
//                CurrencyInputField(value: $viewModel.liabilityInitialAmount)
//                    .padding(6)
//            }
//            HStack {
//                Text("repaid amount")
//                Spacer()
//                CurrencyInputField(value: $viewModel.liabilityRepaidAmount)
//                    .padding(6)
//            }
//        }
//    }
//    
//    private var dateSection: some View {
//        Section {
//            DatePicker("date", selection: $viewModel.liabilityGrantDate, in: ...Date(), displayedComponents: .date)
//        }
//    }
//    
//    private var deleteSection: some View {
//        Section {
//            HStack(alignment: .center) {
//                Spacer()
//                Button {
//                    viewModel.deleteLiability()
//                    viewModel.dismissSheet()
//                } label: {
//                    Text("Delete")
//                        .foregroundStyle(.red)
//                }
//                Spacer()
//            }
//        }
//    }
//    
//    private var cancelButton: some View {
//        Button("Cancel") {
//            viewModel.dismissSheet()
//        }
//    }
//    
//    private var saveButton: some View {
//        Button("Save") {
//            do {
//                try viewModel.saveLiability()
//                viewModel.dismissSheet()
//            } catch let error as LiabilityValidationError  {
//                viewModel.liabilityValidationError = error
//                viewModel.showValidationErrorAlert = true
//            } catch {}
//        }
//    }
//}
