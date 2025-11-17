//
//  UserModel.swift
//  MoneyTrack
//
//  Created by Anton Panainte on 14.09.2025.
//

import Foundation

struct User: Codable {
    var id = UUID().uuidString
    var name: String
    var amountPreference: Double
}
