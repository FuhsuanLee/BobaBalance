# 🧋 BobaBalance

一個用來記錄手搖飲攝取的 iOS App  
幫助使用者了解自己的熱量、咖啡因攝取，並提供健康建議  

---

## 📱 App Preview
<img width="402" height="830" alt="image" src="https://github.com/user-attachments/assets/a7d7d3d9-bfff-4fff-95ef-1f88e4129381" />

---

## ✨ Features

- 📌 記錄飲料（種類、糖度）
- 🔢 自動計算熱量與咖啡因
- 📊 本月統計（總熱量、咖啡因、杯數）
- ⚠️ 健康建議（根據攝取狀況提供提醒）
- 🗑️ 支援刪除紀錄
- 🕒 顯示每筆飲料時間
- 🎨 UI 卡片式設計

---

## 🧠 Health Logic

系統會根據以下條件提供建議：

- 熱量過高（> 1500 kcal）
- 咖啡因過高（> 400 mg）
- 飲料次數過多（≥ 5 杯）

當多個條件同時成立時，會顯示多條建議  

---

## 🛠️ Tech Stack

- UIKit
- Storyboard（Drag & Drop UI）
- Swift
- MVC 架構（基本）

---

## 🚀 How to Run

1. Clone 專案
```bash
git clone https://github.com/FuhsuanLee/BobaBalance.git
```
2. 用 Xcode 開啟 .xcodeproj
3. 選擇 Simulator 並執行
