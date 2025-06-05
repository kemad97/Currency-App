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
    case CAD = "CAD"
    case CHF = "CHF"
    case CNY = "CNY"
    case INR = "INR"
    
    var symbol: String {
        switch self {
        case .USD: return "$"
        case .EUR: return "€"
        case .GBP: return "£"
        case .JPY: return "¥"
        case .AUD: return "A$"
        case .CAD: return "C$"
        case .CHF: return "CHF"
        case .CNY: return "¥"
        case .INR: return "₹"
        }
    }
   
    
    var displayName: String {
        return "\(rawValue)"
    }
}
