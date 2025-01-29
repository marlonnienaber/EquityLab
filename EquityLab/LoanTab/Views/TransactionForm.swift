import SwiftUI
import MCEmojiPicker

struct TransactionForm: View {
    @State var viewModel: TransactionFormViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    CurrencyInputView(value: $viewModel.value) {
                        Text("amount")
                    }
                    TextField("note", text: $viewModel.note)
                    DatePicker("date", selection: $viewModel.date, in: ...Date(), displayedComponents: .date)
                        .padding(.vertical, 2)
                }
                Section {
                    Collapsible(labelText: "Gezahlt von \(viewModel.selectedIssuer?.name ?? "dir")") {
                        Picker("", selection: $viewModel.selectedIssuer) {
                            Text("Du").tag(Optional<LoanPartner>.none)
                            Text(viewModel.loanPartner.name).tag(viewModel.loanPartner)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("new transaction")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel"){
                        viewModel.dismissSheet()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        do {
                            try viewModel.saveLoanTransaction()
                            viewModel.dismissSheet()
                        } catch let error as TransactionValidationError  {
                            viewModel.transactionValidationError = error
                            viewModel.showValidationErrorAlert = true
                        } catch {}
                    }
                }
            }
            .alert(isPresented: $viewModel.showValidationErrorAlert, error: viewModel.transactionValidationError) { _ in
                Button("OK", role: .cancel) {
                    viewModel.transactionValidationError = nil
                }
            } message: { _ in }
        }
    }
}

/* TODO: extract to Utility */
struct Collapsible<Content: View>: View {
    @State private var isExpanded: Bool = false
    let labelText: String
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack {
            if isExpanded {
                header
                    .padding(.top, 5)
                Divider()
                    .padding(.vertical, 7)
                corpus
                    .padding(.bottom, 7)
            } else {
                header
                    .padding(.vertical, 5)
            }
        }
    }
    
    private var header: some View {
        Button {
            isExpanded.toggle()
        } label: {
            HStack {
                Text(labelText)
                    .font(.footnote)
                Spacer()
                Image(systemName: "chevron.right")
                    .rotationEffect(.degrees(isExpanded ? 90 : 0))
            }
            .frame(height: 20)
        }
        .buttonStyle(.plain)
    }
    
    private var corpus: some View {
        content()
    }
}
