//
//  CurrencyModel.swift
//  Currency App
//
//  Created by Kerolos on 21/05/2025.
//

import Foundation

struct CurrencyResponse: Decodable {
    let data: [String: Double]
}


enum Currency: String, CaseIterable, Codable {
    case USD = "USD"
    case EUR = "EUR"
    case GBP = "GBP"
    case JPY = "JPY"
    case AUD = "AUD"
   
    
    var displayName: String {
        return "\(rawValue)"
    }
}
