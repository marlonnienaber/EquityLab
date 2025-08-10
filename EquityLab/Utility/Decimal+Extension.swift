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
    
    var currencyString: String {
        LocalizedCurrencyFormatter.shared.string(from: self as NSNumber) ?? ""
    }
    
    func roundTo(decimalPlace: Int) -> Decimal {
        var result = Decimal()
        var input = self
        NSDecimalRound(&result, &input, decimalPlace, .plain)
        return result
    }
}
