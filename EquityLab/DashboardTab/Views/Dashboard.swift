//
//  Dashboard.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 15.07.24.
//

import SwiftUI
import Charts

struct Dashboard: View {
    @State var viewModel = DashboardViewModel()
    
    var body: some View {
        NavigationView {
            dashboardContent
                .navigationTitle("Analytics")
        }
    }
    
    private var dashboardContent: some View {
        VStack {
            equitySection
            distributionSection
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
                .frame(maxHeight: 160)
        }
        .padding()
    }
    
    private var distributionSection: some View {
        AssetDistributionChart(viewModel: viewModel)
    }
}
