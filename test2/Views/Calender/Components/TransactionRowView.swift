//
//  CalendarHeaderView.swift
//  test2
//
//  Created by 周家弘 on 2026/2/14.
//

import Foundation
import SwiftUI

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
