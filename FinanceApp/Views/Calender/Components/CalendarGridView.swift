//
//  CalendarGridView.swift
//  FinanceApp
//
//  Created by 周家弘 on 2026/2/14.
//

import SwiftUI

struct CalendarGridView: View {
    let daysInMonth: [Date?]
    let selectedDate: Date
    let hasTransactions: (Date) -> Bool
    let totalAmount: (Date) -> Double
    let onDateTap: (Date) -> Void
    
    var body: some View {
        let columns = Array(repeating: GridItem(.flexible()), count: 7)
        
        LazyVGrid(columns: columns, spacing: 10) {
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
                        hasTransactions: hasTransactions(date),
                        amount: totalAmount(date)
                    )
                    .onTapGesture {
                        onDateTap(date)
                    }
                } else {
                    Color.clear
                        .frame(height: 50)
                }
            }
        }
        .padding(.horizontal)
    }
}
