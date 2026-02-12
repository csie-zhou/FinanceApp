//
//  Account+Extensions.swift
//  test2
//
//  Created by 周家弘 on 2026/2/13.
//

// Account+Extensions.swift
import Foundation
import CoreData

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
    
    var accountType: AccountType {
        guard let type = type else { return .other }
        return AccountType(rawValue: type) ?? .other
    }
}

