//
//  NetWorthChart.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 15.07.24.
//

import Charts
import SwiftUI

struct EquityChart: View {
    @Bindable var viewModel: DashboardViewModel

    var body: some View {
        Chart(viewModel.filteredSnapshots) { snapshot in
            if let date = snapshot.date {
                let curColor = Color("EquityPrimary")
                let curGradient = LinearGradient(gradient: Gradient(colors: [curColor.opacity(0.1), curColor.opacity(0.2), curColor.opacity(0.5), curColor.opacity(0.6)]), startPoint: .bottom, endPoint: .top)
                let startOfDay = Calendar.current.startOfDay(for: date)
                let equityValue = viewModel.getEquityValue(of: snapshot)
                AreaMark(
                    x: .value("date", Calendar.current.startOfDay(for: date)),
                    y: .value("net worth", equityValue)
                )
                .interpolationMethod(.monotone)
                .foregroundStyle(curGradient)
                
                LineMark(
                    x: .value("date", Calendar.current.startOfDay(for: date)),
                    y: .value("net worth", equityValue)
                )
                .symbol(.circle)
                .symbolSize(100)
                .interpolationMethod(.monotone)
                .lineStyle(StrokeStyle(lineWidth: 5))
                .foregroundStyle(Color("EquityPrimary"))
                
                if let currentSelectedSnapshot = viewModel.selectedSnapshot, currentSelectedSnapshot.date == snapshot.date {
                    RuleMark(x: .value("Selected", startOfDay))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                        .foregroundStyle(Color.primary)
                }
            }
        }
        .chartXSelection(value: $viewModel.selectedDate)
        .chartYAxis {
            AxisMarks(position: .leading) {
                AxisGridLine()
                AxisValueLabel(horizontalSpacing: 20)
            }
        }
        .chartXAxis {
            AxisMarks { _ in
                AxisTick()
                AxisValueLabel()
            }
        }
    }
}
