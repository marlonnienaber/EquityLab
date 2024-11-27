import Foundation

struct LiabilityAnalyzer {
    private let repository: LiabilityRepository
    
    init(repository: LiabilityRepository) {
        self.repository = repository
    }
    
    func calculateDisbursedAmount(for liability: Liability) -> Decimal {
        let transactions = repository.liabilityTransactions.filter{ $0.liability == liability}
        return transactions.filter{ $0.issuer.isNotNil }.map{ $0.amount.decimalValue }.reduce(0, +)
    }
    
    func calculateOpenAmount(for liability: Liability) -> Decimal {
        let transactions = repository.liabilityTransactions.filter{ $0.liability == liability}
        let disbursedAmount = transactions.filter{ $0.issuer.isNotNil }.map{ $0.amount.decimalValue }.reduce(0, +)
        let repayedAmount = transactions.filter{ $0.issuer.isNil }.map{ $0.amount.decimalValue }.reduce(0, +)
        return disbursedAmount - repayedAmount
    }
    
    func calculateRepaymentPercentage(for liability: Liability) -> Decimal {
        let transactions = repository.liabilityTransactions.filter{ $0.liability == liability}
        let disbursedAmount = transactions.filter{ $0.issuer.isNotNil }.map{ $0.amount.decimalValue }.reduce(0, +)
        let repayedAmount = transactions.filter{ $0.issuer.isNil }.map{ $0.amount.decimalValue }.reduce(0, +)
        return repayedAmount / disbursedAmount
    }
}
