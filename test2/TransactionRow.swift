//
//  TransactionRow.swift
//  test2
//
//  Created by 周家弘 on 2026/2/12.
//

// TransactionRow.swift
import SwiftUI
import CoreData

struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.category ?? "Unknown")
                    .font(.headline)
                
                if let notes = transaction.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                if let date = transaction.date {
                    Text(date, style: .date)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Text("$\(transaction.amount, specifier: "%.2f")")
                .font(.headline)
                .foregroundColor(
                    transaction.transactionType == .income ? .green : .red
                )
        }
        .padding(.vertical, 4)
    }
}

