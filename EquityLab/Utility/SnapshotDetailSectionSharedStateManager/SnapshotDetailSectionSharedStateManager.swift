class SnapshotDetailSectionSharedStateManager {
    static let shared = SnapshotDetailSectionSharedStateManager()
    
    var lastSelectedSnapshotDetailView: SnapshotDetailView
    var lastSelectedDetailPage: DetailPage
    
    private init() {
        self.lastSelectedSnapshotDetailView = .balanceDetailView
        self.lastSelectedDetailPage = .changeDetailPage
    }
}
