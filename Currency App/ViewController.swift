//
//  ViewController.swift
//  Currency App
//
//  Created by Kerolos on 21/05/2025.
//

import UIKit
import Combine

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var baseCurrencyPicker: UIPickerView!
    @IBOutlet weak var ratesCollectionView: UICollectionView!
    
    private let apiKey = "fca_live_Ao03oTRD4jjg7dSVpytiiqja06ivyygwDuo3TNyP"
    private var cancellables = Set<AnyCancellable>()
    
    private var rates: [String: Double] = [:]
    private var currencies = Currency.allCases
    private var selectedBaseCurrency: Currency = .USD
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseCurrencyPicker.delegate = self
        baseCurrencyPicker.dataSource = self
        
        
        ratesCollectionView.delegate = self
        ratesCollectionView.dataSource = self
        ratesCollectionView.register(CurrencyCell.self, forCellWithReuseIdentifier: CurrencyCell.identifier)
        ratesCollectionView.backgroundColor = .white
        
        
        fetchExchangeRates()
    }
    
    @objc private func refreshRates() {
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
            .sink(receiveCompletion: { [weak self] completion in
                self?.refreshControl.endRefreshing()
                
                switch completion {
                case .finished:
                    print("Successfully loaded")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }, receiveValue: { [weak self] response in
                self?.rates = response.data
                self?.ratesCollectionView.reloadData()
            })
            .store(in: &cancellables)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row].displayName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedBaseCurrency = currencies[row]
        fetchExchangeRates()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrencyCell.identifier, for: indexPath) as? CurrencyCell else {
            return UICollectionViewCell()
        }
        
        let sortedCurrencies = rates.keys.sorted()
        
        let currencyCode = sortedCurrencies[indexPath.item]
        let rate = rates[currencyCode] ?? 0
        
        cell.configure(text: "1 \(selectedBaseCurrency) = \(rate) \(currencyCode)")
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }
}
