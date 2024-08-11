//
//  AssetDistributionChart.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 15.07.24.
//

import SwiftUI
import Charts

struct DistributionChart: View {
    @State var viewModel: DistributionChartViewModel
    
    var body: some View {
        Chart(viewModel.distributionCategories) { category in
            SectorMark(angle: .value("type value", category.value),
                       innerRadius: .ratio(0.65),
                       outerRadius: viewModel.selectedCategory?.name == category.name ? 115 : 95,
                       angularInset: 3)
            .foregroundStyle(viewModel.unselectedColor)
            .cornerRadius(5)
        }
        .chartAngleSelection(value: $viewModel.selectedCumulativeValue)
        .chartGesture { chart in
            SpatialTapGesture()
                .onEnded { event in
                    let angle = chart.angle(at: event.location)
                    chart.selectAngleValue(at: angle)
                }
        }
        .chartBackground { _ in
            if let selectedCategory = viewModel.selectedCategory {
                VStack {
                    Text(selectedCategory.name)
                    Text(viewModel.getSelectedCategoryValueString())
                    Text(viewModel.getSelectedCategoryPercentageString())
                }
            }
        }
        .onChange(of: viewModel.selectedCumulativeValue) { oldValue, newValue in
            if let newValue {
                withAnimation {
                    viewModel.setSelectedCategoryForNewCumulativeValue(cumulativeValue: newValue)
                }
            }
        }
        .onChange(of: viewModel.dashboardViewModel.selectedSnapshot) {
            viewModel.setSelectedCategoryForNewSnapshot()
        }
    }
}
