//
//  MonthlyReportView.swift
//  test2
//
//  Created by 周家弘 on 2026/2/12.
//

// MonthlyReportView.swift
import SwiftUI
import CoreData
import Charts

struct MonthlyReportView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Transaction.date, ascending: false)],
        animation: .default
    )
    private var transactions: FetchedResults<Transaction>
    
    @State private var currentMonth = Date()
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Month selector
                    monthSelector
                    
                    // Tab selector
                    tabSelector
                    
                    // Summary cards
                    summaryCards
                    
                    // Category breakdown
                    categoryBreakdown
                    
                    // Top 3
                    topThree
                }
                .padding()
            }
            .navigationTitle("每月報表")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) {
                        Image(systemName: "chart.bar")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "ellipsis")
                    }
                }
            }
        }
    }
    
    private var monthSelector: some View {
        HStack {
            Button(action: { previousMonth() }) {
                Image(systemName: "chevron.left")
            }
            
            Spacer()
            
            Text(monthString)
                .font(.headline)
            
            Spacer()
            
            Button(action: { nextMonth() }) {
                Image(systemName: "chevron.right")
            }
        }
        .padding(.horizontal)
    }
    
    private var tabSelector: some View {
        HStack(spacing: 0) {
            ForEach(["總覽", "明細", "類別", "排行", "帳戶", "專案", "帳戶分組"], id: \.self) { tab in
                Button(action: { selectedTab = ["總覽", "明細", "類別", "排行", "帳戶", "專案", "帳戶分組"].firstIndex(of: tab) ?? 0 }) {
                    VStack(spacing: 4) {
                        Text(tab)
                            .font(.caption)
                            .foregroundColor(selectedTab == ["總覽", "明細", "類別", "排行", "帳戶", "專案", "帳戶分組"].firstIndex(of: tab) ? .blue : .gray)
                        
                        if selectedTab == ["總覽", "明細", "類別", "排行", "帳戶", "專案", "帳戶分組"].firstIndex(of: tab) {
                            Rectangle()
                                .fill(Color.blue)
                                .frame(height: 2)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    private var summaryCards: some View {
        VStack(spacing: 12) {
            // Expense
            HStack {
                Text("支出")
                    .foregroundColor(.white)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Circle()
                        .fill(.white)
                        .frame(width: 24, height: 24)
                        .overlay(
                            Text("\(monthlyExpenseCount)")
                                .font(.caption)
                                .foregroundColor(.red)
                        )
                    
                    Rectangle()
                        .fill(.white.opacity(0.3))
                        .frame(height: 8)
                    
                    Text("-$\(Int(monthlyExpense))")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(Color.red)
            .cornerRadius(12)
            
            // Income
            HStack {
                Text("收入")
                    .foregroundColor(.white)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Circle()
                        .fill(.white)
                        .frame(width: 24, height: 24)
                        .overlay(
                            Text("\(monthlyIncomeCount)")
                                .font(.caption)
                                .foregroundColor(.green)
                        )
                    
                    Rectangle()
                        .fill(.white.opacity(0.3))
                        .frame(height: 8)
                    
                    Text("+$\(Int(monthlyIncome))")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(Color.green)
            .cornerRadius(12)
            
            // Balance
            HStack {
                Text("總計")
                    .foregroundColor(.white)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Circle()
                        .fill(.white)
                        .frame(width: 24, height: 24)
                        .overlay(
                            Text("\(monthlyExpenseCount + monthlyIncomeCount)")
                                .font(.caption)
                                .foregroundColor(.purple)
                        )
                    
                    Text("-$\(Int(abs(monthlyBalance)))")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(Color.purple)
            .cornerRadius(12)
        }
    }
    
    private var categoryBreakdown: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("類別")
                .font(.title2)
                .bold()
            
            HStack(spacing: 20) {
                ForEach(topCategories.prefix(3), id: \.category) { item in
                    VStack {
                        ZStack {
                            Circle()
                                .stroke(Color.gray.opacity(0.2), lineWidth: 8)
                                .frame(width: 100, height: 100)
                            
                            Circle()
                                .trim(from: 0, to: item.percentage)
                                .stroke(categoryColor(item.category), lineWidth: 8)
                                .frame(width: 100, height: 100)
                                .rotationEffect(.degrees(-90))
                            
                            Text("\(Int(item.percentage * 100))%")
                                .font(.headline)
                        }
                        
                        Text(item.category)
                            .font(.caption)
                        
                        Text("$\(Int(item.amount))")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
    
    private var topThree: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("TOP 3")
                .font(.title2)
                .bold()
            
            ForEach(Array(topCategories.prefix(3).enumerated()), id: \.offset) { index, item in
                HStack {
                    CategoryIcon(category: item.category, size: 44)
                    
                    VStack(alignment: .leading) {
                        Text(item.category)
                            .font(.headline)
                        
                        Text(categorySubtitle(item.category))
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    Text("$\(Int(item.amount))")
                        .font(.headline)
                        .foregroundColor(.red)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
        }
    }
    
    // MARK: - Helper computed properties
    
    private var monthString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd — yyyy/MM/dd"
        let start = currentMonth.startOfMonth()
        let end = currentMonth.endOfMonth()
        return "\(start.formatted(.dateTime.year().month(.twoDigits).day(.twoDigits))) — \(end.formatted(.dateTime.year().month(.twoDigits).day(.twoDigits)))"
    }
    
    private var monthlyTransactions: [Transaction] {
        transactions.filter { transaction in
            guard let date = transaction.date else { return false }
            return Calendar.current.isDate(date, equalTo: currentMonth, toGranularity: .month)
        }
    }
    
    private var monthlyExpense: Double {
        monthlyTransactions
            .filter { $0.transactionType == .expense }
            .reduce(0) { $0 + $1.amount }
    }
    
    private var monthlyIncome: Double {
        monthlyTransactions
            .filter { $0.transactionType == .income }
            .reduce(0) { $0 + $1.amount }
    }
    
    private var monthlyBalance: Double {
        monthlyIncome - monthlyExpense
    }
    
    private var monthlyExpenseCount: Int {
        monthlyTransactions.filter { $0.transactionType == .expense }.count
    }
    
    private var monthlyIncomeCount: Int {
        monthlyTransactions.filter { $0.transactionType == .income }.count
    }
    
    private var topCategories: [CategoryTotal] {
        let expenseTransactions = monthlyTransactions.filter { $0.transactionType == .expense }
        let grouped = Dictionary(grouping: expenseTransactions, by: { $0.category ?? "未分類" })
        
        return grouped.map { category, transactions in
            let total = transactions.reduce(0) { $0 + $1.amount }
            return CategoryTotal(
                category: category,
                amount: total,
                percentage: monthlyExpense > 0 ? total / monthlyExpense : 0
            )
        }
        .sorted { $0.amount > $1.amount }
    }
    
    private func categoryColor(_ category: String) -> Color {
        switch category {
        case "飲食", "午餐", "早餐", "晚餐": return .orange
        case "學習", "書籍": return .yellow
        case "家居": return .blue
        default: return .gray
        }
    }
    
    private func categorySubtitle(_ category: String) -> String {
        switch category {
        case "書籍": return "錢包"
        case "探索": return "台新"
        case "隱眼": return "錢包"
        default: return "錢包"
        }
    }
    
    private func previousMonth() {
        currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth)!
    }
    
    private func nextMonth() {
        currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth)!
    }
}

//struct CategoryTotal {
//    let category: String
//    let amount: Double
//    let percentage: Double
//}

// Date extensions
extension Date {
    func startOfMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        return Calendar.current.date(from: components)!
    }
    
    func endOfMonth() -> Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth())!
    }
}
