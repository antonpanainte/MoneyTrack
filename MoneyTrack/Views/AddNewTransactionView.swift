//
//  AddNewTransaction.swift
//  MoneyTrack
//
//  Created by Anton Panainte on 08.09.2025.
//

import SwiftUI


struct AddNewTransactionView: View {
        @Environment(\.dismiss) var dismiss
        @EnvironmentObject var store: TransactionListViewModel
        
        @State private var date = Date()
        @State private var institution = ""
        @State private var account = ""
        @State private var merchant = ""
        @State private var amount = ""
        @State private var type: TransactionType = .debit
        @State private var categoryId = 1
        @State private var category = ""
        @State private var isPending = false
        
        var body: some View {
            NavigationView {
                ZStack {
                    Rectangle()
                        .frame(width: 5000, height: 10000)
                        .ignoresSafeArea()
                        .foregroundStyle(LinearGradient(colors: [Color.white, Color.icon],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing))
                        .opacity(0.1)
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
                    .navigationTitle("New Transaction")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button() {
                                if let selectedCategory = Category.all.first(where: { $0.id == categoryId }),
                                   let amountValue = Double(amount.replacingOccurrences(of: ",", with: ".")) {
                                    let transaction = Transaction(
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
                                        isEdited: false
                                    )
                                    store.addTransaction(transaction)
                                    dismiss()
                                }
                            } label : {
                                Label("", systemImage: "square.and.arrow.down.badge.checkmark")
                            }
                            .tint(Color.text)
                            
                        }
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button() {
                                dismiss()
                            } label : {
                                    Image(systemName: "xmark")
                            }
                            .tint(Color.Text)
                            
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
                .background(Color.Background.opacity(0.7))
            }
            
        }
    }

#Preview {
    let mockStore = TransactionListViewModel()
    AddNewTransactionView()
        .environmentObject(mockStore)
}
