//
//  AddAcountView.swift
//  test2
//
//  Created by 周家弘 on 2026/2/12.
//

// AddAccountView.swift
import SwiftUI
import CoreData

struct AddAccountView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var selectedType: Account.AccountType = .cash
    @State private var balance = ""
    @State private var currency = "TWD"
    
    var body: some View {
        NavigationView {
            Form {
                Section("帳戶資訊") {
                    TextField("帳戶名稱", text: $name)
                    
                    Picker("類型", selection: $selectedType) {
                        ForEach(Account.AccountType.allCases, id: \.self) { type in
                            Label(type.rawValue, systemImage: type.systemImage)
                                .tag(type)
                        }
                    }
                }
                
                Section("餘額") {
                    TextField("初始餘額", text: $balance)
                        #if os(iOS)
                        .keyboardType(.decimalPad)
                        #endif
                    
                    Picker("幣別", selection: $currency) {
                        Text("TWD").tag("TWD")
                        Text("USD").tag("USD")
                        Text("JPY").tag("JPY")
                        Text("EUR").tag("EUR")
                    }
                }
            }
            .navigationTitle("新增帳戶")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("儲存") {
                        saveAccount()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private func saveAccount() {
        let account = Account(context: viewContext)
        account.id = UUID()
        account.name = name
        account.type = selectedType.rawValue
        account.balance = Double(balance) ?? 0
        account.currency = currency
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Error saving account: \(error)")
        }
    }
}
