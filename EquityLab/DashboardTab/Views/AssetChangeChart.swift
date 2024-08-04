//
//  AssetChangeChart.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 04.08.24.
//

import Foundation
import Charts
import SwiftUI

struct AssetChangenChart: View {
    @Bindable var viewModel: DashboardViewModel
    
    var body: some View {
        Chart {
            ForEach(viewModel.assetChangeCategories) { category in
                BarMark(
                    x: .value("category", category.name),
                    y: .value("value", category.change)
                ).annotation(position: .bottom) {
                    Text(category.change == 0 ? "" :  String(format: "%.1f", category.change) + "%")
                        .font(.caption)
                }.foregroundStyle(category.color)
                    .cornerRadius(5)
            }
        }
        .chartYAxis{
            AxisMarks(values: [0]) { _ in
                AxisGridLine()
            }
        }
        .chartXAxis{
            AxisMarks{
                AxisValueLabel()
            }
        }
        .chartYScale(domain: [
                -viewModel.maxAssetChangePercentage - 11,
                 viewModel.maxAssetChangePercentage + 11
            ]
        )
        .animation(.easeInOut(duration: 0.5))
    }
}
