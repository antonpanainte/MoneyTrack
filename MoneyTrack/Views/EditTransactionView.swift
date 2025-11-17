//
//  EditTransactionView.swift
//  MoneyTrack
//
//  Created by Anton Panainte on 10.09.2025.
//

import SwiftUI



struct EditTransactionView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var store: TransactionListViewModel
        
        var transaction: Transaction
        
        // Pre-fill state with the transaction values
        @State private var date: Date
        @State private var institution: String
        @State private var account: String
        @State private var merchant: String
        @State private var amount: String
        @State private var type: TransactionType
        @State private var categoryId: Int
        @State private var isPending: Bool
        
        init(transaction: Transaction) {
            self.transaction = transaction
            
            // Initialize the @State vars with existing values
            _date = State(initialValue: transaction.dateParsed)
            _institution = State(initialValue: transaction.institution)
            _account = State(initialValue: transaction.account)
            _merchant = State(initialValue: transaction.merchant)
            _amount = State(initialValue: String(transaction.amount))
            _type = State(initialValue: TransactionType(rawValue: transaction.type) ?? .debit)
            _categoryId = State(initialValue: transaction.categoryId)
            _isPending = State(initialValue: transaction.isPending)
        }
        
    var body: some View {
        NavigationView {
            ZStack {
                Rectangle()
                    .frame(width: .infinity, height: .infinity)
                    .ignoresSafeArea()
                    .foregroundStyle(LinearGradient(colors: [Color.white, Color.icon],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing))
                    .opacity(0.4)
                VStack {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 20).fill(Color.systemBackground.opacity(0.6)).shadow(radius: 5, x: 0, y: 3))
                        .containerRelativeFrame(.horizontal, count : 100, span: 85, spacing: 0)
                    VStack {
                        TextField("Institution", text: $institution)
                            .padding(.bottom)
                        TextField("Account", text: $account)
                            .padding(.bottom)
                        TextField("Merchant", text: $merchant)
                            
                            
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.systemBackground.opacity(0.6)).shadow(radius: 5, x: 0, y: 3))
                    .containerRelativeFrame(.horizontal, count : 100, span: 85, spacing: 0)
                    
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 20).fill(Color.systemBackground.opacity(0.6)).shadow(radius: 5, x: 0, y: 3))
                        .containerRelativeFrame(.horizontal, count : 100, span: 85, spacing: 0)
                    
                    Picker("Type", selection: $type) {
                        Text("Debit").tag(TransactionType.debit)
                            .accentColor(Color.Icon)
                        Text("Credit").tag(TransactionType.credit)
                            .accentColor(Color.Icon)
                    }
                    .accentColor(Color.Icon)
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.systemBackground.opacity(0.6)).shadow(radius: 5, x: 0, y: 3))
                    .containerRelativeFrame(.horizontal, count : 100, span: 85, spacing: 0)

                    Picker("Category", selection: $categoryId) {
                        ForEach(Category.all, id: \.id) { cat in
                            Text(cat.name).tag(cat.id)
                        }
                    }
                    .containerRelativeFrame(.horizontal, count : 100, span: 77, spacing: 0)
                    .pickerStyle(WheelPickerStyle())
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.systemBackground.opacity(0.6)).shadow(radius: 3, x: 0, y: 3))
                    .frame(height: 120)
                    
                    
                    Toggle("Pending", isOn: $isPending)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 20).fill(Color.systemBackground.opacity(0.6)).shadow(radius: 5, x: 0, y: 3))
                        .containerRelativeFrame(.horizontal, count : 100, span: 85, spacing: 0)
                }
                
                .frame(maxWidth: .infinity, maxHeight:.infinity)
                .navigationTitle("Editting transaction")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button() {
                            if let selectedCategory = Category.all.first(where: { $0.id == categoryId }),
                               let amountValue = Double(amount) {
                                let transaction = Transaction(
                                    id: transaction.id,
                                    date: date.ISO8601Format(),
                                    institution: institution,
                                    account: account,
                                    merchant: merchant,
                                    amount: amountValue,
                                    type: type.rawValue,
                                    categoryId: selectedCategory.id,
                                    category: selectedCategory.name,
                                    isPending: isPending,
                                    isTransfer: selectedCategory.id == Category.transfer.id,
                                    isExpense: type == .debit,
                                    isEdited: true
                                )
                                store.updateTransaction(transaction)
                                dismiss()
                            }
                        } label : {
                            Label("", systemImage: "square.and.arrow.down.badge.checkmark")
                        }
                        .foregroundStyle(Color.primary, .primary)
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button() {
                            dismiss()
                        } label : {
                            Label("", systemImage: "xmark")
                                .foregroundStyle(Color.primary, .primary)
                        }
                        
                        
                    }
                    
                }
                .scrollContentBackground(.hidden)
            }
            .background(Color.Background)
        }
        
    }
}
#Preview {
    EditTransactionView(transaction: transactionPreviewData)
}
