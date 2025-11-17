//
//  ChooseLimitView.swift
//  MoneyTrack
//
//  Created by Anton Panainte on 14.09.2025.
//

import SwiftUI

struct IntroLimitView: View {
    @State private var user = User(name: "Alice", amountPreference: 0.0)
    @State private var navigate = false
    var onFinish: () -> Void
    
    @AppStorage("preferredAmount") private var savedAmount: Double = 0.0
    
    
    var body: some View {
        
            ZStack {
                Rectangle()
                    .edgesIgnoringSafeArea(.all)
                    .foregroundStyle(Color.background)
                
                VStack {
                        Text("Welcome to MoneyTrack!")
                            .bold(true)
                            .font(.title2)
                            .padding(.bottom, 24)
                    
                    
                    Text("How much money you wish to spend per month?")
                        .font(.subheadline)
                    
                    HStack(spacing: 24) {
                        Spacer()
                        
                        TextField("Preffered Amount", value: $user.amountPreference, formatter: NumberFormatter())
                            .multilineTextAlignment(.center)
                            .padding()
                            .keyboardType(.decimalPad)
                            .background(RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(Color.primary.opacity(0.2)))
                        Spacer()
                    }
                    Button("Confirm") {
                        savedAmount = user.amountPreference
                        onFinish()
                    }
                    .tint(Color.primary)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 40)
                    .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(Color.icon))
                    .shadow(color: .primary.opacity(0.3), radius: 6, x: 0, y: 5)
                    
                }
                .background(Color.background)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            }
    }
}

#Preview {
    IntroLimitView{
    
    } // pass binding
}

