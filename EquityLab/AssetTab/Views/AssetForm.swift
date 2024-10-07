import SwiftUI
import CoreData

struct AssetForm: View {
    @State public var viewModel: AssetFormViewModel
    
    var body: some View {
        NavigationView{
            VStack {
                if viewModel.asset == nil {
                    Picker(selection: $viewModel.selectedAssetType) {
                        Text("possession").tag(Asset.SubType.possession)
                        Text("receivable").tag(Asset.SubType.receivable)
                    } label: {
                        Text("picker")
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 180)
                    .padding(.top)
                }
                formSection
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel") {
                                viewModel.dismissSheet()
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Save") {
                                viewModel.saveAsset()
                                viewModel.dismissSheet()
                            }
                        }
                    }
                    .onTapGesture {
                        hideKeyboard()
                    }
            }
            .navigationTitle(viewModel.asset == nil ? "new Asset" : "edit Asset")
        }
    }
    
    @ViewBuilder
    var formSection: some View {
        if viewModel.asset == nil {
            switch viewModel.selectedAssetType {
                case .possession: possessionFormSection
                case .receivable: receivableFormSection
            }
        } else {
            if let _ = viewModel.asset as? Possession {
                possessionFormSection
            } else {
                receivableFormSection
            }
        }
    }
    
    var possessionFormSection: some View {
        Form {
            TextField("name", text: $viewModel.assetName)
            Toggle(isOn: $viewModel.possessionIsVolatile) {
                HStack{
                    Text("volatile asset?")
                    Spacer()
                    Button{
                        viewModel.showPopover.toggle()
                    } label: {
                        Image(systemName: "info.circle")
                    }
                    .popover(isPresented: $viewModel.showPopover) {
                        Text("the latest value of non-volatile assets will be reused when taking a new snapshot")
                            .presentationCompactAdaptation(.popover)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                
            }
        }
    }
    
    var receivableFormSection: some View {
        Form {
            Section {
                TextField("debtor", text: $viewModel.receivableDebtor)
                TextField("purpose", text: $viewModel.assetName)
                HStack {
                    Spacer()
                    Text("(20 characters max)")
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                }
            }
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
            Section {
                DatePicker("date", selection: $viewModel.receivableGrantDate, in: ...Date(), displayedComponents: .date)
            }
        }
    }
}
