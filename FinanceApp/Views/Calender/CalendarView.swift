//
//  CalendarView.swift
//  FinanceApp
//
//  Created by 周家弘 on 2026/2/12.
//

import CoreData
// CalendarView.swift
import SwiftUI

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
        CalendarGridView(
            daysInMonth: daysInMonth,
            selectedDate: selectedDate,
            hasTransactions: hasTransactions,
            totalAmount: totalAmount,
            onDateTap: { date in selectedDate = date }
        )
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
      let monthFirstWeek = Calendar.current.dateInterval(of: .weekOfMonth, for: monthInterval.start)
    else {
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

