//
//  SummaryView.swift
//  test2
//
//  Created by 周家弘 on 2026/2/12.
//

// SummaryView.swift
import SwiftUI
import CoreData

struct SummaryView: View {
    let transactions: [Transaction]
    
    var totalIncome: Double {
        transactions.filter { $0.transactionType == .income }
                    .reduce(0) { $0 + $1.amount }
    }
    
    var totalExpense: Double {
        transactions.filter { $0.transactionType == .expense }
                    .reduce(0) { $0 + $1.amount }
    }
    
    var balance: Double {
        totalIncome - totalExpense
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 20) {
                StatCard(title: "Income", amount: totalIncome, color: .green)
                StatCard(title: "Expense", amount: totalExpense, color: .red)
            }
            
            StatCard(title: "Balance", amount: balance, color: balance >= 0 ? .blue : .orange)
        }
        .padding()
    }
}

struct StatCard: View {
    let title: String
    let amount: Double
    let color: Color
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text("$\(amount, specifier: "%.2f")")
                .font(.title2)
                .bold()
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}
