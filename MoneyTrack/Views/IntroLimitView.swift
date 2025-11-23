//
//  ChooseLimitView.swift
//  MoneyTrack
//
//  Created by Anton Panainte on 14.09.2025.
//

import SwiftUI

struct IntroLimitView: View {
    
    var onFinish: () -> Void
    
    @AppStorage("preferredAmount") private var savedAmount: Double = 0.0
    @AppStorage("selectedCurrency") private var selectedCurrency: String = ""
    
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
                        
                        TextField("Preffered Amount", value: $savedAmount, formatter: NumberFormatter())
                            .multilineTextAlignment(.center)
                            .padding()
                            .keyboardType(.decimalPad)
                            .background(RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(Color.primary.opacity(0.2)))
                        Spacer()
                    }
                    
                    VStack{
                        Divider()
                        HStack{
                            Picker("", selection: $selectedCurrency) {
                                Text("EUR").tag("EUR")
                                Text("USD").tag("USD")
                                Text("GBP").tag("GBP")
                            }.pickerStyle(.segmented)
                        }
                        .frame(width: 350)
                        .padding()
                    }
                    
                    Button("Confirm") {
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

