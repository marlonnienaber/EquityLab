//import SwiftUI
//
//struct ReceivableForm: View {
//    @State var viewModel: ReceivableFormViewModel
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
//                    if viewModel.receivable.isNotNil {
//                        deleteSection
//                    }
//                }
//            }
//            .navigationTitle(viewModel.receivable.isNil ? "New Receivable" : "Edit Receivable")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    cancelButton
//                }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    saveButton
//                }
//            }
//            .alert(isPresented: $viewModel.showValidationErrorAlert, error: viewModel.receivableValidationError) { _ in
//                Button("OK", role: .cancel) {
//                    viewModel.receivableValidationError = nil
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
//            TextField("name", text: $viewModel.name)
//            TextField("debtor", text: $viewModel.debtor)
//            Picker("AssetPool", selection: $viewModel.assetPool) {
//                ForEach(viewModel.getAssetPools()) { pool in
//                    Text(pool.name).tag(pool)
//                }
//                Text("none selected").tag(AssetPool?.none)
//            }
//        }
//    }
//    
//    private var amountSection: some View {
//        Section {
//            HStack {
//                Text("initial amount")
//                Spacer()
//                CurrencyInputField(value: $viewModel.initialAmount)
//                    .padding(6)
//            }
//            HStack {
//                Text("repaid amount")
//                Spacer()
//                CurrencyInputField(value: $viewModel.repaidAmount)
//                    .padding(6)
//            }
//        }
//    }
//    
//    private var dateSection: some View {
//        Section {
//            DatePicker("date", selection: $viewModel.grantDate, in: ...Date(), displayedComponents: .date)
//        }
//    }
//    
//    private var deleteSection: some View {
//        Section {
//            HStack(alignment: .center) {
//                Spacer()
//                Button {
//                    viewModel.deleteReceivable()
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
//                try viewModel.saveReceivable()
//                viewModel.dismissSheet()
//            } catch let error as ReceivableValidationError  {
//                viewModel.receivableValidationError = error
//                viewModel.showValidationErrorAlert = true
//            } catch {}
//        }
//    }
//}
