import Foundation

class DateParser {
    static let shared = DateParser()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    func date(from dateString: String) -> Date? {
        return dateFormatter.date(from: dateString)
    }
    
    private init() {}
}
