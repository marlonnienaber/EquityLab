
import Charts
import SwiftUI

struct ChangenChart: View {
    @State var viewModel: ChangeChartViewModel
    
    var body: some View {
        if viewModel.noChangesToLastSnapshot {
            Text("there were no changes compared to the last snapshot")
                .multilineTextAlignment(.center)
        } else {
            Chart {
                ForEach(viewModel.changeCategories) { category in
                    BarMark(
                        x: .value("category", category.name),
                        y: .value("value", category.change)
                    )
                    .annotation(position: .bottom) {
                        Text(category.change == 0 ? "" :  String(format: "%.1f", category.change) + "%")
                            .font(.caption)
                    }
                    .foregroundStyle(viewModel.changeChartColor)
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
                -viewModel.maxChangePercentage - 11,
                 viewModel.maxChangePercentage + 11
            ]
            )
            .animation(.easeInOut(duration: 0.5))
        }
    }
}
