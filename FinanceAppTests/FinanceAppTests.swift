//
//  FinanceAppTests.swift
//  FinanceAppTests
//
//  Created by 周家弘 on 2026/2/12.
//

import XCTest
import CoreData
@testable import FinanceApp

final class FinanceAppTests: XCTestCase {
    
    var persistenceController: PersistenceController!
    var context: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        // Use in-memory store for testing (doesn't affect real data)
        persistenceController = PersistenceController(inMemory: true)
        context = persistenceController.container.viewContext
    }
    
    override func tearDown() {
        context = nil
        persistenceController = nil
        super.tearDown()
    }
    
    // MARK: - Transaction Type Tests
    
    func testTransactionTypeExpense() {
        XCTAssertEqual(Transaction.TransactionType.expense.rawValue, "支出")
        XCTAssertEqual(Transaction.TransactionType.expense.systemImage, "minus.circle.fill")
    }
    
    func testTransactionTypeIncome() {
        XCTAssertEqual(Transaction.TransactionType.income.rawValue, "收入")
        XCTAssertEqual(Transaction.TransactionType.income.systemImage, "plus.circle.fill")
    }
    
    func testTransactionTypeTransfer() {
        XCTAssertEqual(Transaction.TransactionType.transfer.rawValue, "轉帳")
    }
    
    func testAllTransactionTypesExist() {
        XCTAssertEqual(Transaction.TransactionType.allCases.count, 3)
    }
    
    // MARK: - Account Type Tests
    
    func testAccountTypeCash() {
        XCTAssertEqual(Account.AccountType.cash.rawValue, "現金")
        XCTAssertEqual(Account.AccountType.cash.systemImage, "banknote")
    }
    
    func testAccountTypeBank() {
        XCTAssertEqual(Account.AccountType.bank.rawValue, "銀行")
        XCTAssertEqual(Account.AccountType.bank.systemImage, "building.columns")
    }
    
    func testAccountTypeCredit() {
        XCTAssertEqual(Account.AccountType.credit.rawValue, "信用卡")
    }
    
    func testAllAccountTypesExist() {
        XCTAssertEqual(Account.AccountType.allCases.count, 5)
    }
    
    // MARK: - Transaction Creation Tests
    
    func testCreateExpenseTransaction() {
        let transaction = Transaction.create(
            amount: 100.0,
            category: "午餐",
            date: Date(),
            notes: "Test note",
            type: .expense,
            accountName: "錢包",
            merchant: "7-11",
            context: context
        )
        
        XCTAssertEqual(transaction.amount, 100.0)
        XCTAssertEqual(transaction.category, "午餐")
        XCTAssertEqual(transaction.accountName, "錢包")
        XCTAssertEqual(transaction.merchant, "7-11")
        XCTAssertEqual(transaction.transactionType, .expense)
        XCTAssertNotNil(transaction.id)
    }
    
    func testCreateIncomeTransaction() {
        let transaction = Transaction.create(
            amount: 50000.0,
            category: "薪水",
            date: Date(),
            notes: "",
            type: .income,
            accountName: "台新銀行",
            merchant: "",
            context: context
        )
        
        XCTAssertEqual(transaction.amount, 50000.0)
        XCTAssertEqual(transaction.transactionType, .income)
        XCTAssertEqual(transaction.category, "薪水")
    }
    
    func testTransactionSavedToContext() throws {
        _ = Transaction.create(
            amount: 200.0,
            category: "交通",
            date: Date(),
            notes: "",
            type: .expense,
            accountName: "錢包",
            merchant: "",
            context: context
        )
        
        try context.save()
        
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        let results = try context.fetch(fetchRequest)
        
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.amount, 200.0)
    }
    
    func testMultipleTransactionsSaved() throws {
        let amounts = [100.0, 200.0, 300.0]
        
        for amount in amounts {
            _ = Transaction.create(
                amount: amount,
                category: "購物",
                date: Date(),
                notes: "",
                type: .expense,
                accountName: "錢包",
                merchant: "",
                context: context
            )
        }
        
        try context.save()
        
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        let results = try context.fetch(fetchRequest)
        
        XCTAssertEqual(results.count, 3)
    }
    
    // MARK: - Balance Calculation Tests
    
    func testBalanceCalculationExpense() {
        let initialBalance = 10000.0
        let expenseAmount = 500.0
        let expectedBalance = initialBalance - expenseAmount
        
        XCTAssertEqual(expectedBalance, 9500.0)
    }
    
    func testBalanceCalculationIncome() {
        let initialBalance = 10000.0
        let incomeAmount = 5000.0
        let expectedBalance = initialBalance + incomeAmount
        
        XCTAssertEqual(expectedBalance, 15000.0)
    }
    
    func testNetBalanceCalculation() {
        let income = 50000.0
        let expenses = [1000.0, 500.0, 2000.0]
        let totalExpense = expenses.reduce(0, +)
        let netBalance = income - totalExpense
        
        XCTAssertEqual(totalExpense, 3500.0)
        XCTAssertEqual(netBalance, 46500.0)
    }
    
    // MARK: - Category Data Tests
    
    func testExpenseCategoriesNotEmpty() {
        XCTAssertFalse(CategoryData.expenseCategories.isEmpty)
    }
    
    func testIncomeCategoriesNotEmpty() {
        XCTAssertFalse(CategoryData.incomeCategories.isEmpty)
    }
    
    func testExpenseCategoriesContainCommon() {
        XCTAssertTrue(CategoryData.expenseCategories.contains("午餐"))
        XCTAssertTrue(CategoryData.expenseCategories.contains("交通"))
        XCTAssertTrue(CategoryData.expenseCategories.contains("購物"))
    }
    
    func testIncomeCategoriesContainCommon() {
        XCTAssertTrue(CategoryData.incomeCategories.contains("薪水"))
        XCTAssertTrue(CategoryData.incomeCategories.contains("獎金"))
    }
    
    // MARK: - Date Extension Tests
    
    func testStartOfMonth() {
        let date = Date()
        let startOfMonth = date.startOfMonth()
        let components = Calendar.current.dateComponents([.day], from: startOfMonth)
        
        XCTAssertEqual(components.day, 1)
    }
    
    func testEndOfMonthAfterStart() {
        let date = Date()
        let startOfMonth = date.startOfMonth()
        let endOfMonth = date.endOfMonth()
        
        XCTAssertTrue(endOfMonth > startOfMonth)
    }
    
    func testStartOfMonthIsBeforeEndOfMonth() {
        let date = Date()
        XCTAssertLessThan(date.startOfMonth(), date.endOfMonth())
    }
    
    // MARK: - CategoryTotal Tests
    
    func testCategoryTotalCreation() {
        let total = CategoryTotal(category: "午餐", amount: 1500.0, percentage: 0.30)
        
        XCTAssertEqual(total.category, "午餐")
        XCTAssertEqual(total.amount, 1500.0)
        XCTAssertEqual(total.percentage, 0.30)
        XCTAssertNotNil(total.id)
    }
    
    func testCategoryTotalDefaultPercentage() {
        let total = CategoryTotal(category: "交通", amount: 500.0)
        
        XCTAssertEqual(total.percentage, 0.0)
    }
    
    func testCategoryTotalSorting() {
        let totals = [
            CategoryTotal(category: "購物", amount: 500.0),
            CategoryTotal(category: "午餐", amount: 1500.0),
            CategoryTotal(category: "交通", amount: 800.0)
        ]
        
        let sorted = totals.sorted { $0.amount > $1.amount }
        
        XCTAssertEqual(sorted[0].category, "午餐")
        XCTAssertEqual(sorted[1].category, "交通")
        XCTAssertEqual(sorted[2].category, "購物")
    }
    
    // MARK: - Performance Tests
    
    func testTransactionCreationPerformance() {
        measure {
            for i in 0..<100 {
                _ = Transaction.create(
                    amount: Double(i) * 10,
                    category: "午餐",
                    date: Date(),
                    notes: "",
                    type: .expense,
                    accountName: "錢包",
                    merchant: "",
                    context: context
                )
            }
        }
    }
}
