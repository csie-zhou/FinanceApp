//
//  Account+CoreDataClass.swift
//  test2
//
//  Created by 周家弘 on 2026/2/12.
//

// Account+CoreDataClass.swift
import Foundation
import CoreData

@objc(Account)
public class Account: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var balance: Double
    @NSManaged public var currency: String?
    @NSManaged public var icon: String?
}

extension Account {
    enum AccountType: String, CaseIterable {
        case cash = "現金"
        case bank = "銀行"
        case credit = "信用卡"
        case debit = "儲值卡"
        case other = "其他"
        
        var systemImage: String {
            switch self {
            case .cash: return "banknote"
            case .bank: return "building.columns"
            case .credit: return "creditcard"
            case .debit: return "giftcard"
            case .other: return "ellipsis.circle"
            }
        }
    }
}
