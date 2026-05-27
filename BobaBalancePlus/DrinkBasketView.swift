//
//  DrinkBasketView.swift
//  BobaBalancePlus
//
//  Created by Sherry Lee on 2026/5/27.
//

import SwiftUI

struct DrinkBasketView: View {
    let records: [DrinkRecord]

    // 固定落點：看起來像自然散落 但不容易重疊
    private let cupSlots: [CGPoint] = [
        // 前排
        CGPoint(x: 0.18, y: 0.56),
        CGPoint(x: 0.34, y: 0.55),
        CGPoint(x: 0.50, y: 0.56),
        CGPoint(x: 0.66, y: 0.55),
        CGPoint(x: 0.82, y: 0.56),

        // 中排
        CGPoint(x: 0.25, y: 0.45),
        CGPoint(x: 0.42, y: 0.44),
        CGPoint(x: 0.58, y: 0.45),
        CGPoint(x: 0.75, y: 0.44),

        // 後排
        CGPoint(x: 0.32, y: 0.34),
        CGPoint(x: 0.50, y: 0.33),
        CGPoint(x: 0.68, y: 0.34)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("我的飲料筐")
                .font(.title2)
                .bold()

            if records.isEmpty {
                emptyBasket
            } else {
                basketView
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .bobaCardStyle()
    }

    private var emptyBasket: some View {
        ZStack {
            Image("basket_container")
                .resizable()
                .scaledToFit()
                .scaleEffect(1.3)

            Text("新增飲料後，杯子會掉進這個飲料筐裡")
                .font(.headline)
                .foregroundStyle(.gray)
                .offset(y: 20)
        }
        .frame(height: 190)
    }

    private var basketView: some View {
        GeometryReader { geometry in
            ZStack {
                Image("basket_container")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width)
                    .scaleEffect(1.3)

                ForEach(Array(records.suffix(12).enumerated()), id: \.element.id) { index, record in
                    let point = slotPosition(
                        index: index,
                        width: geometry.size.width,
                        height: geometry.size.height
                    )

                    FallingCupView(
                        emoji: cupEmoji(for: record),
                        x: point.x,
                        y: point.y,
                        rotation: cupRotation(index: index),
                        delay: min(Double(index) * 0.05, 0.35)
                    )
                    .zIndex(zIndex(for: index))
                }
            }
        }
        .frame(height: 190)
    }

    private func cupEmoji(for record: DrinkRecord) -> String {
        if record.name.contains("奶茶") ||
            record.name.contains("歐蕾") ||
            record.name.contains("拿鐵") ||
            record.name.contains("鮮奶茶") {
            return "🧋"
        } else if record.name.contains("咖啡") {
            return "☕️"
        } else if record.name.contains("果") ||
                    record.name.contains("檸檬") ||
                    record.name.contains("柳橙") ||
                    record.name.contains("蜂蜜") {
            return "🧃"
        } else {
            return "🥤"
        }
    }

    private func slotPosition(index: Int, width: CGFloat, height: CGFloat) -> CGPoint {
        let safeIndex = index % cupSlots.count
        let slot = cupSlots[safeIndex]

        return CGPoint(
            x: width * slot.x,
            y: height * slot.y
        )
    }

    private func cupRotation(index: Int) -> Double {
        let rotations: [Double] = [-9, -5, 4, 8, -3, 6, -7, 2, 10, -4, 5, 0]
        return rotations[index % rotations.count]
    }

    private func zIndex(for index: Int) -> Double {
        // 前排在最上層 讓它更像堆在籃子裡
        if index < 5 {
            return 3
        } else if index < 9 {
            return 2
        } else {
            return 1
        }
    }
}

struct FallingCupView: View {
    let emoji: String
    let x: CGFloat
    let y: CGFloat
    let rotation: Double
    let delay: Double

    @State private var hasDropped = false

    var body: some View {
        Text(emoji)
            .font(.system(size: 36))
            .rotationEffect(.degrees(hasDropped ? rotation : 0))
            .scaleEffect(hasDropped ? 1.0 : 0.85)
            .position(
                x: x,
                y: hasDropped ? y : -90
            )
            .opacity(hasDropped ? 1 : 0)
            .animation(
                .interpolatingSpring(
                    mass: 1.2,
                    stiffness: 70,
                    damping: 12,
                    initialVelocity: 4
                )
                .delay(delay),
                value: hasDropped
            )
            .onAppear {
                hasDropped = true
            }
    }
}
