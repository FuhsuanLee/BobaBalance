//
//  ContentView.swift
//  BobaBalancePlus
//
//  Created by Sherry Lee on 2026/5/27.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedBrand = DrinkDataManager.brands[0]
    @State private var selectedDrinkItem = DrinkDataManager.drinkItems(for: DrinkDataManager.brands[0])[0]
    @State private var selectedCategory = "全部"
    @State private var selectedSugar = DrinkDataManager.sugarLevels[2]
    @State private var records: [DrinkRecord] = []
    
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
    
    var mostFrequentBrand: String {
        let grouped = Dictionary(grouping: records, by: { $0.brand })
        return grouped.max { $0.value.count < $1.value.count }?.key ?? "尚無資料"
    }

    var mostFrequentDrink: String {
        let grouped = Dictionary(grouping: records, by: { $0.name })
        return grouped.max { $0.value.count < $1.value.count }?.key ?? "尚無資料"
    }

    var highestCalorieRecord: DrinkRecord? {
        records.max { $0.calories < $1.calories }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    HeaderView()
                    AddDrinkCardView(
                        selectedBrand: $selectedBrand,
                        selectedCategory: $selectedCategory,
                        selectedDrinkItem: $selectedDrinkItem,
                        selectedSugar: $selectedSugar,
                        onAddDrink: addDrink
                    )
                    SummaryCardView(
                        totalCalories: totalCalories,
                        totalCaffeine: totalCaffeine,
                        drinkCount: records.count
                    )
                    AdviceCardView(
                        totalCalories: totalCalories,
                        totalCaffeine: totalCaffeine,
                        drinkCount: records.count
                    )
                    AnalysisCardView(records: records)
                    RecordNavigationCardView(
                        records: $records,
                        onRecordsChanged: saveRecords
                    )
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 30)
            }
            .background(Color.bobaBackground.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
        }
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
            brand: selectedDrinkItem.brand,
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

struct RecordListView: View {
    @Binding var records: [DrinkRecord]
    let onRecordsChanged: () -> Void

    @State private var showClearAlert = false

    var body: some View {
        List {
            if records.isEmpty {
                Text("目前還沒有紀錄")
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 30)
            } else {
                ForEach(records) { record in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(record.brand)｜\(record.name)｜\(record.sugarLevel)")
                            .font(.headline)

                        Text("\(record.calories) kcal｜咖啡因 \(record.caffeine) mg｜\(formatDate(record.date))")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                    .padding(.vertical, 6)
                }
                .onDelete(perform: deleteRecords)
            }
        }
        .navigationTitle("飲料紀錄")
        .toolbar {
            if !records.isEmpty {
                Button(role: .destructive) {
                    showClearAlert = true
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
        .alert("確定要清除嗎？", isPresented: $showClearAlert) {
            Button("取消", role: .cancel) { }
            Button("清除", role: .destructive) {
                clearAllRecords()
            }
        } message: {
            Text("此動作會刪除所有飲料紀錄，且無法復原。")
        }
    }

    private func deleteRecords(at offsets: IndexSet) {
        records.remove(atOffsets: offsets)
        onRecordsChanged()
    }

    private func clearAllRecords() {
        records.removeAll()
        onRecordsChanged()
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        return formatter.string(from: date)
    }
}

#Preview {
    ContentView()
}
