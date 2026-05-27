//
//  AdviceCardView.swift
//  BobaBalancePlus
//
//  Created by Sherry Lee on 2026/5/27.
//

import SwiftUI

struct AdviceCardView: View {
    let totalCalories: Int
    let totalCaffeine: Int
    let drinkCount: Int
    
    private var isWarning: Bool {
        totalCalories > 1500 || totalCaffeine > 400 || drinkCount >= 5
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("健康建議")
                .bobaSectionTitleStyle()
            
            Text(DrinkDataManager.getHealthAdvice(
                totalCalories: totalCalories,
                totalCaffeine: totalCaffeine,
                count: drinkCount
            ))
            .font(.body)
            .lineSpacing(6)
            .foregroundStyle(isWarning ? Color.bobaRedText : Color.bobaGreenText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .bobaCardStyle(
            background: isWarning ? .bobaRedBackground : .bobaGreenBackground
        )
    }
}
