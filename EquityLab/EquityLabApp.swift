import SwiftUI

@main
struct EquityLabApp: App {
    /* TODO: search for divisions and check whether division by zero is treated sufficiently */
    /* TODO: exchange callback logic with binding logic for all repositories */
    var body: some Scene {
        WindowGroup {
            TabView {
                Dashboard().tabItem{
                    Image(systemName: "chart.bar.xaxis")
                }
                SnapshotLedger().tabItem {
                    Image(systemName: "camera.aperture")
                }
                LoanManagementView().tabItem {
                    Image(systemName: "person.line.dotted.person.fill")
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
