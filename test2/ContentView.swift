// ContentView.swift
import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Transaction.date, ascending: false)],
        animation: .default
    )
    private var transactions: FetchedResults<Transaction>
    
    @State private var showingAddTransaction = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Summary at top
                SummaryView(transactions: Array(transactions))
                    .padding(.bottom)
                
                // Transactions list
                List {
                    ForEach(transactions) { transaction in
                        TransactionRow(transaction: transaction)
                    }
                    .onDelete(perform: deleteTransactions)
                }
                .listStyle(.plain)
            }
            .navigationTitle("Transactions")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddTransaction = true }) {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddTransaction) {
                AddTransactionView()
                    .environment(\.managedObjectContext, viewContext)
            }
        }
    }
    
    private func deleteTransactions(offsets: IndexSet) {
        offsets.map { transactions[$0] }.forEach(viewContext.delete)
        
        do {
            try viewContext.save()
        } catch {
            print("Error deleting: \(error)")
        }
    }
}
