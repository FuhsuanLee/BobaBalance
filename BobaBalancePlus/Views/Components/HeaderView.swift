//
//  HeaderView.swift
//  BobaBalancePlus
//
//  Created by Sherry Lee on 2026/5/27.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        VStack(spacing: 2) {
            Text("Boba Balance")
                .font(.system(size: 44, weight: .bold, design: .serif))
                .foregroundStyle(Color.bobaBrown)
            
            Text("你的手搖杯紀錄小幫手")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.gray.opacity(0.75))
        }
        .padding(.top, 10)
        .padding(.bottom, 8)
    }
}
