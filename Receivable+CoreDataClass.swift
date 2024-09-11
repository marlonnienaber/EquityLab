import CoreData

@objc(Receivable)
public class Receivable: Asset {
    
    public var repaymentPercentage: Double {
        /* TODO: make sure that initial amount cannot be <= 0 */
        repaidAmount / initialAmount
    }
    
    public var openAmount: Double {
        /* TODO: make sure that repaid amount cannot be < 0 or bigger than initial amount */
        initialAmount - repaidAmount
    }

}
