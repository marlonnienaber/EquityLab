import Foundation

struct LoanTransactionAnalyzer {
    func getDayString(for transaction: LoanTransaction) -> String {
        let date = transaction.date
        let calendar = Calendar.current
        let dayComponent = calendar.component(.day, from: date)
        return dayComponent.string
    }
    
    func getMonthString(for transaction: LoanTransaction) -> String {
        let date = transaction.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: date)
    }
    
    func getAmountString(for transaction: LoanTransaction) -> String? {
        LocalizedCurrencyFormatter.shared.string(from: transaction.amount as NSNumber)
    }
}
