//
//  AccountGroupView.swift
//  test2
//
//  Created by 周家弘 on 2026/2/14.
//

import SwiftUI

struct AccountGroupView: View {
    let type: Account.AccountType
    let accounts: [Account]
    @Binding var expandedType: String?
    
    var body: some View {
        let total = accounts.reduce(0) { $0 + $1.balance }
        let isExpanded = expandedType == type.rawValue
        
        VStack(spacing: 0) {
            // Header
            Button(action: {
                withAnimation {
                    expandedType = isExpanded ? nil : type.rawValue
                }
            }) {
                HStack {
                    Image(systemName: isExpanded ? "minus" : "plus")
                        .foregroundColor(.gray)
                    
                    Text("\(type.rawValue) (\(accounts.count))")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text(total >= 0 ? "+$\(Int(total))" : "-$\(Int(abs(total)))")
                        .font(.headline)
                        .foregroundColor(total >= 0 ? .green : .red)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            
            // Expanded content
            if isExpanded {
                VStack(spacing: 12) {
                    ForEach(accounts) { account in
                        AccountRowView(account: account)
                    }
                }
                .padding(.top, 8)
            }
        }
    }
}
