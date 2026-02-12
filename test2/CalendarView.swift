//
//  CalendarView.swift
//  test2
//
//  Created by 周家弘 on 2026/2/12.
//

// CalendarView.swift
import SwiftUI
import CoreData

struct CalendarView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Transaction.date, ascending: false)],
        animation: .default
    )
    private var transactions: FetchedResults<Transaction>
    
    @State private var selectedDate = Date()
    @State private var showingAddTransaction = false
    @State private var currentMonth = Date()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Month selector
                monthHeader
                
                // Calendar grid
                calendarGrid
                
                // Today's transactions
                transactionsList
            }
            .navigationTitle(monthTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) {
                        Image(systemName: "bell")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "magnifyingglass")
                    }
                }
            }
            .overlay(
                // Floating add button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { showingAddTransaction = true }) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(Color.blue)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .padding()
                    }
                }
            )
            .sheet(isPresented: $showingAddTransaction) {
                AddTransactionView(selectedDate: selectedDate)
                    .environment(\.managedObjectContext, viewContext)
            }
        }
    }
    
    private var monthHeader: some View {
        HStack {
            Button(action: { previousMonth() }) {
                Image(systemName: "chevron.left")
            }
            
            Spacer()
            
            Text(currentMonth, format: .dateTime.year().month(.wide))
                .font(.headline)
            
            Spacer()
            
            Button(action: { nextMonth() }) {
                Image(systemName: "chevron.right")
            }
        }
        .padding()
    }
    
    private var calendarGrid: some View {
        let columns = Array(repeating: GridItem(.flexible()), count: 7)
        
        return LazyVGrid(columns: columns, spacing: 10) {
            // Weekday headers
            ForEach(["週日", "週一", "週二", "週三", "週四", "週五", "週六"], id: \.self) { day in
                Text(day)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            // Days
            ForEach(daysInMonth, id: \.self) { date in
                if let date = date {
                    DayCell(
                        date: date,
                        isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                        hasTransactions: hasTransactions(on: date),
                        amount: totalAmount(on: date)
                    )
                    .onTapGesture {
                        selectedDate = date
                    }
                } else {
                    Color.clear
                        .frame(height: 50)
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var transactionsList: some View {
        List {
            ForEach(todaysTransactions) { transaction in
                TransactionRowView(transaction: transaction)
            }
            .onDelete(perform: deleteTransactions)
        }
        .listStyle(.plain)
    }
    
    private var todaysTransactions: [Transaction] {
        transactions.filter { transaction in
            guard let date = transaction.date else { return false }
            return Calendar.current.isDate(date, inSameDayAs: selectedDate)
        }
    }
    
    private var daysInMonth: [Date?] {
        guard let monthInterval = Calendar.current.dateInterval(of: .month, for: currentMonth),
              let monthFirstWeek = Calendar.current.dateInterval(of: .weekOfMonth, for: monthInterval.start) else {
            return []
        }
        
        var days: [Date?] = []
        var date = monthFirstWeek.start
        
        while date < monthInterval.end {
            if Calendar.current.isDate(date, equalTo: monthInterval.start, toGranularity: .month) {
                days.append(date)
            } else {
                days.append(nil)
            }
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        }
        
        return days
    }
    
    private func hasTransactions(on date: Date) -> Bool {
        transactions.contains { transaction in
            guard let transactionDate = transaction.date else { return false }
            return Calendar.current.isDate(transactionDate, inSameDayAs: date)
        }
    }
    
    private func totalAmount(on date: Date) -> Double {
        transactions
            .filter { transaction in
                guard let transactionDate = transaction.date else { return false }
                return Calendar.current.isDate(transactionDate, inSameDayAs: date)
            }
            .reduce(0) { sum, transaction in
                transaction.transactionType == .income ? sum + transaction.amount : sum - transaction.amount
            }
    }
    
    private func previousMonth() {
        currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth)!
    }
    
    private func nextMonth() {
        currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth)!
    }
    
    private var monthTitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: selectedDate)
    }
    
    private func deleteTransactions(offsets: IndexSet) {
        offsets.map { todaysTransactions[$0] }.forEach(viewContext.delete)
        
        do {
            try viewContext.save()
        } catch {
            print("Error deleting: \(error)")
        }
    }
}

struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let hasTransactions: Bool
    let amount: Double
    
    var body: some View {
        VStack(spacing: 2) {
            Text("\(Calendar.current.component(.day, from: date))")
                .font(.system(size: 16, weight: isSelected ? .bold : .regular))
                .foregroundColor(isSelected ? .white : .primary)
            
            if hasTransactions {
                Text("$\(Int(abs(amount)))")
                    .font(.system(size: 10))
                    .foregroundColor(isSelected ? .white : (amount >= 0 ? .green : .red))
            }
        }
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .background(
            isSelected ? Color.blue : Color.clear
        )
        .cornerRadius(8)
    }
}

struct TransactionRowView: View {
    let transaction: Transaction
    
    var body: some View {
        HStack(spacing: 12) {
            CategoryIcon(category: transaction.category ?? "其他", size: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.category ?? "未分類")
                    .font(.headline)
                
                if let merchant = transaction.merchant, !merchant.isEmpty {
                    Text(merchant)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Text("$\(Int(transaction.amount))")
                .font(.headline)
                .foregroundColor(transaction.transactionType == .income ? .green : .red)
        }
        .padding(.vertical, 4)
    }
}
