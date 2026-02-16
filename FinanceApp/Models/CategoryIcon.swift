//
//  CategoryIcon.swift
//  FinanceApp
//
//  Created by 周家弘 on 2026/2/12.
//

// CategoryIcon.swift
import SwiftUI

struct CategoryIcon: View {
    let category: String
    let size: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .fill(categoryColor.opacity(0.2))
                .frame(width: size, height: size)
            
            Image(systemName: categoryIcon)
                .font(.system(size: size * 0.5))
                .foregroundColor(categoryColor)
        }
    }
    
    var categoryIcon: String {
        switch category {
        case "午餐", "早餐", "晚餐", "飲食": return "fork.knife"
        case "運動": return "sportscourt"
        case "美容美髮": return "scissors"
        case "點心": return "birthday.cake"
        case "摩托車": return "scooter"
        case "宵夜": return "moon.stars"
        case "交通": return "car"
        case "購物": return "cart"
        case "娛樂": return "gamecontroller"
        case "書籍": return "book"
        default: return "circle"
        }
    }
    
    var categoryColor: Color {
        switch category {
        case "午餐", "早餐", "晚餐", "飲食": return .orange
        case "運動": return .purple
        case "美容美髮": return .green
        case "點心": return .orange
        case "摩托車": return .blue
        case "宵夜": return .orange
        case "交通": return .blue
        case "購物": return .pink
        case "娛樂": return .red
        case "書籍": return .yellow
        default: return .gray
        }
    }
}

// Predefined categories
struct CategoryData {
    static let expenseCategories = [
        "午餐", "早餐", "晚餐", "點心", "飲料", "宵夜",
        "美容美髮", "運動", "摩托車",
        "交通", "購物", "娛樂", "書籍", "帳單"
    ]
    
    static let incomeCategories = [
        "薪水", "獎金", "投資", "其他收入"
    ]
}
