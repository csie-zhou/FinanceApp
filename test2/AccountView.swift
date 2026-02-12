//
//  AccountView.swift
//  test2
//
//  Created by 周家弘 on 2026/2/12.
//

// AccountsView.swift
import SwiftUI
import CoreData
import Charts

struct AccountsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Account.type, ascending: true)],
        animation: .default
    )
    private var accounts: FetchedResults<Account>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Transaction.date, ascending: false)],
        animation: .default
    )
    private var transactions: FetchedResults<Transaction>
    
    @State private var showingAddAccount = false
    @State private var expandedAccountType: String?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Total summary
                    totalSummaryCard
                    
                    // Chart
                    balanceChart
                    
                    // Date selector
                    dateSelector
                    
                    // Account groups
                    accountGroups
                }
                .padding()
            }
            .navigationTitle("帳戶總覽")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) {
                        Image(systemName: "eye")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddAccount = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddAccount) {
                AddAccountView()
                    .environment(\.managedObjectContext, viewContext)
            }
        }
    }
    
    private var totalSummaryCard: some View {
        VStack(spacing: 8) {
            HStack {
                Text("總額")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("TWD")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
            }
            
            HStack {
                Text("\(totalBalance, format: .number.precision(.fractionLength(2)))K")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.red)
                Spacer()
            }
            
            HStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("總資產")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(totalAssets, format: .number.precision(.fractionLength(2)))")
                        .font(.subheadline)
                }
                
                VStack(alignment: .leading) {
                    Text("總負債")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(totalLiabilities, format: .number.precision(.fractionLength(2)))K")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
                
                Spacer()
            }
            
            // Toggle buttons
            HStack {
                Button(action: {}) {
                    Text("各分組佔比")
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(12)
                }
                
                Button(action: {}) {
                    Text("各幣種佔比")
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(.systemGray6))
                        .foregroundColor(.gray)
                        .cornerRadius(12)
                }
                
                Spacer()
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var balanceChart: some View {
        Chart {
            ForEach(last7Days, id: \.self) { date in
                BarMark(
                    x: .value("Date", date, unit: .day),
                    y: .value("Balance", balanceOn(date))
                )
                .foregroundStyle(balanceOn(date) >= 0 ? Color.green : Color.red)
            }
            
            LineMark(
                x: .value("Date", last7Days.first!),
                y: .value("Balance", averageBalance)
            )
            .foregroundStyle(.purple)
        }
        .frame(height: 200)
    }
    
    private var dateSelector: some View {
        HStack {
            Image(systemName: "calendar")
            Text("2026/02/12 週四")
                .font(.subheadline)
            Spacer()
            Button(action: {}) {
                Text("按日")
                    .font(.caption)
                Image(systemName: "chevron.down")
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var accountGroups: some View {
        VStack(spacing: 16) {
            ForEach(Account.AccountType.allCases, id: \.self) { type in
                accountGroupSection(for: type)
            }
        }
    }
    
    private func accountGroupSection(for type: Account.AccountType) -> some View {
        let accountsOfType = accounts.filter { $0.type == type.rawValue }
        let total = accountsOfType.reduce(0) { $0 + $1.balance }
        let isExpanded = expandedAccountType == type.rawValue
        
        return VStack(spacing: 0) {
            // Header
            Button(action: {
                withAnimation {
                    expandedAccountType = isExpanded ? nil : type.rawValue
                }
            }) {
                HStack {
                    Image(systemName: isExpanded ? "minus" : "plus")
                        .foregroundColor(.gray)
                    
                    Text("\(type.rawValue) (\(accountsOfType.count))")
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
                    ForEach(accountsOfType) { account in
                        accountRow(account: account)
                    }
                }
                .padding(.top, 8)
            }
        }
    }
    
    private func accountRow(account: Account) -> some View {
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
    
    // MARK: - Computed properties
    
    private var totalBalance: Double {
        accounts.reduce(0) { $0 + $1.balance } / 1000
    }
    
    private var totalAssets: Double {
        accounts.filter { $0.balance > 0 }.reduce(0) { $0 + $1.balance } / 1000
    }
    
    private var totalLiabilities: Double {
        abs(accounts.filter { $0.balance < 0 }.reduce(0) { $0 + $1.balance }) / 1000
    }
    
    private var last7Days: [Date] {
        (0..<7).compactMap { daysAgo in
            Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date())
        }.reversed()
    }
    
    private func balanceOn(_ date: Date) -> Double {
        let dayTransactions = transactions.filter { transaction in
            guard let transactionDate = transaction.date else { return false }
            return Calendar.current.isDate(transactionDate, equalTo: date, toGranularity: .day)
        }
        
        return dayTransactions.reduce(0) { sum, transaction in
            transaction.transactionType == .income ? sum + transaction.amount : sum - transaction.amount
        } / 1000
    }
    
    private var averageBalance: Double {
        last7Days.map { balanceOn($0) }.reduce(0, +) / Double(last7Days.count)
    }
}
