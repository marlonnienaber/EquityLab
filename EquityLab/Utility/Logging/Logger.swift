import os

extension Logger {
    init<T>(subsystem: Subsystem, component: T.Type) {
        let category = String(describing: component)
        self.init(subsystem: subsystem.rawValue, category: category)
    }
    
    enum Subsystem: String {
        case dashboardTab = "dashboard tab"
    }
}
