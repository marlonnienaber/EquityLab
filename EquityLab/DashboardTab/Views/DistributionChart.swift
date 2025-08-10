import SwiftUI
import Charts

struct DistributionChart: View {
    @Binding var selectedCumulativeValue: Decimal?
    @Binding var showPopover: Bool
    @Binding var distributionCategories: [DonutChartCategory]
    @Binding var selectedCategory: DonutChartCategory?
    @Binding var noPositiveDistributionCategoriesRecorded: Bool
    let color: Color
    let setSelectedDistributionCategoryWith: (Decimal) -> Void
    
    var body: some View {
        if noPositiveDistributionCategoriesRecorded {
            Text("no positions with positive values were recorded with this snapshot")
                .multilineTextAlignment(.center)
        } else {
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    chart(geometry)
                        .distributionChartPositioning(for: geometry)
                    verticalSeperator(for: geometry)
                    if let selectedCategory = selectedCategory {
                        selectedCategoryDetails(selectedCategory: selectedCategory)
                            .selectedCategoryDetailsPositioning()
                    } else {
                        Spacer()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private func chart(_ geometry: GeometryProxy) -> some View {
        Chart(distributionCategories, id: \.self) { category in
            SectorMark(angle: .value("type value", category.value),
                       innerRadius: .ratio(0.65),
                       outerRadius: calculateOuterRadius(for: geometry, and: category),
                       angularInset: 3)
            .foregroundStyle(color)
            .cornerRadius(5)
        }
        .frame(width: calculateFrameLength(for: geometry), height: calculateFrameLength(for: geometry))
        .chartAngleSelection(value: $selectedCumulativeValue)
        .chartGesture { chart in
            SpatialTapGesture()
                .onEnded { event in
                    let angle = chart.angle(at: event.location)
                    chart.selectAngleValue(at: angle)
                }
        }
        .chartBackground { _ in
            if let percentageString = percentageString{
                Text(percentageString)
            }
        }
        .onChange(of: selectedCumulativeValue) { oldValue, newValue in
            if let newValue {
                withAnimation {
                    setSelectedDistributionCategoryWith(newValue)
                }
            }
        }
    }
    
    @ViewBuilder
    private func selectedCategoryDetails(selectedCategory: DonutChartCategory) -> some View {
        if selectedCategory.pools.count > 3 {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(selectedCategory.pools[0...2], id: \.self) { pool in
                        VStack(alignment: .leading) {
                            Text(pool.name)
                            Text(pool.value.currencyString)
                                .font(.system(size: 13))
                            Text(pool.percentage.oneDecimalPercentageString)
                                .font(.system(size: 13))
                        }
                    }
                    HStack {
                        Button {
                            showPopover.toggle()
                        } label: {
                            Image(systemName: "info.circle")
                        }
                        .foregroundColor(.primary)
                        .popover(isPresented: $showPopover) {
                            ScrollView {
                                VStack(alignment: .leading, spacing: 10) {
                                    ForEach(selectedCategory.pools[3..<selectedCategory.pools.count], id: \.self) { hiddenPool in
                                        VStack(alignment: .leading) {
                                            Text(hiddenPool.name)
                                            Text(hiddenPool.value.currencyString)
                                                .font(.system(size: 13))
                                            Text(hiddenPool.percentage.oneDecimalPercentageString)
                                                .font(.system(size: 13))
                                        }
                                    }
                                }
                            }
                            .padding()
                            .presentationCompactAdaptation(.popover)
                        }
                        Text("other")
                    }
                }
        } else if selectedCategory.pools.count > 1 {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(selectedCategory.pools, id: \.self) { pool in
                    VStack(alignment: .leading) {
                        Text(pool.name)
                        Text(pool.value.currencyString)
                            .font(.system(size: 13))
                        Text(pool.percentage.oneDecimalPercentageString)
                            .font(.system(size: 13))
                    }
                }
            }
        } else {
            VStack(alignment: .leading) {
                Text(selectedCategory.pools.first!.name)
                Text(selectedCategory.pools.first!.value.currencyString)
                    .font(.system(size: 13))
            }
        }
    }
    
    private func verticalSeperator(for geometry: GeometryProxy) -> some View {
        Rectangle()
            .frame(width: 1.2, height: geometry.size.height * 0.8)
            .foregroundColor(.gray.opacity(0.35))
    }
    
    private var percentageString: String? {
        selectedCategory?.percentage.oneDecimalPercentageString
    }
    
    private func calculateFrameLength(for geometry: GeometryProxy) -> CGFloat {
        let maxWidth = geometry.size.width * 0.5
        let maxHeight = geometry.size.height
        return min(maxWidth, maxHeight)
    }
    
    private func calculateOuterRadius(for geometry: GeometryProxy, and category: DonutChartCategory) -> MarkDimension {
        let chartSize = calculateFrameLength(for: geometry)
        if chartSize >= 170 {
            return selectedCategory == category ? 95 : 82
        } else if chartSize >= 155 {
            return selectedCategory == category ? 80 : 73
        } else {
            return selectedCategory == category ? 70 : 63
        }
    }
}

struct DistributionChartPositioning: ViewModifier {
    var geometry: GeometryProxy
    
    func body(content: Content) -> some View {
        HStack {
            Spacer()
            content
            Spacer()
                .frame(width: 20)
        }
        .frame(width: geometry.size.width * 0.58)
        .frame(maxHeight: .infinity)
    }
}

struct SelectedCategoryDetailsPositioning: ViewModifier {
    func body(content: Content) -> some View {
        Spacer()
            .frame(width: 20)
        content
        Spacer()
    }
}

extension View {
    func distributionChartPositioning(for geometry: GeometryProxy) -> some View {
        self.modifier(DistributionChartPositioning(geometry: geometry))
    }
    
    func selectedCategoryDetailsPositioning() -> some View {
        self.modifier(SelectedCategoryDetailsPositioning())
    }
}
