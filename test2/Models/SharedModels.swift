//
//  SharedModels.swift
//  test2
//
//  Created by 周家弘 on 2026/2/12.
//

import Foundation

// MARK: - Category Total
struct CategoryTotal: Identifiable {
    let id = UUID()
    let category: String
    let amount: Double
    let percentage: Double
    
    init(category: String, amount: Double, percentage: Double = 0) {
        self.category = category
        self.amount = amount
        self.percentage = percentage
    }
}
