//
//  stock.swift
//  Stock Prices
//
//  Created by Gracie on 20/02/2025.
//

import Foundation

struct Stock: Decodable {
    let open: Double
    let close: Double
  

    enum CodingKeys: String, CodingKey {
        case open = "o"
        case close = "c"
    }
}

struct StockResponse: Decodable {
    let results: [Stock]
}


