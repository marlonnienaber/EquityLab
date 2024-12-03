import Foundation

extension Decimal {
    var nsDecimalNumberValue: NSDecimalNumber {
        NSDecimalNumber(decimal: self)
    }
    
    var doubleValue: Double {
        nsDecimalNumberValue.doubleValue
    }
    
    var oneDecimalPercentageString: String {
        String(format: "%.1f", self.doubleValue) + "%"
    }
}
