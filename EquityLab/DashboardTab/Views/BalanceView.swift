import SwiftUI

struct BalanceView: View {
    var viewModel: DashboardViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            assetsLine
                .foregroundColor(Color("AssetsUnselected"))
                .padding()
                .frame(maxWidth: .infinity)
            liabilitiesLine
                .foregroundColor(Color("LiabilitiesUnselected"))
                .padding()
                .frame(maxWidth: .infinity)
            equityLine
                .padding()
                .frame(maxWidth: .infinity)
        }
        .padding()
    }
    
    private var assetsLine: some View {
        HStack {
            Image(systemName: "plus.circle")
            Text("Assets")
            Spacer()
            //TODO: actually selectedSnapshot should never be nil if BalanceView is shown. It may make sense to decouple the viewModels of the snapshotDetailSection from the DashboardViewModel and show a noSnapshotSelectedView in the Dashboard whenever no snapshot is selected. This would make this unnecessary check obsolete
            if let selectedSnapshot = viewModel.selectedSnapshot, let assetValueString = LocalizedCurrencyFormatter.shared.string(from: viewModel.getAssetValue(of: selectedSnapshot) as NSNumber) {
                Text(assetValueString)
            }
        }
    }
    
    private var liabilitiesLine: some View {
        HStack {
            Image(systemName: "minus.circle")
            Text("Liabilities")
            Spacer()
            //TODO: see first TODO
            if let selectedSnapshot = viewModel.selectedSnapshot, let liabilityValueString = LocalizedCurrencyFormatter.shared.string(from: viewModel.getLiabilityValue(of: selectedSnapshot) as NSNumber) {
                Text(liabilityValueString)
            }
        }
    }
    
    private var equityLine: some View {
        HStack {
            Image(systemName: "equal.square")
            Text("Equity")
            Spacer()
            //TODO: see first TODO
            if let selectedSnapshot = viewModel.selectedSnapshot, let equityValueString = LocalizedCurrencyFormatter.shared.string(from: viewModel.getEquityValue(of: selectedSnapshot) as NSNumber) {
                Text(equityValueString)
            }
        }
    }
}
