import SwiftUI
import Charts
import UIKit

struct Dashboard: View {
    @State var viewModel = DashboardViewModel()
    
    var body: some View {
        NavigationView {
            dashboardContent
                .padding([.top, .leading, .trailing], 16)
                .padding(.bottom, 32)
                .navigationTitle("Analytics")
        }
    }
    
    private var dashboardContent: some View {
        GeometryReader { geometry in
            VStack(spacing: 16) {
                equitySection
                    .frame(height: geometry.size.height * 0.45)
//                snapshotDetailSection
//                    .frame(height: geometry.size.height * 0.55)
            }
            .navigationTitle("Analytics")
        }
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
            HStack {
                if let selectedSnapshot = viewModel.selectedSnapshot {
                    Text(LocalizedLongDateFormatter.shared.string(from: selectedSnapshot.date))
                        .bold()
                }
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
            if viewModel.selectedSnapshot == nil {
                VStack {
                    Image(systemName: "chart.pie.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                    Text("no snapshot selected")
                }
                .foregroundColor(Color.black.opacity(0.4))
            } else {
                switch viewModel.selectedSnapshotDetailView {
                case .assetDetailView: assetDetailView
                case .liabilityDetailView: liabilityDetailView
                case .balanceDetailView: balanceDetailView
                }
            }
        }
        .groupBoxStyle(PageViewGroupBoxStyle())
        .onAppear{
            viewModel.initializeSelectedSnapshot()
        }
    }
    
    var balanceDetailView: some View {
        VStack {
            Spacer()
            BalanceView(viewModel: viewModel)
            Spacer()
        }
    }
    
    var assetDetailView: some View {
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
    
    var liabilityDetailView: some View {
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

fileprivate struct PageViewGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .padding([.top, .leading, .trailing]) // Default padding on top, leading, and trailing
            .padding(.bottom, 0) // Remove bottom padding
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color(UIColor.secondarySystemBackground)) // Match the default background color
            )
    }
}
