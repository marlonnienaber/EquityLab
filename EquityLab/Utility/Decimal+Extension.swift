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
    
    func roundTo(decimalPlace: Int) -> Decimal {
        var result = Decimal()
        var input = self
        NSDecimalRound(&result, &input, decimalPlace, .plain)
        return result
    }
}
