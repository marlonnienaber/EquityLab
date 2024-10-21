@testable import EquityLab
import CoreData

struct LoanManagementViewModelTestDataProvider {
    func createAndPersistTestObjects_deleteReceivablesWithIndices_1(using context: NSManagedObjectContext) -> (IndexSet,[Receivable]) {
        let date_23_04_1970 = DateParser.shared.date(from: "1970-04-23T00:00:00")!
        let date_21_10_1966 = DateParser.shared.date(from: "1966-10-21T00:00:00")!
        let date_01_01_2002 = DateParser.shared.date(from: "2002-01-01T00:00:00")!
        let date_26_04_2002 = DateParser.shared.date(from: "2002-04-26T00:00:00")!
        let receivable1 = DataFactory.createReceivable(name: "Blitz",
                                                       date: date_23_04_1970,
                                                       debtor: "Lenni",
                                                       initialAmount: 50.0,
                                                       repaidAmount: 0.0,
                                                       context: context)
        let receivable2 = DataFactory.createReceivable(name: "Lola Bar",
                                                       date: date_21_10_1966,
                                                       debtor: "Lenni",
                                                       initialAmount: 20.0,
                                                       repaidAmount: 0.0,
                                                       context: context)
        let receivable3 = DataFactory.createReceivable(name: "Haushalt",
                                                       date: date_01_01_2002,
                                                       debtor: "Philipp",
                                                       initialAmount: 200.0,
                                                       repaidAmount: 0.0,
                                                       context: context)
        let receivable4 = DataFactory.createReceivable(name: "PRST",
                                                       date: date_26_04_2002,
                                                       debtor: "Filip",
                                                       initialAmount: 50.0,
                                                       repaidAmount: 0.0,
                                                       context: context)
        return (IndexSet(),[receivable1, receivable2, receivable3, receivable4])
    }
}
