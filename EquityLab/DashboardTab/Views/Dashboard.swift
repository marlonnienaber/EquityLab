import SwiftUI
import Charts
import UIKit

struct Dashboard: View {
    @State var viewModel = DashboardViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.noSnapshotsAvailable {
                    noSnapshotsView
                } else {
                    GeometryReader { geometry in
                        VStack(spacing: 16) {
                            equitySection
                                .frame(height: geometry.size.height * 0.45)
                            snapshotDetailSection
                                .frame(height: geometry.size.height * 0.55)
                        }
                    }
                    .padding([.top, .leading, .trailing], 16)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("Analytics")
        }
    }
    
    private var noSnapshotsView: some View {
        VStack {
            Image(systemName: "tray.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
            Text("no snapshots available for analysis")
        }
        .foregroundColor(Color.primary.opacity(0.4))
    }
    
    private var equitySection: some View {
        GroupBox {
            HStack {
                Text("equity")
                    .bold()
                Spacer()
                Picker("Time Horizon", selection: $viewModel.selectedTimeHorizon) {
                    ForEach(TimeHorizon.allCases) { timeHorizon in
                        Text(timeHorizon.rawValue).tag(timeHorizon)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 235)
            }
            EquityChart(viewModel: viewModel)
        }
    }
    
    private var snapshotDetailSection: some View {
        GroupBox {
            if let selectedSnapshot = viewModel.selectedSnapshot, let date = selectedSnapshot.date {
                HStack {
                    Text(LocalizedLongDateFormatter.shared.string(from: date))
                        .bold()
                    Spacer()
                    Picker("Snapshot Detail View",selection: $viewModel.selectedSnapshotDetailView) {
                        ForEach(SnapshotDetailView.allCases) { detailView in
                            Text(detailView.rawValue).tag(detailView)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .accentColor(.primary)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.2))
                    )
                }
                switch viewModel.selectedSnapshotDetailView {
                case .assetDetailView: assetDetailView
                case .liabilityDetailView: liabilityDetailView
                case .balanceDetailView: balanceDetailView(viewModel: viewModel.getBalanceViewModel(for: selectedSnapshot))
                }
            } else {
                Text("Please select a snapshot by taping on a data point in the equity section to display its details.")
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .groupBoxStyle(PageViewGroupBoxStyle())
        .onAppear{
            viewModel.initializeSelectedSnapshot()
        }
    }
    
    private func balanceDetailView(viewModel: BalanceViewModel) -> some View {
        VStack {
            Spacer()
            BalanceView(viewModel: viewModel)
            Spacer()
        }
    }
    
    private var assetDetailView: some View {
        TabView(selection: $viewModel.selectedDetailPage) {
            VStack {
                ChangenChart(viewModel: ChangeChartViewModel(changeChartType: .assetChangeChart, dashboardViewModel: viewModel))
                Spacer()
                    .frame(height: 45)
            }
            .tag(DetailPage.changeDetailPage)
            VStack {
                DistributionChart(viewModel: DistributionChartViewModel(distributionChartType: .assetDistributionChart, dashboardViewModel: viewModel))
                Spacer()
                    .frame(height: 45)
            }
            .tag(DetailPage.distributionDetailPage)
        }
        .tabViewStyle(PageTabViewStyle())
    }
    
    private var liabilityDetailView: some View {
        TabView(selection: $viewModel.selectedDetailPage) {
            VStack {
                ChangenChart(viewModel: ChangeChartViewModel(changeChartType: .liabilityChangeChart, dashboardViewModel: viewModel))
                Spacer()
                    .frame(height: 45)
            }
            .tag(DetailPage.changeDetailPage)
            VStack {
                DistributionChart(viewModel: DistributionChartViewModel(distributionChartType: .liabilityDistributionChart, dashboardViewModel: viewModel))
                Spacer()
                    .frame(height: 45)
            }
            .tag(DetailPage.distributionDetailPage)
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

private struct PageViewGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .padding([.top, .leading, .trailing])
            .padding(.bottom, 0)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color(UIColor.secondarySystemBackground))
            )
    }
}
