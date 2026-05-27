//
//  SummaryCardView.swift
//  BobaBalancePlus
//
//  Created by Sherry Lee on 2026/5/27.
//

import SwiftUI

struct SummaryCardView: View {
    let totalCalories: Int
    let totalCaffeine: Int
    let drinkCount: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("本月統計")
                .bobaSectionTitleStyle()
            
            HStack(spacing: 12) {
                summaryItem(
                    emoji: "🔥",
                    value: "\(totalCalories) kcal",
                    title: "總熱量",
                    isWarning: totalCalories > 1500
                )
                
                summaryItem(
                    emoji: "☕️",
                    value: "\(totalCaffeine) mg",
                    title: "咖啡因",
                    isWarning: totalCaffeine > 400
                )
                
                summaryItem(
                    emoji: "🥤",
                    value: "\(drinkCount)",
                    title: "本月杯數",
                    isWarning: drinkCount >= 5
                )
            }
        }
        .bobaCardStyle()
    }
    
    private func summaryItem(
        emoji: String,
        value: String,
        title: String,
        isWarning: Bool
    ) -> some View {
        VStack(spacing: 7) {
            Text(emoji)
                .font(.system(size: 30))
            
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(isWarning ? Color.bobaRedText : .black)
                .minimumScaleFactor(0.65)
                .lineLimit(1)
            
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color.bobaMiniCard.opacity(0.75))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}
