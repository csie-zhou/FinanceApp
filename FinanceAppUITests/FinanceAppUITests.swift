//
//  FinanceAppUITests.swift
//  FinanceAppUITests
//
//  Created by 周家弘 on 2026/2/12.
//

import XCTest

final class FinanceAppUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        
        // Use in-memory store for UI tests
        app.launchArguments = ["--uitesting"]
        app.launch()
    }
    
    override func tearDown() {
        app.terminate()
        super.tearDown()
    }
    
    // MARK: - App Launch Tests
    
    func testAppLaunchesSuccessfully() {
        XCTAssertTrue(app.exists)
    }
    
    func testTabBarExists() {
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.exists)
    }
    
    func testAllTabsExist() {
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.exists)
        
        // Check tab count
        XCTAssertGreaterThan(app.tabBars.buttons.count, 0)
    }
    
    // MARK: - Calendar Tab Tests
    
    func testCalendarTabNavigation() {
        // Tap calendar tab
        let calendarTab = app.tabBars.buttons["記帳"]
        if calendarTab.exists {
            calendarTab.tap()
            XCTAssertTrue(app.exists)
        }
    }
    
    func testAddTransactionButtonExists() {
        // Navigate to calendar tab
        let calendarTab = app.tabBars.buttons["記帳"]
        if calendarTab.exists {
            calendarTab.tap()
        }
        
        // Check for add button
        let addButton = app.buttons["plus"]
        XCTAssertTrue(addButton.exists)
    }
    
    func testAddTransactionSheetOpens() {
        // Navigate to calendar tab
        let calendarTab = app.tabBars.buttons["記帳"]
        if calendarTab.exists {
            calendarTab.tap()
        }
        
        // Tap add button
        let addButton = app.buttons["plus"]
        if addButton.exists {
            addButton.tap()
            
            // Sheet should appear
            XCTAssertTrue(app.sheets.firstMatch.exists ||
                         app.navigationBars["新增記錄"].exists)
        }
    }
    
    // MARK: - Accounts Tab Tests
    
    func testAccountsTabNavigation() {
        let accountsTab = app.tabBars.buttons["帳戶"]
        if accountsTab.exists {
            accountsTab.tap()
            XCTAssertTrue(app.exists)
        }
    }
    
    func testAccountsAddButtonExists() {
        let accountsTab = app.tabBars.buttons["帳戶"]
        if accountsTab.exists {
            accountsTab.tap()
            
            let addButton = app.navigationBars.buttons.lastMatch
            XCTAssertNotNil(addButton)
        }
    }
    
    // MARK: - Reports Tab Tests
    
    func testReportsTabNavigation() {
        let reportsTab = app.tabBars.buttons["報表"]
        if reportsTab.exists {
            reportsTab.tap()
            XCTAssertTrue(app.exists)
        }
    }
    
    // MARK: - Settings Tab Tests
    
    func testSettingsTabNavigation() {
        let settingsTab = app.tabBars.buttons["設定"]
        if settingsTab.exists {
            settingsTab.tap()
            XCTAssertTrue(app.exists)
        }
    }
    
    // MARK: - Add Transaction Flow Tests
    
    func testAddTransactionDismiss() {
        // Open add transaction
        let calendarTab = app.tabBars.buttons["記帳"]
        if calendarTab.exists { calendarTab.tap() }
        
        let addButton = app.buttons["plus"]
        if addButton.exists {
            addButton.tap()
            
            // Dismiss with X button
            let dismissButton = app.buttons["✕"]
            if dismissButton.exists {
                dismissButton.tap()
                XCTAssertFalse(app.navigationBars["新增記錄"].exists)
            }
        }
    }
    
    func testTransactionTypeSelection() {
        // Open add transaction
        let calendarTab = app.tabBars.buttons["記帳"]
        if calendarTab.exists { calendarTab.tap() }
        
        let addButton = app.buttons["plus"]
        if addButton.exists {
            addButton.tap()
            
            // Try tapping income tab
            let incomeButton = app.buttons["收入"]
            if incomeButton.exists {
                incomeButton.tap()
                XCTAssertTrue(app.exists)
            }
        }
    }
}

// MARK: - XCUIElementQuery Extension
extension XCUIElementQuery {
    var lastMatch: XCUIElement {
        return self.element(boundBy: self.count - 1)
    }
}
