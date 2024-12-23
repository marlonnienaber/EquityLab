import Foundation

struct ReceivableAnalyzer {
    private let repository: AssetRepository
    
    init(repository: AssetRepository) {
        self.repository = repository
    }
    
    func calculateDisbursedAmount(for receivable: Receivable) -> Decimal {
        let transactions = repository.getTransactions().filter{ $0.receivable == receivable }
        return transactions.filter{ $0.issuer.isNil }.map{ $0.amount.decimalValue }.reduce(0, +)
    }
    
    func calculateOpenAmount(for receivable: Receivable) -> Decimal {
        let transactions = repository.getTransactions().filter{ $0.receivable == receivable }
        let disbursedAmount = transactions.filter{ $0.issuer.isNil }.map{ $0.amount.decimalValue }.reduce(0, +)
        let repayedAmount = transactions.filter{ $0.issuer.isNotNil }.map{ $0.amount.decimalValue }.reduce(0, +)
        return disbursedAmount - repayedAmount
    }
    
    func calculateRepaymentPercentage(for receivable: Receivable) -> Decimal {
        let transactions = repository.getTransactions().filter{ $0.receivable == receivable }
        let disbursedAmount = transactions.filter{ $0.issuer.isNil }.map{ $0.amount.decimalValue }.reduce(0, +)
        print("disbursedAmount: \(disbursedAmount)")
        let repayedAmount = transactions.filter{ $0.issuer.isNotNil }.map{ $0.amount.decimalValue }.reduce(0, +)
        print("repayedAmount: \(repayedAmount)")
        return repayedAmount / disbursedAmount
    }
}
