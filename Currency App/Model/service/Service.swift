//
//  Service.swift
//  Currency App
//
//  Created by Kerolos on 21/05/2025.
//


import Foundation
import Combine

class CurrencyNetworkService {
    private let apiKey = "fca_live_Ao03oTRD4jjg7dSVpytiiqja06ivyygwDuo3TNyP"
    private let baseURL = "https://api.freecurrencyapi.com/v1/latest"
    
    func fetchExchangeRates(baseCurrency: Currency) -> AnyPublisher<CurrencyResponse, Error> {
        guard var components = URLComponents(string: baseURL) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        components.queryItems = [
            URLQueryItem(name: "apikey", value: apiKey),
            URLQueryItem(name: "base_currency", value: baseCurrency.rawValue)
        ]
        
        guard let url = components.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: CurrencyResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
