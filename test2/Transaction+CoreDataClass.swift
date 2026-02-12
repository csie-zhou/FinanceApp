//// Transaction+CoreDataClass.swift
//import CoreData
//
//@objc(Transaction)
//public class Transaction: NSManagedObject, Identifiable {
//  @NSManaged public var id: UUID
//  @NSManaged public var amount: Double
//  @NSManaged public var category: String
//  @NSManaged public var date: Date
//  @NSManaged public var notes: String
//  @NSManaged public var type: String
//
//  var transactionType: TransactionType {
//    TransactionType(rawValue: type) ?? .expense
//  }
//
//  enum TransactionType: String {
//    case income, expense
//  }
//}
//
//extension Transaction {
//  static func create(
//    amount: Double,
//    category: String,
//    date: Date = Date(),
//    notes: String = "",
//    type: TransactionType,
//    context: NSManagedObjectContext
//  ) -> Transaction {
//    let transaction = Transaction(context: context)
//    transaction.id = UUID()
//    transaction.amount = amount
//    transaction.category = category
//    transaction.date = date
//    transaction.notes = notes
//    transaction.type = type.rawValue
//    return transaction
//  }
//}
// Transaction+CoreDataClass.swift
import Foundation
import CoreData

@objc(Transaction)
public class Transaction: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID?
    @NSManaged public var amount: Double
    @NSManaged public var category: String?
    @NSManaged public var date: Date?
    @NSManaged public var notes: String?
    @NSManaged public var type: String?
    @NSManaged public var accountName: String?
    @NSManaged public var merchant: String?
}

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
