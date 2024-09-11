//
//  Liability+CoreDataClass.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 14.07.24.
//
//


import CoreData

@objc(Liability)
public class Liability: NSManagedObject {
    
    public var repaymentPercentage: Double {
        repaidAmount / initialAmount
    }
    
    public var openAmount: Double {
        initialAmount - repaidAmount
    }

}
