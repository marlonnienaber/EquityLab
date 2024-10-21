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
    
    func createAndPersistTestObjects_deleteReceivablesWithIndices_2(using context: NSManagedObjectContext) -> (IndexSet,[Receivable]) {
        let date_23_04_1970 = DateParser.shared.date(from: "1970-04-23T00:00:00")!
        let date_21_10_1966 = DateParser.shared.date(from: "1966-10-21T00:00:00")!
        let date_01_01_2002 = DateParser.shared.date(from: "2002-01-01T00:00:00")!
        let date_26_04_2002 = DateParser.shared.date(from: "2002-04-26T00:00:00")!
        let receivable1 = DataFactory.createReceivable(name: "Blitz",
                                                       date: date_21_10_1966,
                                                       debtor: "Lenni",
                                                       initialAmount: 50.0,
                                                       repaidAmount: 0.0,
                                                       context: context)
        let receivable2 = DataFactory.createReceivable(name: "Lola Bar",
                                                       date: date_23_04_1970,
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
        return (IndexSet(integer: 0),[receivable2, receivable3, receivable4])
    }

    func createAndPersistTestObjects_deleteReceivablesWithIndices_3(using context: NSManagedObjectContext) -> (IndexSet,[Receivable]) {
        let date_23_04_1970 = DateParser.shared.date(from: "1970-04-23T00:00:00")!
        let date_21_10_1966 = DateParser.shared.date(from: "1966-10-21T00:00:00")!
        let date_01_01_2002 = DateParser.shared.date(from: "2002-01-01T00:00:00")!
        let date_26_04_2002 = DateParser.shared.date(from: "2002-04-26T00:00:00")!
        let receivable1 = DataFactory.createReceivable(name: "Blitz",
                                                       date: date_21_10_1966,
                                                       debtor: "Lenni",
                                                       initialAmount: 50.0,
                                                       repaidAmount: 0.0,
                                                       context: context)
        let receivable2 = DataFactory.createReceivable(name: "Lola Bar",
                                                       date: date_23_04_1970,
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
        return (IndexSet(integer: 3),[receivable1, receivable2, receivable3])
    }
    
    func createAndPersistTestObjects_deleteReceivablesWithIndices_4(using context: NSManagedObjectContext) -> (IndexSet,[Receivable]) {
        let date_23_04_1970 = DateParser.shared.date(from: "1970-04-23T00:00:00")!
        let date_21_10_1966 = DateParser.shared.date(from: "1966-10-21T00:00:00")!
        let date_01_01_2002 = DateParser.shared.date(from: "2002-01-01T00:00:00")!
        let date_26_04_2002 = DateParser.shared.date(from: "2002-04-26T00:00:00")!
        let receivable1 = DataFactory.createReceivable(name: "Blitz",
                                                       date: date_21_10_1966,
                                                       debtor: "Lenni",
                                                       initialAmount: 50.0,
                                                       repaidAmount: 0.0,
                                                       context: context)
        let receivable2 = DataFactory.createReceivable(name: "Lola Bar",
                                                       date: date_23_04_1970,
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
        return (IndexSet(integer: 1),[receivable1, receivable3, receivable4])
    }
    
    func createAndPersistTestObjects_deleteReceivablesWithIndices_5(using context: NSManagedObjectContext) -> (IndexSet,[Receivable]) {
        let date_23_04_1970 = DateParser.shared.date(from: "1970-04-23T00:00:00")!
        let date_21_10_1966 = DateParser.shared.date(from: "1966-10-21T00:00:00")!
        let date_01_01_2002 = DateParser.shared.date(from: "2002-01-01T00:00:00")!
        let date_26_04_2002 = DateParser.shared.date(from: "2002-04-26T00:00:00")!
        let receivable1 = DataFactory.createReceivable(name: "Blitz",
                                                       date: date_21_10_1966,
                                                       debtor: "Lenni",
                                                       initialAmount: 50.0,
                                                       repaidAmount: 0.0,
                                                       context: context)
        let receivable2 = DataFactory.createReceivable(name: "Lola Bar",
                                                       date: date_23_04_1970,
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
        return (IndexSet(0...2),[receivable4])
    }
    
    func createAndPersistTestObjects_deleteReceivablesWithIndices_6(using context: NSManagedObjectContext) -> (IndexSet,[Receivable]) {
        let date_23_04_1970 = DateParser.shared.date(from: "1970-04-23T00:00:00")!
        let date_21_10_1966 = DateParser.shared.date(from: "1966-10-21T00:00:00")!
        let date_01_01_2002 = DateParser.shared.date(from: "2002-01-01T00:00:00")!
        let date_26_04_2002 = DateParser.shared.date(from: "2002-04-26T00:00:00")!
        let receivable1 = DataFactory.createReceivable(name: "Blitz",
                                                       date: date_21_10_1966,
                                                       debtor: "Lenni",
                                                       initialAmount: 50.0,
                                                       repaidAmount: 0.0,
                                                       context: context)
        let receivable2 = DataFactory.createReceivable(name: "Lola Bar",
                                                       date: date_23_04_1970,
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
        return (IndexSet(0...3),[])
    }
    
    
    func createAndPersistTestObjects_deleteLiabilitiesWithIndices_1(using context: NSManagedObjectContext) -> (IndexSet,[Liability]) {
        let date_23_04_1970 = DateParser.shared.date(from: "1970-04-23T00:00:00")!
        let date_21_10_1966 = DateParser.shared.date(from: "1966-10-21T00:00:00")!
        let date_01_01_2002 = DateParser.shared.date(from: "2002-01-01T00:00:00")!
        let date_26_04_2002 = DateParser.shared.date(from: "2002-04-26T00:00:00")!
        
        let liability1 = DataFactory.createLiability(name: "Blitz",
                                                     date: date_21_10_1966,
                                                     creditor: "Lenni",
                                                     initialAmount: 50.0,
                                                     repaidAmount: 0.0,
                                                     context: context)
        let liability2 = DataFactory.createLiability(name: "Lola Bar",
                                                     date: date_23_04_1970,
                                                     creditor: "Lenni",
                                                     initialAmount: 20.0,
                                                     repaidAmount: 0.0,
                                                     context: context)
        let liability3 = DataFactory.createLiability(name: "Haushalt",
                                                     date: date_01_01_2002,
                                                     creditor: "Philipp",
                                                     initialAmount: 200.0,
                                                     repaidAmount: 0.0,
                                                     context: context)
        let liability4 = DataFactory.createLiability(name: "PRST",
                                                     date: date_26_04_2002,
                                                     creditor: "Filip",
                                                     initialAmount: 50.0,
                                                     repaidAmount: 0.0,
                                                     context: context)
        return (IndexSet(),[liability1,liability2,liability3,liability4])
    }
    
    func createAndPersistTestObjects_deleteLiabilitiesWithIndices_2(using context: NSManagedObjectContext) -> (IndexSet,[Liability]) {
        let date_23_04_1970 = DateParser.shared.date(from: "1970-04-23T00:00:00")!
        let date_21_10_1966 = DateParser.shared.date(from: "1966-10-21T00:00:00")!
        let date_01_01_2002 = DateParser.shared.date(from: "2002-01-01T00:00:00")!
        let date_26_04_2002 = DateParser.shared.date(from: "2002-04-26T00:00:00")!
        
        let liability1 = DataFactory.createLiability(name: "Blitz",
                                                     date: date_21_10_1966,
                                                     creditor: "Lenni",
                                                     initialAmount: 50.0,
                                                     repaidAmount: 0.0,
                                                     context: context)
        let liability2 = DataFactory.createLiability(name: "Lola Bar",
                                                     date: date_23_04_1970,
                                                     creditor: "Lenni",
                                                     initialAmount: 20.0,
                                                     repaidAmount: 0.0,
                                                     context: context)
        let liability3 = DataFactory.createLiability(name: "Haushalt",
                                                     date: date_01_01_2002,
                                                     creditor: "Philipp",
                                                     initialAmount: 200.0,
                                                     repaidAmount: 0.0,
                                                     context: context)
        let liability4 = DataFactory.createLiability(name: "PRST",
                                                     date: date_26_04_2002,
                                                     creditor: "Filip",
                                                     initialAmount: 50.0,
                                                     repaidAmount: 0.0,
                                                     context: context)
        return (IndexSet(integer: 0),[liability2,liability3,liability4])
    }
    
    func createAndPersistTestObjects_deleteLiabilitiesWithIndices_3(using context: NSManagedObjectContext) -> (IndexSet,[Liability]) {
        let date_23_04_1970 = DateParser.shared.date(from: "1970-04-23T00:00:00")!
        let date_21_10_1966 = DateParser.shared.date(from: "1966-10-21T00:00:00")!
        let date_01_01_2002 = DateParser.shared.date(from: "2002-01-01T00:00:00")!
        let date_26_04_2002 = DateParser.shared.date(from: "2002-04-26T00:00:00")!
        
        let liability1 = DataFactory.createLiability(name: "Blitz",
                                                     date: date_21_10_1966,
                                                     creditor: "Lenni",
                                                     initialAmount: 50.0,
                                                     repaidAmount: 0.0,
                                                     context: context)
        let liability2 = DataFactory.createLiability(name: "Lola Bar",
                                                     date: date_23_04_1970,
                                                     creditor: "Lenni",
                                                     initialAmount: 20.0,
                                                     repaidAmount: 0.0,
                                                     context: context)
        let liability3 = DataFactory.createLiability(name: "Haushalt",
                                                     date: date_01_01_2002,
                                                     creditor: "Philipp",
                                                     initialAmount: 200.0,
                                                     repaidAmount: 0.0,
                                                     context: context)
        let liability4 = DataFactory.createLiability(name: "PRST",
                                                     date: date_26_04_2002,
                                                     creditor: "Filip",
                                                     initialAmount: 50.0,
                                                     repaidAmount: 0.0,
                                                     context: context)
        return (IndexSet(integer: 3),[liability1,liability2,liability3])
    }
    
    func createAndPersistTestObjects_deleteLiabilitiesWithIndices_4(using context: NSManagedObjectContext) -> (IndexSet,[Liability]) {
        let date_23_04_1970 = DateParser.shared.date(from: "1970-04-23T00:00:00")!
        let date_21_10_1966 = DateParser.shared.date(from: "1966-10-21T00:00:00")!
        let date_01_01_2002 = DateParser.shared.date(from: "2002-01-01T00:00:00")!
        let date_26_04_2002 = DateParser.shared.date(from: "2002-04-26T00:00:00")!
        
        let liability1 = DataFactory.createLiability(name: "Blitz",
                                                     date: date_21_10_1966,
                                                     creditor: "Lenni",
                                                     initialAmount: 50.0,
                                                     repaidAmount: 0.0,
                                                     context: context)
        let liability2 = DataFactory.createLiability(name: "Lola Bar",
                                                     date: date_23_04_1970,
                                                     creditor: "Lenni",
                                                     initialAmount: 20.0,
                                                     repaidAmount: 0.0,
                                                     context: context)
        let liability3 = DataFactory.createLiability(name: "Haushalt",
                                                     date: date_01_01_2002,
                                                     creditor: "Philipp",
                                                     initialAmount: 200.0,
                                                     repaidAmount: 0.0,
                                                     context: context)
        let liability4 = DataFactory.createLiability(name: "PRST",
                                                     date: date_26_04_2002,
                                                     creditor: "Filip",
                                                     initialAmount: 50.0,
                                                     repaidAmount: 0.0,
                                                     context: context)
        return (IndexSet(integer: 2),[liability1,liability2,liability4])
    }

    func createAndPersistTestObjects_deleteLiabilitiesWithIndices_5(using context: NSManagedObjectContext) -> (IndexSet,[Liability]) {
        let date_23_04_1970 = DateParser.shared.date(from: "1970-04-23T00:00:00")!
        let date_21_10_1966 = DateParser.shared.date(from: "1966-10-21T00:00:00")!
        let date_01_01_2002 = DateParser.shared.date(from: "2002-01-01T00:00:00")!
        let date_26_04_2002 = DateParser.shared.date(from: "2002-04-26T00:00:00")!
        
        let liability1 = DataFactory.createLiability(name: "Blitz",
                                                     date: date_21_10_1966,
                                                     creditor: "Lenni",
                                                     initialAmount: 50.0,
                                                     repaidAmount: 0.0,
                                                     context: context)
        let liability2 = DataFactory.createLiability(name: "Lola Bar",
                                                     date: date_23_04_1970,
                                                     creditor: "Lenni",
                                                     initialAmount: 20.0,
                                                     repaidAmount: 0.0,
                                                     context: context)
        let liability3 = DataFactory.createLiability(name: "Haushalt",
                                                     date: date_01_01_2002,
                                                     creditor: "Philipp",
                                                     initialAmount: 200.0,
                                                     repaidAmount: 0.0,
                                                     context: context)
        let liability4 = DataFactory.createLiability(name: "PRST",
                                                     date: date_26_04_2002,
                                                     creditor: "Filip",
                                                     initialAmount: 50.0,
                                                     repaidAmount: 0.0,
                                                     context: context)
        return (IndexSet(2...3),[liability1,liability2])
    }
    
    func createAndPersistTestObjects_deleteLiabilitiesWithIndices_6(using context: NSManagedObjectContext) -> (IndexSet,[Liability]) {
        let date_23_04_1970 = DateParser.shared.date(from: "1970-04-23T00:00:00")!
        let date_21_10_1966 = DateParser.shared.date(from: "1966-10-21T00:00:00")!
        let date_01_01_2002 = DateParser.shared.date(from: "2002-01-01T00:00:00")!
        let date_26_04_2002 = DateParser.shared.date(from: "2002-04-26T00:00:00")!
        
        let liability1 = DataFactory.createLiability(name: "Blitz",
                                                     date: date_21_10_1966,
                                                     creditor: "Lenni",
                                                     initialAmount: 50.0,
                                                     repaidAmount: 0.0,
                                                     context: context)
        let liability2 = DataFactory.createLiability(name: "Lola Bar",
                                                     date: date_23_04_1970,
                                                     creditor: "Lenni",
                                                     initialAmount: 20.0,
                                                     repaidAmount: 0.0,
                                                     context: context)
        let liability3 = DataFactory.createLiability(name: "Haushalt",
                                                     date: date_01_01_2002,
                                                     creditor: "Philipp",
                                                     initialAmount: 200.0,
                                                     repaidAmount: 0.0,
                                                     context: context)
        let liability4 = DataFactory.createLiability(name: "PRST",
                                                     date: date_26_04_2002,
                                                     creditor: "Filip",
                                                     initialAmount: 50.0,
                                                     repaidAmount: 0.0,
                                                     context: context)
        return (IndexSet(0...3),[])
    }
}
