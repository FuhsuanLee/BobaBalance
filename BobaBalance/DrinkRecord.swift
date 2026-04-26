//
//  DrinkRecord.swift
//  BobaBalance
//
//  Created by Sherry Lee on 2026/4/26.
//

import Foundation

struct DrinkRecord: Codable {
    let name: String
    let sugarLevel: String
    let calories: Int
    let caffeine: Int
    let date: Date
}
