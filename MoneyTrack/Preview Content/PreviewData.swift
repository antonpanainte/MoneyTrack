//
//  PreviewData.swift
//  MoneyTrack
//
//  Created by Anton Panainte on 07.09.2025.
//

import Foundation

var transactionPreviewData = Transaction(date: "01/24/2025", institution: "Demo Bank", account: "Visa Demo", merchant: "Apple", amount: 11.49, type: "debit", categoryId: 801, category: "Software", isPending: false, isTransfer: false, isExpense: true, isEdited: false)

var transactionPreviewData2 = Transaction(date: "01/24/2025", institution: "Demo Bank", account: "Visa Demo", merchant: "Apple", amount: 11.49, type: "debit", categoryId: 2, category: "Bills & Utilities", isPending: false, isTransfer: false, isExpense: true, isEdited: false)

var transactionListPreviewData = [transactionPreviewData, transactionPreviewData2]



