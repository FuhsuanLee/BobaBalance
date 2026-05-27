//
//  BobaStyle.swift.swift
//  BobaBalancePlus
//
//  Created by Sherry Lee on 2026/5/27.
//

import SwiftUI

extension Color {
    static let bobaBackground = Color(red: 0.99, green: 0.97, blue: 0.93)
    static let bobaBrown = Color(red: 0.36, green: 0.26, blue: 0.18)
    static let bobaCard = Color(red: 1.00, green: 0.99, blue: 0.96)
    static let bobaBorder = Color(red: 0.88, green: 0.80, blue: 0.72)
    static let bobaMiniCard = Color(red: 0.96, green: 0.93, blue: 0.88)
    static let bobaGreenBackground = Color(red: 0.92, green: 0.97, blue: 0.88)
    static let bobaGreenText = Color(red: 0.28, green: 0.68, blue: 0.34)
    static let bobaRedBackground = Color(red: 1.00, green: 0.90, blue: 0.88)
    static let bobaRedText = Color(red: 0.95, green: 0.25, blue: 0.25)
}

extension View {
    func bobaCardStyle(background: Color = .bobaCard) -> some View {
        self
            .padding(20)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.bobaBorder.opacity(0.65), lineWidth: 1)
            )
            .shadow(color: .brown.opacity(0.08), radius: 8, x: 0, y: 4)
    }
    
    func bobaSectionTitleStyle() -> some View {
        self
            .font(.title2)
            .bold()
            .foregroundStyle(Color.bobaBrown)
    }
    
    func bobaBodyTextStyle() -> some View {
        self
            .foregroundStyle(.black)
    }
    
    func bobaSubTextStyle() -> some View {
        self
            .foregroundStyle(.gray)
    }
}
