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
    
    private let viewModel = CurrencyViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseCurrencyPicker.delegate = self
        baseCurrencyPicker.dataSource = self
        
        ratesCollectionView.delegate = self
        ratesCollectionView.dataSource = self
        ratesCollectionView.register(CurrencyCell.self, forCellWithReuseIdentifier: CurrencyCell.identifier)
        ratesCollectionView.backgroundColor = .white
        
       
        
        viewModel.$rates
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.refreshControl.endRefreshing()
                self?.ratesCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.fetchExchangeRates()
    }
    
    @objc private func refreshRates() {
        viewModel.fetchExchangeRates()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.currencies[row].displayName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.selectCurrency(at: row)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.rates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrencyCell.identifier, for: indexPath) as? CurrencyCell else {
            return UICollectionViewCell()
        }
        
        let sortedCurrencies = viewModel.getSortedCurrencyCodes()
        let currencyCode = sortedCurrencies[indexPath.item]
        let rate = viewModel.rates[currencyCode] ?? 0
        
        cell.configure(text: "1 \(viewModel.selectedBaseCurrency) = \(rate) \(currencyCode)")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }
}
