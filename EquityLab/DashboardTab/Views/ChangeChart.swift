
import Charts
import SwiftUI

struct ChangenChart: View {
    @Binding var noChangesToLastSnapshot: Bool
    @Binding var changeCategories: [BarChartCategory]
    @Binding var maxChangePercentage: Decimal
    let color: Color
    
    var body: some View {
        if noChangesToLastSnapshot {
            Text("there were no changes compared to the last snapshot")
                .multilineTextAlignment(.center)
        } else {
            Chart {
                ForEach(changeCategories, id: \.name) { category in
                    BarMark(
                        x: .value("category", category.name),
                        y: .value("value", category.change)
                    )
                    .annotation(position: .bottom) {
                        Text(category.change == 0 ? "" : category.change.oneDecimalPercentageString)
                            .font(.caption)
                    }
                    .foregroundStyle(color)
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
                -maxChangePercentage - 11,
                maxChangePercentage + 11
            ]
            )
            .animation(.easeInOut(duration: 0.5))
        }
    }
}
