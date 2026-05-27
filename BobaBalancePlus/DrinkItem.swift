//
//  DrinkItem.swift
//  BobaBalancePlus
//
//  Created by Sherry Lee on 2026/5/27.
//

import Foundation

struct DrinkItem: Identifiable, Codable, Hashable {
    let id: UUID
    let brand: String
    let name: String
    let category: String
    let baseCalories: Int
    let caffeine: Int
    
    init(
        id: UUID = UUID(),
        brand: String,
        name: String,
        category: String,
        baseCalories: Int,
        caffeine: Int
    ) {
        self.id = id
        self.brand = brand
        self.name = name
        self.category = category
        self.baseCalories = baseCalories
        self.caffeine = caffeine
    }
}
