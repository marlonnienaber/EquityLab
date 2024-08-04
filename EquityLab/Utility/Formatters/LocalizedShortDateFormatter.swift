//
//  LocalizedShortDateFormatter.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 14.07.24.
//

import Foundation

class LocalizedShortDateFormatter: DateFormatter {
    static let shared = LocalizedShortDateFormatter()
    
    private override init() {
        super.init()
        self.locale = Locale.current
        self.dateStyle = .short
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
