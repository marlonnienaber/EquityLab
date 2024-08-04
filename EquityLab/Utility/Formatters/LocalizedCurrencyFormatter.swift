//
//  LocalizedCurrencyFormatter.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 14.07.24.
//

import Foundation

class LocalizedCurrencyFormatter: NumberFormatter {
    static let shared = LocalizedCurrencyFormatter()
    
    private override init() {
        super.init()
        self.locale = Locale.current
        self.numberStyle = .currency
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
