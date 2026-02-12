////
////  SampleData.swift
////  test2
////
////  Created by 周家弘 on 2026/2/12.
////
//
//// SampleData.swift
//import CoreData
//
//extension PersistenceController {
//    func createSampleData() {
//        let context = container.viewContext
//        
//        // Create sample accounts
//        let cashAccount = Account(context: context)
//        cashAccount.id = UUID()
//        cashAccount.name = "錢包"
//        cashAccount.type = Account.AccountType.cash.rawValue
//        cashAccount.balance = 45002.67
//        cashAccount.currency = "TWD"
//        
//        let bankAccount = Account(context: context)
//        bankAccount.id = UUID()
//        bankAccount.name = "台新"
//        bankAccount.type = Account.AccountType.bank.rawValue
//        bankAccount.balance = -200466.67
//        bankAccount.currency = "TWD"
//        
//        // Create sample transactions
//        let categories = ["午餐", "早餐", "晚餐", "交通", "購物", "娛樂"]
//        let dates = (0..<20).map { daysAgo in
//            Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date())!
//        }
//        
//        for date in dates {
//            let transaction = Transaction(context: context)
//            transaction.id = UUID()
//            transaction.amount = Double.random(in: 50...500)
//            transaction.category = categories.randomElement()
//            transaction.date = date
//            transaction.type = Transaction.TransactionType.expense.rawValue
//            transaction.accountName = "錢包"
//            transaction.merchant = ""
//            transaction.notes = ""
//        }
//        
//        do {
//            try context.save()
//            print("Sample data created!")
//        } catch {
//            print("Error creating sample data: \(error)")
//        }
//    }
//}
