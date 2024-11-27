import Foundation

extension Decimal {
    var doubleValue: Double {
        nsDecimalNumberValue.doubleValue
    }
    
    var nsDecimalNumberValue: NSDecimalNumber {
        NSDecimalNumber(decimal:self)
    }
}
