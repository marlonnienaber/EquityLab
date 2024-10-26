import SwiftUI
import Charts

struct DistributionChart: View {
    @State var viewModel: DistributionChartViewModel
    
    var body: some View {
        if viewModel.noValuesRecordedForThisSnapshot {
            Text("no positions with positive values were recorded with this snapshot")
                .multilineTextAlignment(.center)
        } else {
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    chart(geometry)
                        .distributionChartPositioning(for: geometry)
                    verticalSeperator(for: geometry)
                    if let selectedCategory = viewModel.selectedCategory {
                        selectedCategoryDetails(selectedCategory: selectedCategory)
                            .selectedCategoryDetailsPositioning()
                    } else {
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
    private func chart(_ geometry: GeometryProxy) -> some View {
        Chart(viewModel.distributionCategories, id: \.self) { category in
            SectorMark(angle: .value("type value", category.value),
                       innerRadius: .ratio(0.65),
                       outerRadius: viewModel.calculateOuterRadius(for: geometry, and: category),
                       angularInset: 3)
            .foregroundStyle(viewModel.color)
            .cornerRadius(5)
        }
        .frame(width: viewModel.calculateFrameLength(for: geometry), height: viewModel.calculateFrameLength(for: geometry))
        .chartAngleSelection(value: $viewModel.selectedCumulativeValue)
        .chartGesture { chart in
            SpatialTapGesture()
                .onEnded { event in
                    let angle = chart.angle(at: event.location)
                    chart.selectAngleValue(at: angle)
                }
        }
        .chartBackground { _ in
            if let percentageString = viewModel.getSelectedCategoryPercentageString() {
                Text(percentageString)
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
    
    @ViewBuilder
    private func selectedCategoryDetails(selectedCategory: DonutChartCategory) -> some View {
        if selectedCategory.pools.count > 3 {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(selectedCategory.pools[0...2], id: \.self) { pool in
                        VStack(alignment: .leading) {
                            Text(pool.name)
                            Text(viewModel.getValueString(for: pool))
                                .font(.system(size: 13))
                            Text(viewModel.getPercentageString(for: pool))
                                .font(.system(size: 13))
                        }
                    }
                    HStack {
                        Button {
                            viewModel.showPopover.toggle()
                        } label: {
                            Image(systemName: "info.circle")
                        }
                        .foregroundColor(.primary)
                        .popover(isPresented: $viewModel.showPopover) {
                            ScrollView {
                                VStack(alignment: .leading, spacing: 10) {
                                    ForEach(selectedCategory.pools[3..<selectedCategory.pools.count], id: \.self) { hiddenPool in
                                        VStack(alignment: .leading) {
                                            Text(hiddenPool.name)
                                            Text(viewModel.getValueString(for: hiddenPool))
                                                .font(.system(size: 13))
                                            Text(viewModel.getPercentageString(for: hiddenPool))
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
                        Text(viewModel.getValueString(for: pool))
                            .font(.system(size: 13))
                        Text(viewModel.getPercentageString(for: pool))
                            .font(.system(size: 13))
                    }
                }
            }
        } else {
            VStack(alignment: .leading) {
                Text(selectedCategory.pools.first!.name)
                Text(viewModel.getValueString(for: selectedCategory.pools.first!))
                    .font(.system(size: 13))
            }
        }
    }
    
    private func verticalSeperator(for geometry: GeometryProxy) -> some View {
        Rectangle()
            .frame(width: 1.2, height: geometry.size.height * 0.8)
            .foregroundColor(.gray.opacity(0.35))
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
