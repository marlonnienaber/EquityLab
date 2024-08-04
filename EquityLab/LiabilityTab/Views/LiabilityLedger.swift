//
//  LiabilityLedger.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 14.07.24.
//

import Foundation
import SwiftUI
import CoreData

struct LiabilityLedger: View {
    @State var viewModel = LiabilityLedgerViewModel()
    @State private var activeSheet: LiabilityLedgerSheetType? = nil
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.pools) { pool in
                    Section(pool.name) {
                        SectionContent(pool: pool, sectionLiabilities: viewModel.liabilities(for: pool))
                        SectionControls(for: pool)
                    }
                }
            }
            .navigationTitle("Liabilities")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if viewModel.pools.isEmpty {
                        EditButton().disabled(true)
                    } else {
                        EditButton()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button (action: {activeSheet = .addSheetLiabilityPool} ){
                        Text("new pool")
                    }
                }
            }
        }.sheet(item: $activeSheet) { activeSheet in
            switch activeSheet {
            case .addSheetLiabilityPool: LiabilityPoolForm(viewModel: LiabilityPoolFormViewModel(allPools: viewModel.pools),liabilityLedgerActiveSheet: $activeSheet)
            case .updateSheetLiabilityPool(let pool): LiabilityPoolForm(viewModel: LiabilityPoolFormViewModel(pool: pool, allPools: viewModel.pools), liabilityLedgerActiveSheet: $activeSheet)
            case .addSheetLiability(let pool): LiabilityForm(viewModel: LiabilityFormViewModel(pool: pool, allLiabilities: viewModel.allLiabilities()), liabilityLedgerActiveSheet: $activeSheet)
            case .updateSheetLiability(let liability): LiabilityForm(viewModel: LiabilityFormViewModel(liability: liability, allLiabilities: viewModel.allLiabilities()), liabilityLedgerActiveSheet: $activeSheet)
            }
        }
    }
    
    @ViewBuilder func SectionContent(pool: LiabilityPool, sectionLiabilities: [Liability]) -> some View {
        ForEach(sectionLiabilities) { liability in
            Button(action: {activeSheet = LiabilityLedgerSheetType.updateSheetLiability(liability: liability) }) {
                HStack{
                    if let initialAmountStringRepresentation = LocalizedCurrencyFormatter.shared.string(from: NSNumber(value: liability.initialAmount)) {
                        VStack(alignment: .leading) {
                            Text(liability.name)
                                .foregroundColor(Color.primary)
                            Text(liability.creditor)
                                .font(.footnote)
                                .foregroundColor(Color.gray)
                            Text(initialAmountStringRepresentation)
                                .font(.footnote)
                                .foregroundColor(Color.gray)
                        }
                        Spacer()
                        CircularProgressView(progress: liability.repaymentPercentage)
                            .frame(width: 37, height: 37)
                    }
                }
            }
        }.onDelete{ indexSet in
            viewModel.deleteLiabilities(in: pool, for: indexSet)
        }
    }
        
    @ViewBuilder func SectionControls(for pool: LiabilityPool) -> some View {
        HStack{
            Button(action: {activeSheet = .addSheetLiability(pool: pool)} ) {
                HStack{
                    Image(systemName: "plus")
                    Text("new liability")
                }
            }.buttonStyle(BorderlessButtonStyle())
            Spacer()
            Button(action: {activeSheet = .updateSheetLiabilityPool(pool: pool)}) {
                Image(systemName: "slider.horizontal.3")
            }.buttonStyle(BorderlessButtonStyle())
        }
    }
    
    enum LiabilityLedgerSheetType: Identifiable {
        var id: UUID { UUID() }
        case addSheetLiabilityPool
        case updateSheetLiabilityPool(pool: LiabilityPool)
        case addSheetLiability(pool: LiabilityPool)
        case updateSheetLiability(liability: Liability)
    }
    
}
