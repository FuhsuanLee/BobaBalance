//
//  DrinkRecord.swift
//  BobaBalancePlus
//
//  Created by Sherry Lee on 2026/5/27.
//

import Foundation

struct DrinkRecord: Identifiable, Codable {
    let id: UUID
    let name: String
    let sugarLevel: String
    let calories: Int
    let caffeine: Int
    let date: Date
    
    init(
        id: UUID = UUID(),
        name: String,
        sugarLevel: String,
        calories: Int,
        caffeine: Int,
        date: Date
    ) {
        self.id = id
        self.name = name
        self.sugarLevel = sugarLevel
        self.calories = calories
        self.caffeine = caffeine
        self.date = date
    }
}
