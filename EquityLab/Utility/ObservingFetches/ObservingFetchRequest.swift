//
//  ObservingFetchRequest.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 14.07.24.
//

import Foundation
import CoreData

public class ObservingFetchRequest<ResultType>: NSFetchRequest<NSFetchRequestResult> where ResultType: NSFetchRequestResult {
    
    public var observedRelationships: Set<String> = []
    
}
