//
//  ChartsView.swift
//  test2
//
//  Created by 周家弘 on 2026/2/12.
//

// ChartsView.swift
import SwiftUI
import CoreData
import Charts

struct ChartsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Transaction.date, ascending: false)],
        animation: .default
    )
    private var transactions: FetchedResults<Transaction>
    
    var categoryTotals: [CategoryTotal] {
        Dictionary(grouping: transactions, by: { $0.category ?? "Unknown" })
            .map { CategoryTotal(
                category: $0.key,
                amount: $0.value.reduce(0) { $0 + $1.amount }
            )}
            .sorted { $0.amount > $1.amount }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Pie chart
                    Chart(categoryTotals) { item in
                        SectorMark(
                            angle: .value("Amount", item.amount),
                            innerRadius: .ratio(0.5)
                        )
                        .foregroundStyle(by: .value("Category", item.category))
                    }
                    .frame(height: 300)
                    
                    // Bar chart
                    Chart(categoryTotals) { item in
                        BarMark(
                            x: .value("Category", item.category),
                            y: .value("Amount", item.amount)
                        )
                        .foregroundStyle(Color.blue.gradient)
                    }
                    .frame(height: 250)
                }
                .padding()
            }
            .navigationTitle("Analytics")
        }
    }
}



