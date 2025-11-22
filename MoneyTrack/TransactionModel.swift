//
//  TransactionModel.swift
//  MoneyTrack
//
//  Created by Anton Panainte on 07.09.2025.
//

import Foundation
import SwiftUIFontIcon
import SwiftUI

struct Transaction: Identifiable, Codable, Hashable {
    var id = UUID().uuidString
    let date: String
    let institution: String
    let account: String
    var merchant: String
    let amount: Double
    let type: TransactionType.RawValue
    var categoryId: Int
    var category: String
    let isPending: Bool
    var isTransfer: Bool
    var isExpense: Bool
    var isEdited: Bool
    var icon: FontAwesomeCode {
        if let category = Category.all.first(where: { $0.id == categoryId }){
            return category.icon
        }
        return .question
    }
    
    var categoryColor: Color {
        if let category = Category.all.first(where: { $0.id == categoryId }){
            return category.color
        }
        return Color.gray
    }
    
    var dateParsed: Date {
        date.dateParsed()
    }
    
    var signedAmount: Double {
        return type == TransactionType.debit.rawValue ? -amount : amount
    }
    
    var month: String {
        return dateParsed.formatted(.dateTime.year().month(.wide))
    }
}


enum TransactionType: String {
    case debit = "debit"
    case credit = "credit"
}


struct Category {
    let id: Int
    let name: String
    let icon: FontAwesomeCode
    var mainCategoryID: Int?
    let color: Color
}

extension Category {
    static let autoAndTransport = Category(id:1, name: "Auto & Transport", icon: .car_alt, color: Color(hue: 0.46, saturation: 0.85, brightness: 0.63))
    static let billsAndUtilities = Category(id:2 , name:"Bills & Utilities", icon: .file_invoice_dollar, color: Color(hue: 0.11, saturation: 0.92, brightness: 0.95))
    static let entertainment = Category(id: 3, name: "Entertainment", icon: .film, color: Color(hue: 0.03, saturation: 0.78, brightness: 0.75))
    static let feesAndCharges = Category(id: 4, name: "Fees & Charges", icon: .hand_holding_usd, color: Color(hue: 0.57, saturation: 0.76, brightness: 0.86))
    static let foodAndDining = Category(id: 5, name: "Food & Dining", icon: .hamburger, color: Color(hue: 0.79, saturation: 0.55, brightness: 0.71))
    static let home = Category(id: 6, name: "Home", icon: .home, color: Color(hue: 0.38, saturation: 0.77, brightness: 0.68))
    static let income = Category(id: 7, name: "Income", icon: .dollar_sign, color: Color(hue: 0.08, saturation: 0.73, brightness: 0.90))
    static let shopping = Category(id: 8, name: "Shopping", icon: .shopping_cart, color: Color(hue: 0.59, saturation: 0.28, brightness: 0.50))
    static let transfer  = Category(id: 9, name: "Transfer", icon: .exchange_alt, color: Color(hue: 0.44, saturation: 0.85, brightness: 0.73))
    
    static let publicTransportation = Category(id: 101, name: "Public Transportation", icon: .bus, mainCategoryID: 1, color: Color(hue: 0.76, saturation: 0.50, brightness: 0.68))
    static let taxi = Category(id: 102, name: "Taxi", icon: .taxi, mainCategoryID: 1, color: Color(hue: 0.03, saturation: 0.80, brightness: 0.91))
    static let mobilePhone = Category(id: 201, name: "Mobile Phone", icon: .mobile_alt, mainCategoryID: 2, color: Color(hue: 0.78, saturation: 0.26, brightness: 0.69))
    static let moviesAndDVDs = Category(id: 301, name: "Movies & DVDs", icon: .film, mainCategoryID: 3, color: Color(hue: 0.15, saturation: 0.92, brightness: 0.95))
    static let bankFee = Category(id: 401, name: "Bank Fee", icon: .hand_holding_usd, mainCategoryID: 4, color: Color(hue: 0.58, saturation: 0.42, brightness: 0.91))
    static let financeCharge = Category(id: 402, name: "Finance Charge", icon: .hand_holding_usd, mainCategoryID: 4, color: Color(hue: 0.56, saturation: 0.05, brightness: 0.64))
    static let groceries = Category(id: 501, name: "Groceries", icon: .shopping_basket, mainCategoryID: 5, color: Color(hue: 0.03, saturation: 0.59, brightness: 0.93))
    static let restaurants = Category(id: 502, name: "Restaurants", icon: .utensils, mainCategoryID: 5, color: Color(hue: 0.39, saturation: 0.45, brightness: 0.88))
    static let rent = Category(id: 601, name: "Rent", icon: .house_user, mainCategoryID: 6, color: Color(hue: 0.79, saturation: 0.61, brightness: 0.35))
    static let homeSuplies = Category(id: 602, name: "Home Suplies", icon: .house_user, mainCategoryID: 6, color: Color(hue: 0.06, saturation: 0.65, brightness: 0.63))
    static let paycheque = Category(id: 701, name: "Paycheque", icon: .dollar_sign, mainCategoryID: 7, color: Color(hue: 0.28, saturation: 0.59, brightness: 0.68))
    static let software = Category(id: 801, name: "Software", icon: .icons, mainCategoryID: 8, color: Color(hue: 0.12, saturation: 0.20, brightness: 0.97))
    static let creditCardPayment = Category(id: 901, name: "Credit Card Payment", icon: .exchange_alt, mainCategoryID: 9, color: Color(hue: 0.59, saturation: 0.20, brightness: 0.58))
  }

extension Category {
    static let categories: [Category] = [
        .autoAndTransport,
        .billsAndUtilities,
        .entertainment,
        .feesAndCharges,
        .foodAndDining,
        .home,
        .income,
        .shopping,
        .transfer
        ]
    
    static let subCategories: [Category] = [
        .publicTransportation,
        .taxi,
        .mobilePhone,
        .moviesAndDVDs,
        .bankFee,
        .financeCharge,
        .groceries,
        .restaurants,
        .rent,
        .homeSuplies,
        .paycheque,
        .software,
        .creditCardPayment
    ]
    
    static let all: [Category] = categories + subCategories
}

