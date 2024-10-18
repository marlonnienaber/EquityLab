import SwiftUI

@main
struct EquityLabApp: App {
    /* TODO: search for divisions and check whether division by zero is treated sufficiently */
    var body: some Scene {
        WindowGroup {
            TabView {
                Dashboard().tabItem{
                    Image(systemName: "chart.bar.xaxis")
                }
                AssetLedger().tabItem {
                    Image(systemName: "dollarsign.circle")
                }
                LiabilityLedger().tabItem {
                    Image(systemName: "person.line.dotted.person.fill")
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
