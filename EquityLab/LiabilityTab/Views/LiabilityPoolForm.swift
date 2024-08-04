//
//  LiabilityPoolForm.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 15.07.24.
//

import Foundation
import SwiftUI

struct LiabilityPoolForm: View {
    @State var viewModel: LiabilityPoolFormViewModel
    @Binding public var liabilityLedgerActiveSheet: LiabilityLedger.LiabilityLedgerSheetType?
    
    var body: some View {
        NavigationView{
            VStack {
                TextField("name", text: $viewModel.liabilityPoolName)
                if let pool = viewModel.liabilityPool {
                    Button("delete") {
                        viewModel.deleteLiabilityPool(pool: pool)
                        liabilityLedgerActiveSheet = nil
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", action: { liabilityLedgerActiveSheet = nil} )
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.saveLiabilityPool()
                        liabilityLedgerActiveSheet = nil
                    }
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
    
}
