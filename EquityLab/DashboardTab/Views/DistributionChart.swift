import SwiftUI
import Charts

struct DistributionChart: View {
    @State var viewModel: DistributionChartViewModel
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                chart(geometry)
                    .distributionChartPositioning(for: geometry)
                verticalSeperator(for: geometry)
                if let selectedCategory = viewModel.selectedCategory {
                    selectedCategoryDetails(selectedCategory: selectedCategory)
                        .selectedCategoryDetailsPositioning()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private func chart(_ geometry: GeometryProxy) -> some View {
        Chart(viewModel.distributionCategories, id: \.name) { category in
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
            if let selectedCategory = viewModel.selectedCategory {
                Text(viewModel.getSelectedCategoryPercentageString())
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
    
    private func selectedCategoryDetails(selectedCategory: DonutChartCategory) -> some View {
        VStack(alignment: .leading) {
            Text(selectedCategory.name)
            Text(viewModel.getSelectedCategoryValueString())
                .font(.system(size: 13))
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
