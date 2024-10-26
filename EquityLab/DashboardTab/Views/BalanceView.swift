import SwiftUI

struct BalanceView: View {
    let viewModel: BalanceViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            assetsLine
                .foregroundColor(.assetsUnselected)
                .padding()
                .frame(maxWidth: .infinity)
            liabilitiesLine
                .foregroundColor(.liabilitiesUnselected)
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
            Text(viewModel.assetValueString)
        }
    }
    
    private var liabilitiesLine: some View {
        HStack {
            Image(systemName: "minus.circle")
            Text("Liabilities")
            Spacer()
            Text(viewModel.liabilityValueString)
        }
    }
    
    private var equityLine: some View {
        HStack {
            Image(systemName: "equal.square")
            Text("Equity")
            Spacer()
            Text(viewModel.equityValueString)
        }
    }
}
