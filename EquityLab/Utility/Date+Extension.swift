import Foundation

extension Date {
    public var startOfDay: Date {
        let startOfDay = Calendar.current.startOfDay(for: self)
        return startOfDay
    }
}
