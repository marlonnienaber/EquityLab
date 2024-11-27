import Observation
import Foundation
import os

@Observable
class TransactionDetailViewModel {
    private static let logger = Logger(subsystem: .loanManagementTab, component: .transactionDetailViewModel)
    
    private let assetRepository: AssetRepository
    
    let transaction: Transaction?
    let debtor: Person
    
    var value: Decimal
    var note: String
    var date: Date
    var issuerOptionsOpen = false
    var selectedIssuer: Person?
    
    init(transaction: Transaction? = nil, debtor: Person, assetRepository: AssetRepository = .production) {
        self.assetRepository = assetRepository
        self.transaction = transaction
        self.debtor = debtor
        
        self.value = transaction?.amount.decimalValue ?? 0
        self.note = transaction?.note ?? ""
        self.date = transaction?.date ?? .now
    }
}
