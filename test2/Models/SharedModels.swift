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

// MARK: - Time Period (For Filtering)
enum TimePeriod: String, CaseIterable {
    case day = "日"
    case week = "週"
    case month = "月"
    case year = "年"
    case all = "全部"
}

// MARK: - Chart Data Point (For Charts)
struct ChartDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let amount: Double
    let category: String?
}

// MARK: - Date Extensions
extension Date {
    func startOfMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        return Calendar.current.date(from: components)!
    }
    
    func endOfMonth() -> Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth())!
    }
    
    func startOfWeek() -> Date {
        let components = Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return Calendar.current.date(from: components)!
    }
    
    func endOfWeek() -> Date {
        var components = DateComponents()
        components.weekOfYear = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfWeek())!
    }
    
    func startOfDay() -> Date {
        Calendar.current.startOfDay(for: self)
    }
    
    func endOfDay() -> Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay())!
    }
}

// MARK: - Double Extensions
extension Double {
    var formattedCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "TWD"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: self)) ?? "$\(Int(self))"
    }
    
    var abbreviated: String {
        let thousand = self / 1000
        let million = self / 1_000_000
        
        if abs(million) >= 1 {
            return String(format: "%.1fM", million)
        } else if abs(thousand) >= 1 {
            return String(format: "%.1fK", thousand)
        } else {
            return String(format: "%.0f", self)
        }
    }
}

//// MARK: - Color Extensions
//extension Color {
//    static let incomeGreen = Color.green
//    static let expenseRed = Color.red
//    static let transferBlue = Color.blue
//    
//    // Initialize from hex string
//    init(hex: String) {
//        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
//        var int: UInt64 = 0
//        Scanner(string: hex).scanHexInt64(&int)
//        let a, r, g, b: UInt64
//        switch hex.count {
//        case 3: // RGB (12-bit)
//            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
//        case 6: // RGB (24-bit)
//            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
//        case 8: // ARGB (32-bit)
//            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
//        default:
//            (a, r, g, b) = (255, 0, 0, 0)
//        }
//        
//        self.init(
//            .sRGB,
//            red: Double(r) / 255,
//            green: Double(g) / 255,
//            blue:  Double(b) / 255,
//            opacity: Double(a) / 255
//        )
//    }
//    
//    // Convert to hex string
//    func toHex() -> String {
//        guard let components = UIColor(self).cgColor.components, components.count >= 3 else {
//            return "#000000"
//        }
//        
//        let r = Float(components[0])
//        let g = Float(components[1])
//        let b = Float(components[2])
//        
//        return String(format: "#%02lX%02lX%02lX",
//                     lroundf(r * 255),
//                     lroundf(g * 255),
//                     lroundf(b * 255))
//    }
//}
