//
//  MoneyTrackApp.swift
//  MoneyTrack
//
//  Created by Anton Panainte on 07.09.2025.
//

import SwiftUI

@main
struct MoneyTrackApp: App {
    @StateObject var transactionListVM = TransactionListViewModel()
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    @AppStorage("hasIntroducedUser") private var hasIntroducedUser: Bool = false
    @AppStorage("selectedCurrency") private var selectedCurrency: String = "EUR"
 
    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding && hasIntroducedUser {
                MainView()
                    .environmentObject(transactionListVM)
            }
            else if !hasSeenOnboarding && !hasIntroducedUser{
                IntroNameView{
                    hasIntroducedUser = true
                }
            }
            else if !hasSeenOnboarding && hasIntroducedUser{
                IntroLimitView{
                    hasSeenOnboarding = true
                }
            }
            
        }
    }
}
