import Foundation

class DateParser {
    static let shared = DateParser()
    
    private let iso8601Formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()
    
    func date(from dateString: String) -> Date? {
        iso8601Formatter.date(from: dateString)
    }
    
    private init() {}
}
