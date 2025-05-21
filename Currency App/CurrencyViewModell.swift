//
//  CurrencyViewModell.swift
//  Day4 Combine Swift
//
//  Created by Kerolos on 21/05/2025.
//

import Foundation
import Combine

class CurrencyViewModel {
    @Published var rates: [String: Double] = [:]
    
    let currencies = Currency.allCases
    var selectedBaseCurrency: Currency = .USD
    
    private let apiKey = "fca_live_Ao03oTRD4jjg7dSVpytiiqja06ivyygwDuo3TNyP"
    private var cancellables = Set<AnyCancellable>()
    
    func fetchExchangeRates() {
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
                if case .failure(let error) = completion {
                    print("Error: \(error)")
                }
            }, receiveValue: { [weak self] response in
                self?.rates = response.data
            })
            .store(in: &cancellables)
    }
    
    func updateBaseCurrency(_ currency: Currency) {
        selectedBaseCurrency = currency
        fetchExchangeRates()
    }
    
    func selectCurrency(at index: Int) {
        updateBaseCurrency(currencies[index])
    }
    
    func getSortedCurrencyCodes() -> [String] {
        return rates.keys.sorted()
    }
}
