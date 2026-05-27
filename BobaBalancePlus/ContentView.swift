//
//  ContentView.swift
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

struct ContentView: View {
    @State private var selectedBrand = DrinkDataManager.brands[0]
    @State private var selectedDrinkItem = DrinkDataManager.drinkItems(for: DrinkDataManager.brands[0])[0]
    @State private var selectedSugar = DrinkDataManager.sugarLevels[2]
    @State private var records: [DrinkRecord] = []
    @State private var showClearAlert = false
    
    private let storageKey = "drinkRecords"
    
    var totalCalories: Int {
        records.reduce(0) { $0 + $1.calories }
    }
    
    var totalCaffeine: Int {
        records.reduce(0) { $0 + $1.caffeine }
    }
    
    var isWarning: Bool {
        totalCalories > 1500 || totalCaffeine > 400 || records.count >= 5
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    headerView
                    addDrinkCard
                    summaryCard
                    adviceCard
                    recordsCard
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 30)
            }
            .background(Color.bobaBackground.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
            .alert("確定要清除嗎？", isPresented: $showClearAlert) {
                Button("取消", role: .cancel) { }
                Button("清除", role: .destructive) {
                    clearAllRecords()
                }
            } message: {
                Text("此動作會刪除所有飲料紀錄，且無法復原。")
            }
        }
    }
    
    private var headerView: some View {
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
    
    private var addDrinkCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("新增紀錄")
                .font(.title2)
                .bold()
            
            Text("選擇品牌")
                .font(.headline)

            Picker("選擇品牌", selection: $selectedBrand) {
                ForEach(DrinkDataManager.brands, id: \.self) { brand in
                    Text(brand).tag(brand)
                }
            }
            .pickerStyle(.menu)
            .tint(Color.bobaBrown)
            .onChange(of: selectedBrand) { newBrand in
                selectedDrinkItem = DrinkDataManager.drinkItems(for: newBrand)[0]
            }
            
            Text("選擇飲料")
                .font(.headline)

            Picker("選擇飲料", selection: $selectedDrinkItem) {
                ForEach(DrinkDataManager.drinkItems(for: selectedBrand)) { item in
                    Text(item.name).tag(item)
                }
            }
            .pickerStyle(.menu)
            .tint(Color.bobaBrown)
            
            Text("選擇糖度")
                .font(.headline)
            
            Picker("選擇糖度", selection: $selectedSugar) {
                ForEach(DrinkDataManager.sugarLevels, id: \.self) { sugar in
                    Text(sugar).tag(sugar)
                }
            }
            .pickerStyle(.segmented)
            
            Button {
                addDrink()
            } label: {
                Text("＋ 新增飲料")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.brown)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
        .bobaCardStyle()
    }
    
    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("本月統計")
                .font(.title2)
                .bold()
            
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
                    value: "\(records.count)",
                    title: "本月杯數",
                    isWarning: records.count >= 5
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
    
    private var adviceCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("健康建議")
                .font(.title2)
                .bold()
            
            Text(DrinkDataManager.getHealthAdvice(
                totalCalories: totalCalories,
                totalCaffeine: totalCaffeine,
                count: records.count
            ))
            .font(.body)
            .lineSpacing(6)
            .foregroundStyle(isWarning ? Color.bobaRedText : Color.bobaGreenText)
        }
        .frame(maxWidth: .infinity, alignment: .leading) //
        .bobaCardStyle(
            background: isWarning ? .bobaRedBackground : .bobaGreenBackground
        )
    }
    
    private var recordsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("飲料紀錄")
                .font(.title2)
                .bold()

            if records.isEmpty {
                Text("目前還沒有紀錄")
                    .font(.headline)
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 30)
            } else {
                ForEach(records) { record in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(record.name)｜\(record.sugarLevel)")
                            .font(.title3)
                            .bold()
                            .foregroundStyle(.black)

                        Text("\(record.calories) kcal｜咖啡因 \(record.caffeine) mg｜\(formatDate(record.date))")
                            .font(.headline)
                            .foregroundStyle(.gray)

                        Divider()
                    }
                    .padding(.vertical, 8)
                }

                Button(role: .destructive) {
                    showClearAlert = true
                } label: {
                    HStack {
                        Image(systemName: "trash")
                        Text("清除所有紀錄")
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .foregroundStyle(Color.bobaRedText)
                    .background(Color.bobaRedBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.top, 8)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .bobaCardStyle()
    }
    
    private func addDrink() {
        let calories = DrinkDataManager.calculateCalories(
            drinkItem: selectedDrinkItem,
            sugar: selectedSugar
        )

        let caffeine = DrinkDataManager.calculateCaffeine(
            drinkItem: selectedDrinkItem
        )

        let record = DrinkRecord(
            name: selectedDrinkItem.name,
            sugarLevel: selectedSugar,
            calories: calories,
            caffeine: caffeine,
            date: Date()
        )
        
        records.append(record)
        saveRecords()
    }
    
    private func deleteRecord(at offsets: IndexSet) {
        records.remove(atOffsets: offsets)
        saveRecords()
    }
    
    private func clearAllRecords() {
        records.removeAll()
        saveRecords()
    }
    
    private func saveRecords() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(records) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
    
    private func loadRecords() {
        if let data = UserDefaults.standard.data(forKey: storageKey) {
            let decoder = JSONDecoder()
            if let savedRecords = try? decoder.decode([DrinkRecord].self, from: data) {
                records = savedRecords
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        return formatter.string(from: date)
    }
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
}

#Preview {
    ContentView()
}
