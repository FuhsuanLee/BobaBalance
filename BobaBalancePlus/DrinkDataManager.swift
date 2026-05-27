//
//  DrinkDataManager.swift
//  BobaBalancePlus
//
//  Created by Sherry Lee on 2026/5/27.
//

import Foundation

class DrinkDataManager {
    
    static let drinks = [
        "珍珠奶茶",
        "紅茶",
        "綠茶",
        "烏龍茶",
        "水果茶",
        "拿鐵"
    ]
    
    static let sugarLevels = [
        "無糖",
        "微糖",
        "半糖",
        "少糖",
        "全糖"
    ]
    
    static func calculateCalories(drink: String, sugar: String) -> Int {
        let baseCalories: Int
        
        switch drink {
        case "珍珠奶茶":
            baseCalories = 500
        case "紅茶":
            baseCalories = 180
        case "綠茶":
            baseCalories = 160
        case "烏龍茶":
            baseCalories = 150
        case "水果茶":
            baseCalories = 300
        case "拿鐵":
            baseCalories = 250
        default:
            baseCalories = 200
        }
        
        switch sugar {
        case "無糖":
            return Int(Double(baseCalories) * 0.45)
        case "微糖":
            return Int(Double(baseCalories) * 0.6)
        case "半糖":
            return Int(Double(baseCalories) * 0.75)
        case "少糖":
            return Int(Double(baseCalories) * 0.9)
        case "全糖":
            return baseCalories
        default:
            return baseCalories
        }
    }
    
    static func calculateCaffeine(drink: String) -> Int {
        switch drink {
        case "珍珠奶茶":
            return 80
        case "紅茶":
            return 70
        case "綠茶":
            return 50
        case "烏龍茶":
            return 60
        case "水果茶":
            return 30
        case "拿鐵":
            return 100
        default:
            return 50
        }
    }
    
    static func getHealthAdvice(
        totalCalories: Int,
        totalCaffeine: Int,
        count: Int
    ) -> String {
        
        var advices: [String] = []
        
        if totalCalories > 1500 {
            advices.append("""
            ⚠️ 本月熱量過高
            👉 建議減少奶茶或改成無糖飲料
            """)
        }
        
        if totalCaffeine > 400 {
            advices.append("""
            ⚠️ 咖啡因過高
            👉 可能造成心悸或失眠，建議減少茶類或拿鐵
            """)
        }
        
        if count >= 5 {
            advices.append("""
            ⚠️ 飲料次數偏多
            👉 建議適度減少手搖飲頻率
            """)
        }
        
        if advices.isEmpty {
            return """
            ✅ 目前飲料攝取狀況還不錯
            👉 可以繼續保持低糖或無糖的選擇
            """
        }
        
        return advices.joined(separator: "\n\n")
    }
}
