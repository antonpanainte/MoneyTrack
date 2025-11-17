//
//  TransactionListViewModel.swift
//  MoneyTrack
//
//  Created by Anton Panainte on 07.09.2025.
//

import Foundation
import Combine
import Collections
import SwiftUI

typealias TransactionGroup = OrderedDictionary<String, [Transaction]>
typealias TransactionPrefixSum = [(Date, Double)]


final class TransactionListViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadTransactions()
    }
    
    //Group transaction per month, to sort in the list
    //returns a dictionary.
    func groupTransactionByMonth() -> TransactionGroup {
        guard !transactions.isEmpty else {
            return [:]
        }
        var groupedTransaction = TransactionGroup(grouping: transactions) {$0.month}
        
        for (key, value) in groupedTransaction {
               groupedTransaction[key] = value.sorted { $0.dateParsed > $1.dateParsed }
           }
        return groupedTransaction
    }
    
    func spendingByCategory(for month: Date = Date()) -> [(category: String, amount: Double, catColor: Color)] {
            let calendar = Calendar.current

            let monthlyTransactions = transactions.filter { transaction in
                calendar.isDate(transaction.dateParsed, equalTo: month, toGranularity: .month)
            }

            let grouped = Dictionary(grouping: monthlyTransactions, by: { $0.category })

            return grouped.map { (category, txs) in
                (category, txs.reduce(0) { $0 + $1.amount }, transactions.first(where: { $0.category == category })!.categoryColor)
            }
            .sorted { $0.amount > $1.amount } // biggest category first
        }
    
    func getChartDataForMonth(for month: Date = Date()) -> [ChartData] {
            // 1. Get the data as tuples
            let tupleData = spendingByCategory(for: month)
            
            // 2. Map the tuples to ChartData structs
            let chartDataArray: [ChartData] = tupleData.map { (category: String, amount: Double, catColor: Color) in
                ChartData(name: category, value: amount, color: catColor)
            }
            
            return chartDataArray
        }
    
    
    func addTransaction(_ transaction: Transaction) {
        transactions.append(transaction)
        print("Added transaction: \(transaction)")
        saveTransactions()
    }
    
    func accumulateTransaction(_ date1: Date) -> TransactionPrefixSum {
        guard !transactions.isEmpty else {
            return []
        }
        let today = date1
        
        let dateInterval = Calendar.current.dateInterval(of: .month, for: today)!
        
        var sum: Double = .zero
        var cumulativeSum = TransactionPrefixSum()
        

        for date in stride(from: dateInterval.start, to: today, by: 60 * 60 * 24) {
            let calendar = Calendar.current
            
            
            let dailyExpenses = transactions.filter { transaction in
                let transactionDate = transaction.date.dateParsed()
                return calendar.isDate(transactionDate, inSameDayAs: date) && transaction.isExpense
            }
            
            let dailyTotal = dailyExpenses.reduce(0) { $0 - $1.signedAmount }
            
            
            sum += dailyTotal
            cumulativeSum.append((date, sum))
            
        }
        return cumulativeSum
    }
    
    //Variable which includes the path of the saved information
    private var transactionsFileURL: URL {
        let manager = FileManager.default
        let documents = manager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documents.appendingPathComponent("transactions.json")
    }

    //save the full list of transactions into the save path
    func saveTransactions() {
        do {
            let data = try JSONEncoder().encode(transactions)
            try data.write(to: transactionsFileURL)
            print("Transactions saved to \(transactionsFileURL)")
        } catch {
            print("Error saving transactions: \(error)")
        }
    }

    //Load full list of transactions from the path variable
    func loadTransactions() {
        do {
            let data = try Data(contentsOf: transactionsFileURL)
            let savedTransactions = try JSONDecoder().decode([Transaction].self, from: data)
            self.transactions = savedTransactions
            print("Transactions loaded from disk")
        } catch {
            print("No saved transactions found or failed to load: \(error)")
        }
    }
    
    //deleting a transaction from the list
    func deleteTransaction(_ transaction: Transaction) {
        // Remove transaction from the array
        if let index = transactions.firstIndex(where: { $0.id == transaction.id }) {
            transactions.remove(at: index)
            saveTransactions() // Save the updated list to disk
        } else {
            print("Transaction not found")
        }
    }
    
    //Editting transaction in a list
    func updateTransaction(_ transaction: Transaction) {
        if let index = transactions.firstIndex(where: { $0.id == transaction.id }) {
            transactions[index] = transaction
            saveTransactions()
        }
    }
    
}
