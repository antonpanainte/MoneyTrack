//
//  MainView.swift
//  MoneyTrack
//
//  Created by Anton Panainte on 16.09.2025.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var transactionListVM: TransactionListViewModel
    
    
    
    var body: some View {
        
        TabView{
            ContentView()
                .tag(1)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            PieChartView()
                .tag(2)
                .tabItem {
                    Label("Dashboard", systemImage: "chart.pie")
                }
            SettingsView()
                .tag(3)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
            
        }
        .accentColor(.Icon)
        
        
    }
}

#Preview {
    let transactionListVM: TransactionListViewModel = {
            let tranasctionListVM = TransactionListViewModel()
            tranasctionListVM.transactions = transactionListPreviewData
            return tranasctionListVM
        }()
    MainView()
            .environmentObject(transactionListVM)
}
