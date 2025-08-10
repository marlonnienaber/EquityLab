import SwiftUI

extension Binding {
    static func readOnly(_ get: @escaping () -> Value) -> Binding<Value> {
        Binding(get: get, set: { _ in })
    }
}
