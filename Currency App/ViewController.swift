//
//  ViewController.swift
//  Currency App
//
//  Created by Kerolos on 21/05/2025.
//

import UIKit
import Combine

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var baseCurrencyPicker: UIPickerView!
    @IBOutlet weak var ratesTableView: UITableView!
    
    private let apiKey = "fca_live_Ao03oTRD4jjg7dSVpytiiqja06ivyygwDuo3TNyP"
    private var cancellables = Set<AnyCancellable>()
    
    private var rates: [String: Double] = [:]
    private var currencies = Currency.allCases
    private var selectedBaseCurrency: Currency = .USD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseCurrencyPicker.delegate=self
        baseCurrencyPicker.dataSource=self
        
        ratesTableView.delegate=self
        ratesTableView.dataSource=self
        ratesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "RateCell")
        
        fetchExchangeRates()
        
    }
    
    
    private func fetchExchangeRates() {
        guard var components = URLComponents(string: "https://api.freecurrencyapi.com/v1/latest") else { return }
        
        components.queryItems = [
            URLQueryItem(name: "apikey", value: apiKey),
            URLQueryItem(name: "base_currency", value: selectedBaseCurrency.rawValue)
        ]
        
        guard let url = components.url else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: CurrencyResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Successfully loaded ")
                case .failure(let error):
                    print("Error : \(error)")
                }
            }, receiveValue: { [weak self] response in
                self?.rates = response.data
                self?.ratesTableView.reloadData()
            })
            .store(in: &cancellables)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row].displayName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedBaseCurrency = currencies[row]
        fetchExchangeRates()
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RateCell", for: indexPath)
        
        let sortedCurrencies = rates.keys.sorted()
        
        let currencyCode = sortedCurrencies[indexPath.row]
        let rate = rates[currencyCode] ?? 0

        
        cell.textLabel?.text = "1 \(selectedBaseCurrency) = \(rate) \(currencyCode)"

        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Exchange Rates (Base: \(selectedBaseCurrency.rawValue))"
    }
    
}

