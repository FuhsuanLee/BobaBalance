//
//  ViewController.swift
//  BobaBalance
//
//  Created by Sherry Lee on 2026/4/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var drinkPickerView: UIPickerView!
    @IBOutlet weak var sugarSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var totalCaloriesLabel: UILabel!
    @IBOutlet weak var totalCaffeineLabel: UILabel!
    @IBOutlet weak var drinkCountLabel: UILabel!
    @IBOutlet weak var healthAdviceLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addCardView: UIView!
    @IBOutlet weak var summaryCardView: UIView!
    @IBOutlet weak var adviceCardView: UIView!
    @IBOutlet weak var recordCardView: UIView!
    
    var selectedDrink = DrinkDataManager.drinks[0]
    var records: [DrinkRecord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drinkPickerView.delegate = self
        drinkPickerView.dataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        healthAdviceLabel.numberOfLines = 0
        sugarSegmentedControl.selectedSegmentIndex = 2
        
        setupCardView(addCardView)
        setupCardView(summaryCardView)
        setupCardView(adviceCardView)
        setupCardView(recordCardView)
        
        loadRecords()
        updateSummary()
    }
    
    @IBAction func addDrinkButtonTapped(_ sender: UIButton) {
        let sugarIndex = sugarSegmentedControl.selectedSegmentIndex
        let selectedSugar = DrinkDataManager.sugarLevels[sugarIndex]
        let calories = DrinkDataManager.calculateCalories(drink: selectedDrink, sugar: selectedSugar)
        let caffeine = DrinkDataManager.calculateCaffeine(drink: selectedDrink)
        
        let record = DrinkRecord(
            name: selectedDrink,
            sugarLevel: selectedSugar,
            calories: calories,
            caffeine: caffeine,
            date: Date()
        )
        
        records.append(record)
        tableView.reloadData()
        updateSummary()
        saveRecords()
    }
    
    @IBAction func clearAllRecordsTapped(_ sender: UIButton) {

        let alert = UIAlertController(
            title: "確認清除",
            message: "確定要刪除所有紀錄嗎？",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "取消", style: .cancel))

        alert.addAction(UIAlertAction(title: "刪除", style: .destructive) { _ in
            self.records.removeAll()
            self.tableView.reloadData()
            self.updateSummary()
            self.saveRecords()
        })

        present(alert, animated: true)
    }
    
    func saveRecords() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(records) {
            UserDefaults.standard.set(data, forKey: "drinkRecords")
        }
    }

    func loadRecords() {
        if let data = UserDefaults.standard.data(forKey: "drinkRecords") {
            let decoder = JSONDecoder()
            if let savedRecords = try? decoder.decode([DrinkRecord].self, from: data) {
                records = savedRecords
            }
        }
    }
    
    func updateSummary() {
        let totalCalories = records.reduce(0) { $0 + $1.calories }
        let totalCaffeine = records.reduce(0) { $0 + $1.caffeine }
        
        totalCaloriesLabel.text = "\(totalCalories) kcal"
        totalCaffeineLabel.text = "\(totalCaffeine) mg"
        drinkCountLabel.text = "\(records.count) 杯"
        
        let text = DrinkDataManager.getHealthAdvice(
            totalCalories: totalCalories,
            totalCaffeine: totalCaffeine,
            count: records.count
        )
        
        // 熱量提醒
        if totalCalories > 1500 {
            totalCaloriesLabel.textColor = .systemRed
        } else {
            totalCaloriesLabel.textColor = .label
        }
        
        // 咖啡因提醒
        if totalCaffeine > 400 {
            totalCaffeineLabel.textColor = .systemRed
        } else {
            totalCaffeineLabel.textColor = .label
        }
        
        if totalCalories > 1500 || totalCaffeine > 400 || records.count >= 5 {
            adviceCardView.backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
            healthAdviceLabel.textColor = .systemRed
        } else {
            adviceCardView.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.1)
            healthAdviceLabel.textColor = .systemGreen
        }
    }
    
    func setupCardView(_ view: UIView) {
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemBrown.withAlphaComponent(0.25).cgColor
        view.backgroundColor = UIColor.systemBackground
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 8
        
        view.clipsToBounds = false
    }
    
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return DrinkDataManager.drinks.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return DrinkDataManager.drinks[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDrink = DrinkDataManager.drinks[row]
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "DrinkCell")
        let record = records[indexPath.row]

        cell.textLabel?.text = "\(record.name)｜\(record.sugarLevel)"
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"

        let dateString = formatter.string(from: record.date)

        cell.detailTextLabel?.text =
        "\(record.calories) kcal｜咖啡因 \(record.caffeine) mg｜\(dateString)"

        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            records.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            updateSummary()
            saveRecords()
        }
    }
}
