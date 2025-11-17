//
//  TransactionRow.swift
//  MoneyTrack
//
//  Created by Anton Panainte on 07.09.2025.
//

import SwiftUI
import SwiftUIFontIcon

struct TransactionRow: View {
    var transaction: Transaction
    @AppStorage("selectedCurrency") private var selectedCurrency: String = ""

    var body: some View {
        HStack(spacing: 20){
            
            //icon
            RoundedRectangle(cornerRadius: 23, style: .continuous)
                .fill(Color.icon.opacity(0.3))
                .frame(width: 46, height: 46)
                .overlay {
                    FontIcon.text(.awesome5Solid(code: transaction.icon), fontsize: 24, color: Color.icon)
                }
            
            
            VStack(alignment: .leading, spacing: 6){
                //Merchant
                Text(transaction.merchant)
                    .font(.subheadline)
                    .bold()
                    .lineLimit(1)
                
                //Category
                Text(transaction.category)
                    .font(.footnote)
                    .opacity(0.7)
                    .lineLimit(1)
                
                //Day
                Text(transaction.dateParsed, format: .dateTime.year().month().day())
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
                
            }
            Spacer()
            
            //Amount
            Text(transaction.signedAmount, format: .currency(code: selectedCurrency))
                .bold()
                .foregroundColor(transaction.type == TransactionType.credit.rawValue ? Color.Text : .primary)
        }
        .padding([.top, .bottom], 8)
    }
}

#Preview {
    TransactionRow(transaction: transactionPreviewData)
}
