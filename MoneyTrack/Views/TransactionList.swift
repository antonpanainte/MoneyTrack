//
//  TransactionList.swift
//  MoneyTrack
//
//  Created by Anton Panainte on 08.09.2025.
//

import SwiftUI

struct TransactionList: View {
    @EnvironmentObject var transactionListVM: TransactionListViewModel
    @State private var showingAddTransaction = false
    @State private var showEditSheet = false
    @State private var editingTransaction: Transaction? = nil
    
    var body: some View {
        VStack {
//            Button(action: { showingAddTransaction.toggle() }) {
//                Image(systemName: "plus")
//                    .symbolRenderingMode(.palette)
//                    .foregroundStyle(Color.Icon, .primary)
//            }
            
            
            List {
                ForEach(Array(transactionListVM.groupTransactionByMonth()), id: \.key) { month, transactions in
                    Section(header: Text(month)) {
                        ForEach(transactions) { transaction in
                            TransactionRow(transaction: transaction)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        transactionListVM.deleteTransaction(transaction)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    
                                    Button {
                                        editingTransaction = transaction
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                }
                        }
                    }
                    .listSectionSeparator(.hidden)
                }
            }
            .listStyle(.plain)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(
                    action: {showingAddTransaction.toggle()}
                ) {
                    Image(systemName: "plus")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.Icon, .primary)
                }
                .sheet(isPresented: $showingAddTransaction) {
                    AddNewTransactionView()
                        .environmentObject(transactionListVM)
                }
            }
        }
        .navigationTitle(Text("Transactions"))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $editingTransaction) { transaction in
            EditTransactionView(transaction: transaction)
                .environmentObject(transactionListVM)
        }
    }
}

#Preview {
    let transactionListVM: TransactionListViewModel = {
        let tranasctionListVM = TransactionListViewModel()
        tranasctionListVM.transactions = transactionListPreviewData
        return tranasctionListVM
    }()
    NavigationView{
        TransactionList()
            .environmentObject(transactionListVM)
    }
}
