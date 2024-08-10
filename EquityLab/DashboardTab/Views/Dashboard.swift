//
//  Dashboard.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 15.07.24.
//

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
                snapshotDetailSection
                    .frame(height: geometry.size.height * 0.55)
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
            NetWorthChart(viewModel: viewModel)
        }
    }
    
    private var snapshotDetailSection: some View {
        GroupBox {
            HStack(spacing: 25) {
                if let currentDate = viewModel.selectedSnapshot?.date {
                    Text(LocalizedLongDateFormatter.shared.string(from: currentDate))
                        .bold()
                }
                Picker("Snapshot Detail View",selection: $viewModel.selectedSnapshotDetailView) {
                    ForEach(SnapshotDetailView.allCases) { detailView in
                        Text(detailView.rawValue).tag(detailView)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .accentColor(.primary)
            }
            Group {
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
                    if viewModel.selectedSnapshotDetailView == .assetDetailView {
                        assetDetailView
                    } else {
                        liabilityDetailView
                    }
                }
            }
        }
        .groupBoxStyle(PageViewGroupBoxStyle())
        .onAppear{
            viewModel.initializeSelectedSnapshot()
        }
    }
    
    var assetDetailView: some View {
        TabView {
            VStack {
                ChangenChart(viewModel: ChangeChartViewModel(changeChartType: .assetChangeChart, dashboardViewModel: viewModel))
                Spacer()
                    .frame(height: 45)
            }
            VStack {
                DistributionChart(viewModel: DistributionChartViewModel(distributionChartType: .assetDistributionChart, dashboardViewModel: viewModel))
                Spacer()
                    .frame(height: 45)
            }
        }
        .tabViewStyle(PageTabViewStyle())
    }
    
    var liabilityDetailView: some View {
        TabView {
            VStack {
                ChangenChart(viewModel: ChangeChartViewModel(changeChartType: .liabilityChangeChart, dashboardViewModel: viewModel))
                Spacer()
                    .frame(height: 45)
            }
            VStack {
                DistributionChart(viewModel: DistributionChartViewModel(distributionChartType: .liabilityDistributionChart, dashboardViewModel: viewModel))
                Spacer()
                    .frame(height: 45)
            }
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
