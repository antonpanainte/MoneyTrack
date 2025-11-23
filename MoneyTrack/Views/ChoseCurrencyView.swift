//
//  ChoseCurrencyView.swift
//  MoneyTrack
//
//  Created by Anton Panainte on 16.09.2025.
//

import SwiftUI

struct ChoseCurrencyView: View {
    @AppStorage("selectedCurrency") private var selectedCurrency: String = ""
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea(.all)
            VStack{
                Text("Selected currency: ")
                    .font(.title3)
                + Text("\(selectedCurrency)")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(Color.icon)
                
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
        }
    }
}

#Preview {
    ChoseCurrencyView()
}
