
import SwiftUI
import CoreData

struct LiabilityLedger: View {
    @State var viewModel = LiabilityLedgerViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.pools) { pool in
                    Section(pool.name) {
                        sectionContent(pool: pool, sectionLiabilities: viewModel.liabilities(for: pool))
                        sectionControls(for: pool)
                    }
                }
            }
            .navigationTitle("Liabilities")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                        .disabled(viewModel.pools.isEmpty)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.resetPoolVariables()
                        viewModel.showCreatePoolAlert = true
                    } label: {
                        Text("new pool")
                    }
                }
            }
        }
        .sheet(item: $viewModel.activeSheet) { activeSheet in
            switch activeSheet {
            case .addSheetLiability(let pool): LiabilityForm(viewModel: LiabilityFormViewModel(pool: pool, allLiabilities: viewModel.allLiabilities()), liabilityLedgerActiveSheet: $viewModel.activeSheet)
            case .updateSheetLiability(let liability): LiabilityForm(viewModel: LiabilityFormViewModel(liability: liability, allLiabilities: viewModel.allLiabilities()), liabilityLedgerActiveSheet: $viewModel.activeSheet)
            }
        }
        
    }
    
    func sectionContent(pool: LiabilityPool, sectionLiabilities: [Liability]) -> some View {
        ForEach(sectionLiabilities) { liability in
            Button {
                viewModel.activeSheet = .updateSheetLiability(liability: liability)
            } label: {
                HStack{
                    if let initialAmountStringRepresentation = LocalizedCurrencyFormatter.shared.string(from: NSNumber(value: liability.initialAmount)) {
                        VStack(alignment: .leading) {
                            Text(liability.name)
                                .foregroundColor(Color.primary)
                            Text(liability.creditor)
                                .font(.footnote)
                                .foregroundColor(Color.gray)
                            Text(initialAmountStringRepresentation)
                                .font(.footnote)
                                .foregroundColor(Color.gray)
                        }
                        Spacer()
                        CircularProgressView(progress: liability.repaymentPercentage)
                            .frame(width: 37, height: 37)
                    }
                }
            }
        }
        .onDelete{ indexSet in
            viewModel.deleteLiabilities(in: pool, for: indexSet)
        }
    }
        
    func sectionControls(for pool: LiabilityPool) -> some View {
        HStack{
            Button {
                viewModel.activeSheet = LiabilityLedgerSheetType.addSheetLiability(pool: pool)
            } label: {
                HStack{
                    Image(systemName: "plus")
                    Text("new liability")
                }
            }
            .buttonStyle(BorderlessButtonStyle())
            Spacer()
            Button {
                viewModel.pool = pool
                viewModel.poolName = pool.name
                viewModel.showEditPoolAlert = true
            } label: {
                Image(systemName: "slider.horizontal.3")
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .alert("What should the name of the new pool be?", isPresented: $viewModel.showCreatePoolAlert) {
            TextField("Value", text: $viewModel.poolName)
            Button("Cancel") {
                viewModel.showCreatePoolAlert = false
            }
            Button("Save") {
                viewModel.createLiabilityPool()
            }
        }
        .alert("Edit \(viewModel.pool?.name ?? "")", isPresented: $viewModel.showEditPoolAlert) {
            TextField("Value", text: $viewModel.poolName)
            Button("Cancel", role: .cancel) {
                viewModel.showEditPoolAlert = false
            }
            Button("Save") {
                viewModel.updateLiabilityPool()
            }
            Button("Delete", role: .destructive) {
                viewModel.deleteLiabilityPool()
            }
        }
    }
}
