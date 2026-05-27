//
//  AnalysisCardView.swift
//  BobaBalancePlus
//
//  Created by Sherry Lee on 2026/5/27.
//

import SwiftUI

struct AnalysisCardView: View {
    let records: [DrinkRecord]
    
    private var mostFrequentBrand: String {
        let grouped = Dictionary(grouping: records, by: { $0.brand })
        return grouped.max { $0.value.count < $1.value.count }?.key ?? "尚無資料"
    }
    
    private var mostFrequentDrink: String {
        let grouped = Dictionary(grouping: records, by: { $0.name })
        return grouped.max { $0.value.count < $1.value.count }?.key ?? "尚無資料"
    }
    
    private var highestCalorieRecord: DrinkRecord? {
        records.max { $0.calories < $1.calories }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("本月小分析")
                .bobaSectionTitleStyle()
            
            if records.isEmpty {
                Text("新增幾筆飲料後，這裡會顯示你的飲用習慣分析。")
                    .font(.headline)
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                analysisRow(
                    icon: "🏪",
                    title: "最常喝品牌",
                    value: mostFrequentBrand
                )
                
                analysisRow(
                    icon: "🧋",
                    title: "最常喝飲料",
                    value: mostFrequentDrink
                )
                
                if let highest = highestCalorieRecord {
                    analysisRow(
                        icon: "🔥",
                        title: "最高熱量紀錄",
                        value: "\(highest.name) \(highest.calories) kcal"
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .bobaCardStyle()
    }
    
    private func analysisRow(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 12) {
            Text(icon)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                Text(value)
                    .font(.headline)
                    .foregroundStyle(Color.bobaBrown)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.bobaMiniCard.opacity(0.75))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
