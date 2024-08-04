//
//  AssetDistributionChart.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 15.07.24.
//

import SwiftUI
import Charts

struct AssetDistributionChart: View {
    @Bindable var viewModel: DashboardViewModel
    
    var body: some View {
        Chart(viewModel.assetDistributionCategories) { category in
            SectorMark(angle: .value("type value", category.value),
                       innerRadius: .ratio(0.65),
                       outerRadius: viewModel.selectedAssetCategory?.name == category.name ? 120 : 110,
                       angularInset: 3)
            .foregroundStyle(category.color)
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
            if let selectedCategory = viewModel.selectedAssetCategory {
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
                    viewModel.setSelectedCategoryForNewCumulatveValue(cumulativeValue: newValue)
                }
            }
        }
        .onChange(of: viewModel.selectedSnapshot) {
            viewModel.setSelectedCategoryForNewSnapshot()
        }
    }
}
