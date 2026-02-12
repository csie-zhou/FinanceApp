// AddTransactionView.swift
import SwiftUI
import CoreData

struct AddTransactionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedType: Transaction.TransactionType = .expense
    @State private var amount = ""
    @State private var selectedCategory = "午餐"
    @State private var merchant = ""
    @State private var selectedAccount = "現金"
    @State private var selectedDate: Date
    @State private var notes = ""
    @State private var showingCalculator = false
    
    init(selectedDate: Date = Date()) {
        _selectedDate = State(initialValue: selectedDate)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Type selector
                typeSelector
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Category icons
                        categoryGrid
                        
                        // Amount input
                        amountSection
                        
                        // Details
                        detailsSection
                    }
                    .padding()
                }
            }
            .navigationTitle("新增記錄")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("✕") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("✓") {
                        saveTransaction()
                    }
                    .disabled(amount.isEmpty)
                }
            }
        }
    }
    
    private var typeSelector: some View {
        HStack(spacing: 0) {
            ForEach(Transaction.TransactionType.allCases, id: \.self) { type in
                Button(action: { selectedType = type }) {
                    VStack(spacing: 4) {
                        Text(type.rawValue)
                            .font(.subheadline)
                            .foregroundColor(selectedType == type ? .blue : .gray)
                        
                        if selectedType == type {
                            Rectangle()
                                .fill(Color.blue)
                                .frame(height: 2)
                        } else {
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: 2)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal)
        .background(Color(.systemGroupedBackground))
    }
    
    private var categoryGrid: some View {
        let categories = selectedType == .expense ? CategoryData.expenseCategories : CategoryData.incomeCategories
        let columns = Array(repeating: GridItem(.flexible()), count: 5)
        
        return LazyVGrid(columns: columns, spacing: 15) {
            ForEach(categories, id: \.self) { category in
                Button(action: { selectedCategory = category }) {
                    VStack(spacing: 8) {
                        CategoryIcon(
                            category: category,
                            size: 50
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(selectedCategory == category ? Color.blue : Color.clear, lineWidth: 2)
                        )
                        
                        Text(category)
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
    
    private var amountSection: some View {
        VStack(spacing: 12) {
            HStack {
                Button(action: { showingCalculator.toggle() }) {
                    Image(systemName: "camera")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .frame(width: 60, height: 60)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }
                
                Spacer()
                
                HStack {
                    Text("TWD")
                        .foregroundColor(.gray)
                    
                    TextField("0", text: $amount)
                        .font(.system(size: 32, weight: .bold))
                        .multilineTextAlignment(.trailing)
                        #if os(iOS)
                        .keyboardType(.numberPad)
                        #endif
                    
                    Button(action: {}) {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.gray)
                    }
                }
            }
            
            TextField("名稱", text: $merchant)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
    
    private var detailsSection: some View {
        VStack(spacing: 12) {
            // Account
            HStack {
                Text("台新")
                    .font(.subheadline)
                Spacer()
                Text("無專案")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            // Frequency
            HStack {
                Text("商家")
                    .font(.subheadline)
                Spacer()
                Text("單次")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            // Date & Time
            HStack {
                DatePicker("", selection: $selectedDate)
                    .labelsHidden()
                Spacer()
                Text(selectedDate, format: .dateTime.hour().minute())
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            // Notes
            TextEditor(text: $notes)
                .frame(height: 100)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(12)
        }
    }
    
    private func saveTransaction() {
        guard let amountValue = Double(amount) else { return }
        
        _ = Transaction.create(
            amount: amountValue,
            category: selectedCategory,
            date: selectedDate,
            notes: notes,
            type: selectedType,
            accountName: selectedAccount,
            merchant: merchant,
            context: viewContext
        )
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Error saving: \(error)")
        }
    }
}
