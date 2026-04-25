//
//  ViewController.swift
//  BobaBalance
//
//  Created by Sherry Lee on 2026/4/25.
//

import UIKit

struct DrinkRecord {
    let name: String
    let sugarLevel: String
    let calories: Int
    let caffeine: Int
    let date: Date
}

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

    let drinks = ["珍珠奶茶", "紅茶", "綠茶", "烏龍茶", "水果茶", "拿鐵"]
    let sugarLevels = ["無糖", "微糖", "半糖", "少糖", "全糖"]

    var selectedDrink = "珍珠奶茶"
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

        updateSummary()
    }

    @IBAction func addDrinkButtonTapped(_ sender: UIButton) {
        let sugarIndex = sugarSegmentedControl.selectedSegmentIndex
        let selectedSugar = sugarLevels[sugarIndex]

        let calories = calculateCalories(drink: selectedDrink, sugar: selectedSugar)
        let caffeine = calculateCaffeine(drink: selectedDrink)

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
    }

    func updateSummary() {
        let totalCalories = records.reduce(0) { $0 + $1.calories }
        let totalCaffeine = records.reduce(0) { $0 + $1.caffeine }

        totalCaloriesLabel.text = "\(totalCalories) kcal"
        totalCaffeineLabel.text = "\(totalCaffeine) mg"
        drinkCountLabel.text = "\(records.count) 杯"

        healthAdviceLabel.text = getHealthAdvice(
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

    func calculateCalories(drink: String, sugar: String) -> Int {
        var baseCalories: Int

        switch drink {
        case "珍珠奶茶":
            baseCalories = 500
        case "紅茶":
            baseCalories = 180
        case "綠茶":
            baseCalories = 160
        case "烏龍茶":
            baseCalories = 150
        case "水果茶":
            baseCalories = 300
        case "拿鐵":
            baseCalories = 250
        default:
            baseCalories = 200
        }

        switch sugar {
        case "無糖":
            return Int(Double(baseCalories) * 0.45)
        case "微糖":
            return Int(Double(baseCalories) * 0.6)
        case "半糖":
            return Int(Double(baseCalories) * 0.75)
        case "少糖":
            return Int(Double(baseCalories) * 0.9)
        case "全糖":
            return baseCalories
        default:
            return baseCalories
        }
    }

    func calculateCaffeine(drink: String) -> Int {
        switch drink {
        case "珍珠奶茶":
            return 80
        case "紅茶":
            return 70
        case "綠茶":
            return 50
        case "烏龍茶":
            return 60
        case "水果茶":
            return 30
        case "拿鐵":
            return 100
        default:
            return 50
        }
    }

    func getHealthAdvice(totalCalories: Int, totalCaffeine: Int, count: Int) -> String {

        if totalCalories > 1500 {
            return "⚠️ 本月熱量過高！建議減少奶茶或改無糖飲料"
        } else if totalCaffeine > 400 {
            return "⚠️ 咖啡因過高！可能造成心悸或失眠"
        } else if count >= 5 {
            return "⚠️ 飲料次數偏多！建議適度減少"
        } else {
            return "✅ 目前狀況良好，請繼續保持！"
        }
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return drinks.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return drinks[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDrink = drinks[row]
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
        }
    }
}
