//
//  DayCellView.swift
//  FinanceApp
//
//  Created by 周家弘 on 2026/2/14.
//

import Foundation
import SwiftUI

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
