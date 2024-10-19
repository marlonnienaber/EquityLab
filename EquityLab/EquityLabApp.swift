import SwiftUI

@main
struct EquityLabApp: App {
    /* TODO: prevent that entities with same name are created or updated to a name that already exists */
    /* TODO: prevent that snapshots with a date that already exists are created / thta existing snapshots are updated tp a date that already exists */
    /* TODO: search for divisions and check whether division by zero is treated sufficiently */
    var body: some Scene {
        WindowGroup {
            TabView {
                Dashboard().tabItem{
                    Image(systemName: "chart.bar.xaxis")
                }
                SnapshotLedger().tabItem {
                    Image(systemName: "camera.aperture")
                }
                SettingsView().tabItem {
                    Image(systemName: "gear")
                }
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
