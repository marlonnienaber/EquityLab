//
//  AssetForm.swift
//  EquityLab
//
//  Created by Marlon Nienaber on 14.07.24.
//

import SwiftUI
import CoreData

struct AssetForm: View {
    @State public var viewModel: AssetFormViewModel
    @Binding public var assetLedgerActiveSheet: AssetLedger.AssetLedgerSheetType?
    @State private var showPopover: Bool = false
    
    var body: some View {
        NavigationView{
            VStack {
                if(viewModel.asset == nil) {
                    Picker(selection: $viewModel.selectedAssetType,
                           label: Text("picker"),
                           content: {
                        Text("possession").tag("possession")
                        Text("receivable").tag("receivable")
                    }).pickerStyle(.segmented)
                        .frame(width: 180)
                        .padding(.top)
                }
                FormSection
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel", action: { assetLedgerActiveSheet = nil } )
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Save") {
                                viewModel.saveAsset()
                                assetLedgerActiveSheet = nil
                            }
                        }
                    }
                    .onTapGesture {
                        hideKeyboard()
                    }
            }.navigationTitle(viewModel.asset == nil ? "new Asset" : "edit Asset")
        }
    }
    
    @ViewBuilder var FormSection: some View {
        if viewModel.asset == nil {
            if viewModel.selectedAssetType == "possession" {
                NormalFormSection
            } else {
                ReceivableFormSection
            }
        } else {
            if let _ = viewModel.asset as? Possession {
                NormalFormSection
            } else {
                ReceivableFormSection
            }
        }
    }
    
    @ViewBuilder var NormalFormSection: some View {
        Form {
            TextField("name", text: $viewModel.assetName)
            Toggle(isOn: $viewModel.possessionIsVolatile) {
                HStack{
                    Text("volatile asset?")
                    Spacer()
                    Button(action: { showPopover.toggle() }) {
                        Image(systemName: "info.circle")
                    }.popover(isPresented: $showPopover) {
                        Text("the latest value of non-volatile assets will be reused when taking a new snapshot")
                            .presentationCompactAdaptation(.popover)
                    }.buttonStyle(BorderlessButtonStyle())
                }
                
            }
        }
    }
    
    @ViewBuilder var ReceivableFormSection: some View {
        Form {
            Section {
                TextField("debtor", text: $viewModel.receivableDebtor)
                TextField("purpose", text: $viewModel.assetName)
                HStack {
                    Spacer()
                    Text("(20 characters max)")
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                }
            }
            Section {
                HStack {
                    Text("initial amount")
                    Spacer()
                    CurrencyInputField(value: $viewModel.receivableInitialAmount)
                        .padding(6)
                }
                HStack {
                    Text("repaid amount")
                    Spacer()
                    CurrencyInputField(value: $viewModel.receivableRepaidAmount)
                        .padding(6)
                }
            }
            Section {
                DatePicker("date", selection: $viewModel.receivableGrantDate, in: ...Date(), displayedComponents: .date)
            }
        }
        
    }
    
}
