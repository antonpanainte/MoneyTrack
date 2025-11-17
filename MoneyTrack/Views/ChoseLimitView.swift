//
//  ChoseLimitView.swift
//  MoneyTrack
//
//  Created by Anton Panainte on 14.09.2025.
//

import SwiftUI

struct ChoseLimitView: View {
    @Environment(\.dismiss) var dismiss
    
    
    @AppStorage("preferredAmount") private var savedAmount: Double = 0.0
    @State private var user = User( name: "Alice", amountPreference: 0.0)
    @AppStorage("selectedCurrency") private var selectedCurrency: String = ""
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color.background.ignoresSafeArea(.all)
                
                VStack {
                    Text("The limit is: ")
                        .font(.headline)
                    + Text("\(savedAmount.formatted(.currency(code: selectedCurrency)))")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(Color.icon)
                    
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
                    Button("Save") {
                        savedAmount = user.amountPreference
                        dismiss()
                    }
                    .tint(Color.primary)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 40)
                    .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(Color.icon))
                    .shadow(color: .primary.opacity(0.15), radius: 6, x: 0, y: 5)
                    
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            }
            .onAppear {
                user.amountPreference = savedAmount
            }
        }
        
            
    }
}


#Preview {
    ChoseLimitView()
}
