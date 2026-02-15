//
//  MainTabView.swift
//  test2
//
//  Created by 周家弘 on 2026/2/12.
//

// MainTabView.swift
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            AccountsView()
                .tabItem {
                    Image(systemName: "wallet.pass")
                    Text("帳戶")
                }
            
            Color.clear
                .tabItem {
                    Image(systemName: "triangle")
                        .renderingMode(.template)
                    Text("")
                }
            
            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("記帳")
                }
            
            MonthlyReportView()
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("報表")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "slider.horizontal.3")
                    Text("設定")
                }
        }
    }
}
