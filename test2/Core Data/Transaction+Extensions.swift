//
//  Transaction+Extensions.swift
//  test2
//
//  Created by 周家弘 on 2026/2/13.
//

// Transaction+Extensions.swift
import Foundation
import CoreData

extension Transaction {
    enum TransactionType: String, CaseIterable {
        case expense = "支出"
        case income = "收入"
        case transfer = "轉帳"
        
        var systemImage: String {
            switch self {
            case .expense: return "minus.circle.fill"
            case .income: return "plus.circle.fill"
            case .transfer: return "arrow.left.arrow.right.circle.fill"
            }
        }
    }
    
    var transactionType: TransactionType {
        guard let type = type else { return .expense }
        return TransactionType(rawValue: type) ?? .expense
    }
    
    static func create(
        amount: Double,
        category: String,
        date: Date = Date(),
        notes: String = "",
        type: TransactionType,
        accountName: String = "現金",
        merchant: String = "",
        context: NSManagedObjectContext
    ) -> Transaction {
        let transaction = Transaction(context: context)
        transaction.id = UUID()
        transaction.amount = amount
        transaction.category = category
        transaction.date = date
        transaction.notes = notes
        transaction.type = type.rawValue
        transaction.accountName = accountName
        transaction.merchant = merchant
        return transaction
    }
}
