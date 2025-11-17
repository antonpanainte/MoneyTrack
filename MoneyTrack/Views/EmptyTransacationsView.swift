//
//  EmptyTransacationsView.swift
//  MoneyTrack
//
//  Created by Anton Panainte on 15.09.2025.
//

import SwiftUI

struct EmptyTransacationsView: View {
    @State private var showAddNewTransaction = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Let's add your first transaction!")
                    .font(.title3)
                    .padding()
                Spacer()
            }
            
            Button(action: { showAddNewTransaction.toggle()}) {
                Image(systemName: "plus")
                    .foregroundStyle(Color.icon)
            }
            .sheet(isPresented: $showAddNewTransaction) {
                AddNewTransactionView()
            }
        }
        .padding()
        .background(Color.systemBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.primary.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    EmptyTransacationsView()
}
