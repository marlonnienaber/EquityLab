import Foundation

extension Date {
    public var startOfDay: Date {
        let startOfDay = Calendar.current.startOfDay(for: self)
        return startOfDay
    }
    
    enum Month: String, Identifiable, Comparable, Hashable {
        case january
        case february
        case march
        case april
        case may
        case june
        case july
        case august
        case september
        case october
        case november
        case december
        
        var id: String {
            self.rawValue
        }
        
        static func < (lhs: Month, rhs: Month) -> Bool {
            let allMonths: [Month] = [.january, .february, .march, .april, .may, .june, .july, .august, .september, .october, .november, .december]
            return allMonths.firstIndex(of: lhs)! < allMonths.firstIndex(of: rhs)!
        }
    }
}

struct MonthYear: Hashable {
    let month: Date.Month
    let year: Int
    
    init?(date: Date) {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "en_US")
        let components = calendar.dateComponents([.month, .year], from: date)
        guard let monthInt = components.month, let year = components.year else { return nil }
        guard let month = Date.Month(rawValue: calendar.monthSymbols[monthInt - 1].lowercased()) else { return nil }
        self.month = month
        self.year = year
    }
}
