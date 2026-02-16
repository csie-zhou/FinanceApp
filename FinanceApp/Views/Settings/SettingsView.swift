//
//  SettingsView.swift
//  FinanceApp
//
//  Created by 周家弘 on 2026/2/12.
//

// SettingsView.swift
import SwiftUI

struct SettingsView: View {
    @AppStorage("currency") private var currency = "TWD"
    @AppStorage("startOfWeek") private var startOfWeek = "週日"
    
    var body: some View {
        NavigationView {
            Form {
                Section("一般設定") {
                    Picker("預設幣別", selection: $currency) {
                        Text("TWD (NT$)").tag("TWD")
                        Text("USD ($)").tag("USD")
                        Text("EUR (€)").tag("EUR")
                        Text("JPY (¥)").tag("JPY")
                    }
                    
                    Picker("週起始日", selection: $startOfWeek) {
                        Text("週日").tag("週日")
                        Text("週一").tag("週一")
                    }
                }
                
                Section("資料管理") {
                    Button("匯出資料") {
                        // TODO: Export
                    }
                    
                    Button("備份到 iCloud") {
                        // TODO: Backup
                    }
                    
                    Button("清除所有資料", role: .destructive) {
                        // TODO: Clear data
                    }
                }
                
                Section("關於") {
                    HStack {
                        Text("版本")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("設定")
        }
    }
}
