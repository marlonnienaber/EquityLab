//
//  EquityLabApp.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 14.07.24.
//

import SwiftUI

@main
struct EquityLabApp: App {
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
            }
        }.environment(\.managedObjectContext, ProductionCoreDataStack.shared.context)
    }
}

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
