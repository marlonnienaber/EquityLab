//
//  AssetPoolForm.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 14.07.24.
//

import Foundation
import CoreData
import SwiftUI

struct AssetPoolForm: View {
    @State public var viewModel: AssetPoolFormViewModel
    @Binding public var assetLedgerActiveSheet: AssetLedger.AssetLedgerSheetType?
    
    var body: some View {
        NavigationView{
            VStack {
                TextField("name", text: $viewModel.assetPoolName)
                if let pool = viewModel.assetPool {
                    Button("delete") {
                        viewModel.deleteAssetPool(pool: pool)
                        assetLedgerActiveSheet = nil
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", action: {assetLedgerActiveSheet = nil} )
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.saveAssetPool()
                        assetLedgerActiveSheet = nil
                    }
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}
