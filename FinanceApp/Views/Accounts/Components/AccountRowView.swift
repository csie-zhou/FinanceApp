//
//  AccountRowView.swift
//  FinanceApp
//
//  Created by 周家弘 on 2026/2/14.
//

import Foundation
import SwiftUI

struct AccountRowView: View {
    let account: Account
    
    var body: some View {
        HStack {
            Image(systemName: Account.AccountType(rawValue: account.type ?? "")?.systemImage ?? "circle")
                .font(.title2)
                .foregroundColor(.gray)
                .frame(width: 44, height: 44)
                .background(Color(.systemGray5))
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(account.name ?? "未命名")
                    .font(.headline)
                
                if let currency = account.currency {
                    Text(currency)
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            
            Spacer()
            
            Text("$\(Int(account.balance))")
                .font(.headline)
                .foregroundColor(account.balance >= 0 ? .green : .red)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
