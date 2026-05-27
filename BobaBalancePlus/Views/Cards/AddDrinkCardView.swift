//
//  AddDrinkCardView.swift
//  BobaBalancePlus
//
//  Created by Sherry Lee on 2026/5/27.
//

import SwiftUI

struct AddDrinkCardView: View {
    @Binding var selectedBrand: String
    @Binding var selectedCategory: String
    @Binding var selectedDrinkItem: DrinkItem
    @Binding var selectedSugar: String
    
    let onAddDrink: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("新增紀錄")
                .bobaSectionTitleStyle()
            
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
                selectedCategory = "全部"
                
                if let firstItem = DrinkDataManager.drinkItems(for: newBrand).first {
                    selectedDrinkItem = firstItem
                }
            }
            
            Text("選擇分類")
                .font(.headline)

            Picker("選擇分類", selection: $selectedCategory) {
                ForEach(DrinkDataManager.categories(for: selectedBrand), id: \.self) { category in
                    Text(category).tag(category)
                }
            }
            .pickerStyle(.segmented)
            .tint(Color.bobaBrown)
            .onChange(of: selectedCategory) { newCategory in
                let items = DrinkDataManager.drinkItems(
                    for: selectedBrand,
                    category: newCategory
                )
                
                if let firstItem = items.first {
                    selectedDrinkItem = firstItem
                }
            }
            
            Text("選擇飲料")
                .font(.headline)

            Picker("選擇飲料", selection: $selectedDrinkItem) {
                ForEach(DrinkDataManager.drinkItems(for: selectedBrand, category: selectedCategory)) { item in
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
                onAddDrink()
            } label: {
                Text("＋ 新增飲料")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.bobaBrown)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
        .bobaCardStyle()
    }
}
